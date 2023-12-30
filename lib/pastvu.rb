# frozen_string_literal: true

require "bundler"
Bundler.require

require "json"

require_relative "pastvu/version"
require_relative "pastvu/configuration"
require_relative "pastvu/request"
require_relative "pastvu/basic_response"
require_relative "pastvu/bound_response"
require_relative "pastvu/collection"
require_relative "pastvu/model"
require_relative "pastvu/collection/cluster_collection"
require_relative "pastvu/collection/commentary_collection"
require_relative "pastvu/collection/photo_collection"
require_relative "pastvu/model/cluster"
require_relative "pastvu/model/commentary"
require_relative "pastvu/model/photo"

module Pastvu
  class Error < StandardError; end

  METHODS = {
    photo_info: "photo.giveForPage",
    comments: "comment.giveForObj",
    nearest_photos: "photo.giveNearestPhotos",
    by_bounds: "photo.getByBounds"
  }

  def self.photo_info(cid)
    raise ArgumentError, "id must be integer" unless cid.instance_of? Integer

    params = {
      cid: cid
    }

    BasicResponse.new request(__method__, params)
  end

  def self.comments(cid)
    raise ArgumentError, "id must be integer" unless cid.instance_of? Integer

    params = {
      cid: cid
    }

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

    PhotoCollection.new request(__method__, params)
  end

  def self.by_bounds(geometry:, z:, **params)
    geometry = format_geojson(geometry)
    raise ArgumentError, "z must be Integer" unless z.instance_of?(Integer)
    params[:localWork] = true if z >= 17

    params = {
      geometry: geometry,
      z: z,
      isPainting: params[:isPainting] || params[:is_painting],
      year: params[:year],
      year2: params[:year2],
      localWork: params[:localWork] || params[:local_work]
    }.compact

    BoundResponse.new request(__method__, params)
  end

  def self.request(method, params)
    Request.new(METHODS[method], params).response
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.format_geojson(geometry)
    geometry = geometry.instance_of?(Hash) ? geometry : JSON.parse(geometry)
    permitted_types  = %w[Polygon Multipolyigon]
    raise ArgumentError, "expect geojson geometry type to be in #{permitted_types}" unless permitted_types.any? { |t| t == geometry["type"] }

    #? do I need validating geojson?
    # geojson = Geojsonlint.validate(geometry)
    # raise ArgumentError, "geometry must be valid geoJSON string or hash. Errors are: #{geojson.errors}" unless geojson.valid?

    geometry
  end

  def self.configure(&block)
    config.configure(&block)
  end
end
