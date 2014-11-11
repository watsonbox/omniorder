module Omniorder
  module ImportStrategy
    class Groupon
      API_URL = "https://scm.commerceinterface.com/api/v2"

      attr_accessor :options
      attr_accessor :supplier_id, :access_token

      def initialize(options = {})
        self.options = options

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
        Omniorder.order_type.new(
          :order_number => order_info['orderid'],
          :total_price => order_info['amount']['total'].to_f,
          :date => DateTime.strptime(order_info['date'], '%m/%d/%Y %I:%M%p UTC')
        )
      end

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
