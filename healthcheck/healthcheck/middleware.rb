class Healthcheck
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      return @app.call(env) unless env['PATH_INFO'] == Healthcheck.path

      executor = Executor.new
      executor.execute_checks

      ResponseBuilder.new(executor.results).build
    end
  end
end