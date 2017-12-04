require 'json'

class Healthcheck
  class ResponseBuilder
    SUCCESS_CODE = 200
    FAIL_CODE = 424
    HEADERS = {"Content-Type" => "application/json"}.freeze

    def initialize(results)
      @results = results
    end

    def build
      [
        status_code,
        HEADERS,
        body
      ]
    end

    private

    def status_code
      @results.success? ? SUCCESS_CODE : FAIL_CODE
    end

    def body
      [
        @results.to_h.to_json
      ]
    end
  end
end