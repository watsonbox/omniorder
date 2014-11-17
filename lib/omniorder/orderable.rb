module Omniorder
  # Represents common order behavior
  # Include Omniorder::Orderable in your Order class to make it Omniorder compatible.
  module Orderable
    def build_customer(attributes = {})
      Omniorder.customer_type.new(attributes)
    end
    def add_product(product, quantity = 1)
      order_product = order_products.to_a.find { |op| op.product == product }

      if order_product.nil?
        order_products << Omniorder.order_product_type.new(:product => product, :quantity => quantity)
      else
        order_product.quantity += quantity
      end
    end

    def add_product_by_code(code, quantity = 1)
      Omniorder.product_type.find_by_code(code).tap do |product|
        add_product product, quantity
      end
    end
  end
end
