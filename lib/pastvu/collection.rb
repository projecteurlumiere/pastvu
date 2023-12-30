module Pastvu
  class Collection < BasicResponse
    def initialize(attr)
      attr.instance_of?(Hash) ? @hash = attr : super and return
    end

    def each
      @hash ||= self.to_hash

      reduce_hash.each do |model_hash|
        yield @model.new model_hash
      end
    end

    private

    def reduce_hash
      @path.reduce(@hash) do |new_hash, key, _value|
        new_hash.fetch(key)
      end
    end
  end
end