module Pastvu
  class Photo
    # VALID_ATTRIBUTES = %w[cid s file title dir geo year ccount]
    # attr_accessor *VALID_ATTRIBUTES

    def initialize(params = {})
      params.each do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_accessor, key)
      end
    end
  end
end