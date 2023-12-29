require "open-uri"

module Pastvu
  class Photo
    # VALID_ATTRIBUTES = %w[cid s file title dir geo year ccount]
    # attr_accessor *VALID_ATTRIBUTES

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_accessor, key)
      end
    end

    def download(size, path)
      raise ArgumentError, "expect size to be correct symbol" unless %i[original standard thumbnail thumb].include?(size)
      raise ArgumentError, "expect file extension to be .jpeg or .jpg" unless path[-4..-1] == ".jpg" || path[-5..-1] == ".jpeg"

      download = URI.parse(method(size).call).open
      IO.copy_stream(download, path)
      File.new(path)
    end

    def standard
      "https://pastvu.com/_p/d/".concat(file)
    end

    def original
      "https://pastvu.com/_p/a/".concat(file)
    end

    def thumbnail
      "https://pastvu.com/_p/h/".concat(file)
    end

    def thumb
      thumbnail
    end
  end
end