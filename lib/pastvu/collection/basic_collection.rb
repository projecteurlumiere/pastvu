module Pastvu
  class BasicCollection < BasicResponse
    def initialize(attr)
      attr.instance_of?(Hash) ? @hash = attr : super and return
    end
  end
end