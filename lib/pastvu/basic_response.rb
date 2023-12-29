require "json"

module Pastvu
  class BasicResponse
    def initialize(response_body)
      @json_body = response_body
      if Pastvu.config.ensure_successful_responses
        self.to_hash
        raise RuntimeError, "Unexpected response from the server: #{@hash_body}"  unless @hash_body["result"]
      end
    end

    def to_json
      @json_body
    end

    def to_hash
      @hash_body ||= JSON.parse(@json_body)
    end
  end
end