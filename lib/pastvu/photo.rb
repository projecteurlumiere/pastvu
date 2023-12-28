module Pastvu
  class Photo
    VALID_ATTRIBUTES = %w[cid s file title dir geo year]
    attr_accessor *VALID_ATTRIBUTES

    def initialize(params = {})
      params.each do |key, value|
        next unless VALID_ATTRIBUTES.include?(key)
        instance_variable_set("@#{key}", value)
      end
    end
  end
end