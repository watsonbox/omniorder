require "net/http"
require "net/https"
require "crack"

require "omniorder/version"
require "omniorder/productable"
require "omniorder/product"
require "omniorder/orderable"
require "omniorder/order"
require "omniorder/order_productable"
require "omniorder/order_product"
require "omniorder/import_strategy/groupon"

module Omniorder
  class << self
    attr_writer :order_type
    attr_writer :order_product_type
    attr_writer :product_type

    def order_type
      @order_type || Order
    rescue NameError
      raise "Please set Omniorder#order_type"
    end

    def order_product_type
      @order_product_type || OrderProduct
    rescue NameError
      raise "Please set Omniorder#order_product_type"
    end

    def product_type
      @product_type || Product
    rescue NameError
      raise "Please set Omniorder#product_type"
    end
  end
end
