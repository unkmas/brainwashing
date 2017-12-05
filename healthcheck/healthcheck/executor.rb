module Healthcheck
  class Executor
    attr_reader :results

    def initialize(config)
      @config = config
      @results = CheckResults.new
    end

    def execute_checks
      @config.checks.each do |check_name, check|
        @results.push check_name, execute_check(check)
      end
    end

    private

    def execute_check(check)
      !!check.call
    rescue
      false
    end
  end
end