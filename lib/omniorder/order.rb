module Omniorder
  class Order < Entity
    include Orderable

    attributes :customer, :order_products, :order_number, :total_price, :date

    def initialize(attributes = {})
      super
      self.order_products ||= []
    end
  end
end
