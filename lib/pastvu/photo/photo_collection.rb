module Pastvu
  class PhotoCollection < Collection
    def initialize(attributes, params = nil)
      super attributes
      @params = params
      @path = %w[result photos]
      @model = Photo
    end

    def next(n_photos = nil)
      raise "next can be used with nearest photos requests only" if @params.nil?

      n_photos ||= @params[:limit] || 30
      # params get passed to PhotoCollection when it is a request for nearest photos on.y
      raise ArgumentError, "n_photos must be Integer between 1 & 30" unless n_photos.instance_of?(Integer) && n_photos.between?(1, 30)

      new_skip = {
        skip: (@params[:skip] || 0) + n_photos
      }

      new_params = @params.merge(new_skip)

      Pastvu.nearest_photos(geo: @params[:geo], **new_params)
    end
  end
end