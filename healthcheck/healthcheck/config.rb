module Healthcheck
  class Config
    def self.build(&block)
      new.tap(&block)
    end

    AlreadyRegisteredCheck = Class.new(StandardError)

    attr_reader :checks

    def initialize
      @checks = {}
    end

    def add_check(check_name, lambda)
      raise AlreadyRegisteredCheck if @checks.key?(:check_name)

      @checks[check_name] = lambda
    end
  end
end