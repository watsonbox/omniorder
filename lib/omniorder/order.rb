module Omniorder
  class Order
    include Orderable

    ATTRIBUTES = [
      :order_products,
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

      self.order_products ||= []
    end
  end
end
