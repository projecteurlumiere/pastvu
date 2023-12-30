module Pastvu
  class PhotoCollection < Collection
    include Enumerable

    def initialize(attributes)
      super attributes
      @path = %w[result photos]
      @model = Photo
    end
  end
end