require "json"

module Pastvu
  class BasicResponse
    attr_accessor :json, :hash

    def initialize(response_body)
      @json = response_body
      if Pastvu.config.ensure_successful_responses
        @hash = self.to_hash
        raise RuntimeError, "Unexpected response from the server: #{@hash}"  unless @hash["result"]
      end
    end

    def to_json
      @hash ? JSON.dump(@hash) : @json
    end

    def to_hash
      JSON.parse(@json)
    end
  end
end