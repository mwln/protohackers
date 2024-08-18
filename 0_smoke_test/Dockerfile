FROM elixir:latest
WORKDIR /app
COPY mix.exs ./
RUN mix deps.get
COPY . .
RUN mix compile
EXPOSE 4040
CMD ["elixir", "-S", "mix", "start"]
