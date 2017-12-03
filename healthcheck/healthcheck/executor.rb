class Healthcheck
  class Executor
    attr_reader :results

    def initialize
      @results = CheckResults.new
    end

    def execute_checks
      Healthcheck.checks.each { |check_name, check| execute_check(check_name, check) }
    end

    private

    def execute_check(check_name, check)
      @results.push check_name, !!check.call
    end
  end
end