module Omniorder
  class OrderProduct < Entity
    include OrderProductable

    attributes :product, :quantity
  end
end
