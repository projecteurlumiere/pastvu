# frozen_string_literal: true

require_relative "pastvu/version"
require_relative "pastvu/configuration"
require_relative "pastvu/request"
require_relative "pastvu/basic_response"
require_relative "pastvu/model"
require_relative "pastvu/collection"
require_relative "pastvu/parser"
require_relative "pastvu/params_validator"

require_relative "pastvu/response/bound_response"
require_relative "pastvu/response/information_response"
require_relative "pastvu/cluster/cluster_collection"
require_relative "pastvu/cluster/cluster"
require_relative "pastvu/commentary/commentary_collection"
require_relative "pastvu/commentary/commentary"
require_relative "pastvu/photo/photo_collection"
require_relative "pastvu/photo/photo"

require_relative "pastvu/params_validator/type_check"
require_relative "pastvu/params_validator/value_check"

module Pastvu
  METHODS = {
    photo_info: "photo.giveForPage",
    comments: "comment.giveForObj",
    nearest_photos: "photo.giveNearestPhotos",
    by_bounds: "photo.getByBounds"
  }

  def self.photo_info(cid)
    # raise ArgumentError, "id must be integer" unless cid.instance_of? Integer

    params = {
      cid: cid
    }

    ParamsValidator.validate params

    InformationResponse.new request(__method__, params)
  end

  def self.photo(cid)
    self.photo_info(cid).to_photo
  end

  def self.comments(cid)
    # raise ArgumentError, "id must be integer" unless cid.instance_of? Integer

    params = {
      cid: cid
    }

    ParamsValidator.validate params

    CommentaryCollection.new request(__method__, params)
  end

  def self.nearest_photos(geo:, **params)
    params = {
      geo: geo,
      except: params[:except],
      distance: params[:distance],
      year: params[:year],
      year2: params[:year2],
      type: params[:type],
      limit: params[:limit],
      skip: params[:skip]
    }.compact

    ParamsValidator.validate params

    PhotoCollection.new request(__method__, params)
  end

  def self.by_bounds(geometry:, z:, **params)
    # geometry = format_geojson(geometry)
    # raise ArgumentError, "z must be Integer" unless z.instance_of?(Integer)
    params[:localWork] = true if z >= 17

    params = {
      geometry: geometry.instance_of?(Hash) ? geometry : Parser.to_hash(geometry),
      z: z,
      isPainting: params[:isPainting] || params[:is_painting],
      year: params[:year],
      year2: params[:year2],
      localWork: params[:localWork] || params[:local_work]
    }.compact

    ParamsValidator.validate params

    BoundResponse.new request(__method__, params)
  end

  def self.request(method, params)
    Request.new(METHODS[method], params).response
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.format_geojson(geometry)
    #? do I need validating geojson?
    # geojson = Geojsonlint.validate(geometry)
    # raise ArgumentError, "geometry must be valid geoJSON string or hash. Errors are: #{geojson.errors}" unless geojson.valid?

    geometry
  end

  def self.configure(&block)
    config.configure(&block)
  end
end
