Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Permite requisições de qualquer origem. Para maior segurança, substitua '*' pelo seu domínio, ex: 'https://meudominio.com'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
