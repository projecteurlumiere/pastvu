module Pastvu
  class CommentaryCollection < BasicResponse
    include Enumerable

    def initialize(response_body)
      super response_body
      self.to_hash
    end

    def each

      @hash_body["result"]["comments"].each do |comment_hash|
        yield Commentary.new comment_hash
      end
    end

    def users
      @hash_body["result"]["users"]
    end
  end
end