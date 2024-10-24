require "net/http"
require "open-uri"

module Pastvu
  class Request
    attr_reader :response

    def initialize(method, params)
      @method = method
      @params = params

      request(build_uri)
    end

    def self.download(uri, path)
      download = URI.parse(uri).open("User-Agent" => Pastvu.config.user_agent)
      IO.copy_stream(download, path)
      File.new(path)
    end

    def request(uri)
      Net::HTTP.get_response(uri, "User-Agent" => Pastvu.config.user_agent) do |response|
        @response = response.body
      end
    end
    
    def build_uri
      query = {
        method: @method,
        params: JSON.dump(@params)
      }

      URI::HTTPS.build(host: Pastvu.config.host,
                       path: Pastvu.config.path,
                       query: URI.encode_www_form(query))
    end
  end
end