require "net/http"
require "addressable"
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
      uri = Addressable::URI.new({ scheme: 'https', host: Pastvu.config.host })

      template = Addressable::Template.new(uri.to_s + "{/path*}" + "{?query*}")

      template.expand({
        "path" => Pastvu.config.path,
        "query" => {
          "method" => @method,
          "params" => JSON.dump(@params)
        }
      })
    end
  end
end