# The shop's website reads the public price list from another origin.
# Only the published page and the local server used while developing are allowed;
# the routes that need a token are not opened to any origin.
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://javinaxxa.github.io", "http://localhost:8000", "http://127.0.0.1:8000"

    resource "/api/v1/services", headers: :any, methods: [:get]
    resource "/api/v1/services/*", headers: :any, methods: [:get]
  end
end
