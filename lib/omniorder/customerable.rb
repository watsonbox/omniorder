module Omniorder
  module Customerable
    def username_is_email?
      username == email
    end

    def first_names
      name.split[0...-1]
    end

    def first_name
      first_names.first
    end

    def last_name
      name.split.last
    end

    def full_address
      fields = [address1, address2, address3, address4, postcode, country]
      fields.reject { |f| f.nil? || f.empty? }.join("\n")
    end

    def self.get_or_new_from_email(email, attributes = {})
      customer = nil

      if Omniorder.customer_type.respond_to?(:find_by_email)
        customer = Omniorder.customer_type.find_by_email(email)
      end

      if customer
        attributes.each do |name, value|
          customer.send("#{name}=", value)
        end
      else
        Omniorder.customer_type.new(attributes)
      end

      customer
    end
  end
end
