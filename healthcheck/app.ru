require_relative './healthcheck'

app = ->(env) do
  [200, {}, ['Hey there!']]
end

Healthcheck.configure do
  add_check :real_world, -> { true == false }
end

run Healthcheck::Middleware.new(app)