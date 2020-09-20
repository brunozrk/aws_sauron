FROM elixir:1.10-alpine AS base

# install build dependencies
RUN apk add --no-cache build-base npm git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

#------------------------------- BUILD -------------------------------#
FROM base AS build

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY apps/server/mix.exs apps/server/
COPY apps/web/mix.exs apps/web/

RUN mix do deps.get --only $MIX_ENV, deps.compile

# build assets
COPY apps/web/assets/package.json apps/web/assets/package-lock.json ./apps/web/assets/

RUN npm --prefix ./apps/web/assets ci --progress=false --no-audit --loglevel=error

COPY .releaserc .releaserc
COPY .git .git

#------------------------------- ERLANG_RELEASE -------------------------------#
FROM build as erlang_release

COPY apps/web/priv apps/web/priv
COPY apps/web/assets apps/web/assets
RUN npm run --prefix ./apps/web/assets deploy
RUN mix phx.digest

# compile and build release
COPY . .
RUN mix do compile, release

#------------------------------- APP -------------------------------#
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=erlang_release --chown=nobody:nobody /app/_build/prod/rel/aws_sauron ./

ENV HOME=/app

EXPOSE 4000

CMD ["bin/aws_sauron", "start"]
