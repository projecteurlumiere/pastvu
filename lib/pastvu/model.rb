module Pastvu
  class Model
    def initialize(attributes)
      attributes.each do |key, value|
        key = snakecase(key)
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_accessor, key)
      end
    end

    def to_hash
      instance_variables.each_with_object({}) do |var, object|
        var = var[1..-1]
        object[camelize(var).to_sym] = method(var).call
      end
    end

    def to_json
      Parser.to_json(to_hash)
    end

    private

    def snakecase(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def camelize(snake_cased_word, capitalize_first_letter = false)
      array = snake_cased_word.to_s.split('_').collect(&:capitalize)
      array[0]&.downcase! unless capitalize_first_letter
      array.join
    end
  end
end