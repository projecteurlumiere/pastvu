require "uri"
require "net/http"

module Pastvu
  class Request
    attr_reader :response

    def initialize(method, params)
      @method = method
      @params = params

      request(build_uri)
    end

    def request(uri)
      Net::HTTP.get_response(uri) do |response|
        @response = response.body
      end
    end

    def build_uri
      query = URI.encode_www_form({
        method: @method,
        params: JSON.dump(@params)
      })

      URI::HTTPS.build(host: Pastvu.config.host, path: Pastvu.config.path, query: query)
    end
  end
end