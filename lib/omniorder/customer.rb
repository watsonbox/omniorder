module Omniorder
  class Customer < Entity
    include Customerable

    attributes :username, :name, :phone, :email, :address1, :address2, :address3, :address4, :postcode, :country
  end
end
