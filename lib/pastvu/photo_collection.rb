module Pastvu
  class PhotoCollection < BasicResponse
    include Enumerable

    def initialize(response_body)
      super response_body
      @hash ||= self.to_hash
    end

    def each
      @hash["result"]["photos"].each do |photo_hash|
        yield Photo.new photo_hash
      end
    end
  end
end