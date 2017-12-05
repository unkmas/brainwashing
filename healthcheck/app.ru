require_relative './healthcheck'

app = ->(env) do
  [200, {}, ['Hey there!']]
end

app = Rack::Builder.new do
  map '/alive' do
    healthcheck =  Healthcheck::Middleware.build do |config|
      config.add_check :real_world, -> { true == true }
    end

    run healthcheck
  end

  run proc { |_| [200, { 'Content-Type' => 'text/plain' }, ['OK']] }
end

run app