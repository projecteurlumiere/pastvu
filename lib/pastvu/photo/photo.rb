module Pastvu
  class Photo < Model
    # VALID_ATTRIBUTES = %w[cid s file title dir geo year ccount]
    # attr_accessor *VALID_ATTRIBUTES

    def reload
      Pastvu.photo @cid
    end

    def comments
      Pastvu.comments @cid
    end

    def download(size, path)
      raise ArgumentError, "expect size to be correct symbol" unless %i[original standard thumbnail thumb].include?(size)
      raise ArgumentError, "expect file extension to be .jpeg or .jpg" unless path[-4..-1] == ".jpg" || path[-5..-1] == ".jpeg"

      Request.download(method(size).call, path)
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