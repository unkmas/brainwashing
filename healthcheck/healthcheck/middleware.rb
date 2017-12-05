module Healthcheck
  class Middleware
    def self.build(&block)
      config = Config.build(&block)
      new(config)
    end

    def initialize(config)
      @config = config
    end

    def call(env)
      executor = Executor.new(@config)
      executor.execute_checks

      ResponseBuilder.new(executor.results).build
    end
  end
end