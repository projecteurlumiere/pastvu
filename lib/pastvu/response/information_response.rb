module Pastvu
  class InformationResponse < BasicResponse
    def to_photo
      @hash ||= self.to_hash
      Photo.new @hash["result"]["photo"]
    end
  end
end