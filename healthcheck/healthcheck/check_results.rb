module Healthcheck
  class CheckResults
    CheckResult = Struct.new(:check_name, :success) do
      alias_method :success?, :success

      def to_h
        {check_name => success}
      end
    end

    def initialize
      @results = []
    end

    def push(check_name, success)
      @results.push CheckResult.new(check_name, success)
    end

    def success?
      @results.all?(&:success?)
    end

    def to_h
      @results.each_with_object({}) do |result, hash|
        hash.merge!(result.to_h)
      end
    end
  end
end