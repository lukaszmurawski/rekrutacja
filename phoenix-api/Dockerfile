FROM elixir:1.17.3

ARG PHOENIX_VERSION=1.7.14

# Instalacja tylko niezbędnych narzędzi
RUN apt-get update \
  && apt-get install -y bash curl git inotify-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Konfiguracja mix
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new ${PHOENIX_VERSION} --force

WORKDIR /app

# Ustawienie środowiska development
ENV MIX_ENV=dev

# Kopiowanie tylko plików zależności
COPY mix.exs mix.lock ./

# Pobierz i skompiluj zależności
RUN mix deps.get
RUN mix deps.compile
COPY . .

# Skompiluj aplikację (tylko podstawowa kompilacja)
RUN mix compile

EXPOSE 4000

# Uruchom serwer - zależności będą rekompilowane automatycznie
CMD ["mix", "phx.server"]