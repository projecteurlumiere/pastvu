module Pastvu
  class Collection < BasicResponse
    include Enumerable

    def initialize(attr)
      attr.instance_of?(Hash) ? @hash = attr : super
    end

    def each
      return to_enum(:each) unless block_given?

      @hash ||= self.to_hash

      reduce_hash.each do |model_hash|
        yield @model.new model_hash
      end
    end

    private

    def reduce_hash
      @path.reduce(@hash) do |hash, path_key|
        hash.fetch(path_key)
      end
    end
  end
end