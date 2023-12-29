require "json"

module Pastvu
  class BasicResponse
    def initialize(response_body)
      response_body.instance_of?(Hash) ? @hash_body = response_body : @json_body = response_body
    end

    def to_json
      @json_body ||= JSON.dump(@hash_body)
    end

    def to_hash
      @hash_body ||= JSON.parse(@json_body)
    end
  end
end