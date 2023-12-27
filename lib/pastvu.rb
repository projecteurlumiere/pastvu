# frozen_string_literal: true

require_relative "pastvu/version"
require_relative "pastvu/configuration"
require_relative "pastvu/request"
require "json"

module Pastvu
  class Error < StandardError; end

  METHODS = {
    photo_info: "photo.giveForPage",
    comments: "comment.giveForObj",
    nearest_photos: "photo.giveNearestPhotos",
    by_photos: "photo.getByBounds"
  }

  def self.photo_info(id)
    raise(ArgumentError, "id must be integer") unless id.instance_of? Integer

    params = {
      cid: id
    }

    request(__method__, params)
  end

  def self.comments(id)
    raise(ArgumentError, "id must be integer") unless id.instance_of? Integer

    params = {
      cid: id
    }

    request(__method__, params)
  end

  def self.nearest_photos(*args)
  end

  def self.by_bounds(*args)
  end

  def self.request(method, params)
    response = Request.new(METHODS[method], params).response

    case config.output_format
    when :json
      response
    when :hash
      JSON.parse(response)
    end
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure(&block)
    config.configure(&block)
  end
end
