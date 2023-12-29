require "json"

module Pastvu
  class Commentary
    def initialize(attributes)
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_accessor, key)
      end

      populate_replies unless @comments.nil?
    end

    def replies
      @replies
    end

    def replies=(value)
      @replies = value
    end

    def last_changed
      @lastChanged
    end

    def last_changed=(value)
      @lastChanged = value
    end

    def to_hash
      instance_variables.each_with_object({}) do |var, object|
        next if var == :@replies

        var = var[1..-1]
        object[var.to_sym] = method(var).call
      end
    end

    def to_json
      JSON.dump(to_hash)
    end

    private

    def populate_replies
      @replies = @comments.map do |comment|
        Commentary.new comment
      end
    end
  end
end