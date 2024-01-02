module Pastvu
  class CommentaryCollection < Collection
    def initialize(attributes)
      super attributes
      @path = %w[result comments]
      @model = Commentary
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