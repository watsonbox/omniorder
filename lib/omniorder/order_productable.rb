module Omniorder
  module OrderProductable
    def <=>(other)
      product <=> other.product
    end
  end
end
