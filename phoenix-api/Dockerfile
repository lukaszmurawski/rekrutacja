FROM elixir:1.17.3

ARG PHOENIX_VERSION=1.7.14
RUN apt-get update \
  && apt-get install -y bash curl git build-essential inotify-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new ${PHOENIX_VERSION} --force

WORKDIR /app

EXPOSE 4000

CMD ["mix", "phx.server"]