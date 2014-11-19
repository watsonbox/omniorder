module Omniorder
  module OrderProductable
    def <=>(other)
      product <=> other.product
    end

    def to_s
      quantity.to_s + 'x' + product.code
    end
  end
end
