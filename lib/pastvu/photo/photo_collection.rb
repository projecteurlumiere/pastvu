module Pastvu
  class PhotoCollection < Collection
    def initialize(attributes)
      super attributes
      @path = %w[result photos]
      @model = Photo
    end
  end
end