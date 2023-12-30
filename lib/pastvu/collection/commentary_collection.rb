module Pastvu
  class CommentaryCollection < BasicCollection
    include Enumerable

    def each
      @hash ||= self.to_hash
      @hash["result"]["comments"].each do |comment_hash|
        yield Commentary.new comment_hash
      end
    end

    def users
      @hash ||= self.to_hash
      @hash["result"]["users"]
    end
  end
end