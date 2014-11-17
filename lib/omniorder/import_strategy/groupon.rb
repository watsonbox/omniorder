module Omniorder
  module ImportStrategy
    # Groupon Import Strategy
    # See: https://scm.commerceinterface.com/api-doc/v2/
    class Groupon < Base
      API_URL = "https://scm.commerceinterface.com/api/v2/"

      attr_accessor :options
      attr_accessor :supplier_id, :access_token

      def initialize(import, options = {})
        super

        unless self.supplier_id = options[:supplier_id] and !supplier_id.to_s.empty?
          raise "Omniorder::ImportStrategy::Groupon requires a supplier_id"
        end

        unless self.access_token = options[:access_token] and !access_token.to_s.empty?
          raise "Omniorder::ImportStrategy::Groupon requires an access_token"
        end
      end

      def import_orders
        get_order_info['data'].to_a.each do |order_info|
          yield create_order(order_info)
        end
      end

      def get_orders_url
        URI.join(API_URL, "get_orders?supplier_id=#{supplier_id}&token=#{access_token}")
      end

      private

      def create_order(order_info)
        order = import.build_order(
          :order_number => order_info['orderid'],
          :total_price => order_info['amount']['total'].to_f,
          :date => DateTime.strptime(order_info['date'], '%m/%d/%Y %I:%M%p UTC')
        )

        order.customer = create_customer(order, order_info['customer'])

        order_info['line_items'].each do |line_item_info|
          order.add_product_by_code(line_item_info['sku'].to_s, line_item_info['quantity'].to_i)
        end

        order
      end

      def create_customer(order, customer_info)
        # NOTE: Can't find existing customer as no username or email given
        order.build_customer(
          :name => customer_info['name'],
          :phone => customer_info['phone'],
          :address1 => customer_info['address1'],
          :address2 => customer_info['address2'],
          :address3 => customer_info['city'],
          :address4 => customer_info['state'],
          :postcode => customer_info['zip'].to_s.squeeze(' ').upcase,
          :country => customer_country_or_default(customer_info['country'])
        )
      end

      # NOTE: We don't appear to get an email address for customers
      def get_order_info
        Crack::JSON.parse do_request(get_orders_url)
      end

      private

      def do_request(url)
        uri = URI(url)
        http = Net::HTTP.new(uri.host, 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.request(Net::HTTP::Get.new(uri.request_uri)).body
      end
    end
  end
end
