module Pastvu
  class PhotoCollection < BasicResponse
    include Enumerable

    def each
      @hash ||= self.to_hash
      @hash["result"]["photos"].each do |photo_hash|
        yield Photo.new photo_hash
      end
    end
  end
end