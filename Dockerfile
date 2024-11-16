# syntax = docker/dockerfile:1

# Define a versão do Ruby
ARG RUBY_VERSION=3.0.0
FROM ruby:$RUBY_VERSION-slim as base

# Defina o diretório de trabalho
WORKDIR /rails

# Defina as variáveis de ambiente de produção
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test" \
    SECRET_KEY_BASE_DUMMY="1"

# Atualize pacotes e instale dependências necessárias
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Etapa de construção para reduzir o tamanho da imagem final
FROM base as build

# Instale pacotes necessários para construir as gemas
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config

# Copie Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instale as dependências Ruby usando o Bundler
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copie o código da aplicação para a imagem
COPY . .

# Pré-compile o código do Bootsnap e os ativos para melhorar os tempos de inicialização
RUN bundle exec bootsnap precompile app/ lib/ && \
    RAILS_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE_DUMMY bundle exec rails assets:precompile

# Imagem final para produção
FROM base

# Copie os artefatos construídos: gemas e código da aplicação
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Crie um usuário não-root para segurança e configure permissões
RUN useradd -m -s /bin/bash rails && \
    chown -R rails:rails /rails/db /rails/log /rails/storage /rails/tmp
USER rails

# Defina o entrypoint para preparar o banco de dados
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Exponha a porta 3000 e inicie o servidor
EXPOSE 3000
CMD ["./bin/rails", "server"]
