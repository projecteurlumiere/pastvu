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
  end
end