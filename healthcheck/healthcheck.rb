require_relative 'healthcheck/middleware'
require_relative 'healthcheck/response_builder'
require_relative 'healthcheck/executor'
require_relative 'healthcheck/check_results'

class Healthcheck
  @checks = {}
  @path = '/alive'

  AlreadyRegisteredCheck = Class.new(StandardError)

  class << self
    attr_reader :checks, :path

    def add_check(check_name, lambda)
      raise AlreadyRegisteredCheck if @checks.key?(:check_name)

      @checks[check_name] = lambda
    end

    def configure(&block)
      instance_eval(&block) if block_given?
    end
  end
end