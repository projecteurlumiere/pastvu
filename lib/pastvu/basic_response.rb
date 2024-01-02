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
      @hash ? Parser.to_json(@hash) : @json
    end

    def to_hash
      @hash || Parser.to_hash(@json)
    end
  end
end