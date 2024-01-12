module Pastvu
  class CommentCollection < Collection
    def initialize(attributes)
      super attributes
      @path = %w[result comments]
      @model = Comment
    end

    def users
      @hash ||= self.to_hash
      @hash["result"]["users"]
    end

    def photo
      Pastvu.photo @hash["result"]["cid"]
    end
  end
end