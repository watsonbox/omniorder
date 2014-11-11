module Omniorder
  module Purchasable
    def <=>(other)
      code <=> other.code
    end
  end
end
