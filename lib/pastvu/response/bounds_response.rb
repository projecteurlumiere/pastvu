module Pastvu
  class BoundsResponse < BasicResponse
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