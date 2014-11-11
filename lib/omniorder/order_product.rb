module Omniorder
  class OrderProduct
    include OrderProductable

    ATTRIBUTES = [
      :product,
      :quantity
    ]

    attr_accessor *ATTRIBUTES

    def initialize(attributes = {})
      # Initialize known attributes
      attributes.each do |attribute, value|
        if ATTRIBUTES.include?(attribute.to_sym)
          send("#{attribute}=", value)
        end
      end
    end
  end
end
