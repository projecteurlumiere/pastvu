require "json"

module Pastvu
  class BasicResponse
    def initialize(response_body)
      @response_body = response_body
    end

    def to_json
      @response_body
    end

    def to_hash
      @parsed_response_body ||= JSON.parse(@response_body)
    end
  end
end