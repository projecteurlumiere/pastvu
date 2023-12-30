module Pastvu
  class Cluster < Model
    def photo
      Photo.new @p
    end
  end
end
