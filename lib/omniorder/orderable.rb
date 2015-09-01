module Omniorder
  # Represents common order behavior
  # Include Omniorder::Orderable in your Order class to make it Omniorder compatible.
  module Orderable
    # Use generate not build so as not to conflict with ActiveRecord
    def generate_customer(attributes = {})
      Omniorder.customer_type.new(attributes)
    end

    def add_product(product, quantity = 1, external_reference = nil)
      order_product = order_products.to_a.find { |op| op.product == product }

      if order_product.nil?
        order_products << Omniorder.order_product_type.new(
          :product => product,
          :quantity => quantity,
          :external_reference => external_reference
        )
      else
        order_product.quantity += quantity
      end
    end

    def add_product_by_code(code, quantity = 1, external_reference = nil)
      Omniorder.product_type.find_by_code(code).tap do |product|
        add_product product, quantity, external_reference unless product.nil?
      end
    end

    def product_count
      order_products.inject(0) { |sum, op| sum + op.quantity }
    end

    def unique_product_count
      order_products.count
    end

    # Human-readable string representing order products
    def product_list
      order_products.sort.map(&:to_s).join('/')
    end
  end
end
