module Pastvu
  class BoundResponse < BasicResponse
    def clusters
      @hash ||= self.to_hash
      ClusterCollection.new @hash
    end

    def photos
      @hash ||= self.to_hash
      PhotoCollection.new @hash
    end
  end
end