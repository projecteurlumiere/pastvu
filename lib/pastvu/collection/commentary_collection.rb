module Pastvu
  class CommentaryCollection < Collection
    include Enumerable

    def initialize(attributes)
      super attributes
      @path = %w[result comments]
      @model = Commentary
    end

    def users
      @hash ||= self.to_hash
      @hash["result"]["users"]
    end
  end
end