module Omniorder
  class Product < Entity
    include Purchasable

    attributes :code

    # This implementation assumes the product to exist
    def self.find_by_code(code)
      new(:code => code)
    end
  end
end
