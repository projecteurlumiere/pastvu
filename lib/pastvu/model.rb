module Pastvu
  class Model
    def initialize(attributes)
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_accessor, key)
      end
    end

    def to_hash
      instance_variables.each_with_object({}) do |var, object|
        var = var[1..-1]
        object[var.to_sym] = method(var).call
      end
    end

    def to_json
      JSON.dump(to_hash)
    end
  end
end