module Omniorder
  class OrderProduct < Entity
    include OrderProductable

    attributes :product, :quantity, :external_reference
  end
end
