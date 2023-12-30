module Pastvu
  class CommentaryCollection < BasicResponse
    include Enumerable

    def initialize(response_body)
      super response_body
      @hash ||= self.to_hash
    end

    def each
      @hash["result"]["comments"].each do |comment_hash|
        yield Commentary.new comment_hash
      end
    end

    def users
      @hash["result"]["users"]
    end
  end
end