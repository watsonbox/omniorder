require "net/http"
require "net/https"
require "crack"

require "omniorder/version"
require "omniorder/order"
require "omniorder/import_strategy/groupon"

module Omniorder
  class << self
    attr_writer :order_type

    def order_type
      @order_type || Order
    rescue NameError
      raise "Please set Omniorder#order_type"
    end
  end
end
