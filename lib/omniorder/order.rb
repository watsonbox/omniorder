module Omniorder
  class Order
    ATTRIBUTES = [
      :order_number,
      :total_price,
      :date
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
