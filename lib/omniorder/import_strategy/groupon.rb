module Omniorder
  module ImportStrategy
    # Groupon Import Strategy
    # See: https://scm.commerceinterface.com/api-doc/v2/
    class Groupon < Base
      require 'json'

      API_URL = "https://scm.commerceinterface.com/api/v2/"

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
          success = yield create_order(order_info)

          if success && options[:mark_exported]
            result = Crack::JSON.parse do_request(mark_exported_url(order_info), :post)

            unless result['success']
              raise "Failed to mark Groupon order ##{order_info['orderid']} as exported (#{result['reason']})"
            end
          end
        end
      end

      def update_order_tracking!(orders)
        orders = orders.select do |order|
          if order.respond_to?(:shipping_reference) && !order.shipping_reference.nil?
            if order.external_carrier_reference.nil? || order.external_carrier_reference == ''
              raise "Cannot send tracking info for Groupon order ##{order.order_number} since it has no external_carrier_reference"
            end

            if order.order_products.any? { |op| op.external_reference.to_i == 0 }
              raise "Cannot send tracking info for Groupon order ##{order.order_number} since a line item has no external_reference"
            end

            true
          end
        end

        unless orders.empty?
          result = Crack::JSON.parse do_request(tracking_notification_url(orders), :post)
        end

        if result && result['success'].nil?
          raise "Failed to update Groupon tracking data (#{result['reason']})"
        end
      end

      def get_orders_url
        URI.join(API_URL, "get_orders?supplier_id=#{supplier_id}&token=#{access_token}")
      end

      def mark_exported_url(order_info)
        lids = order_info['line_items'].map { |li| li["ci_lineitemid"] }
        URI.join(API_URL, "mark_exported?supplier_id=#{supplier_id}&token=#{access_token}&ci_lineitem_ids=[#{lids.join(',')}]")
      end

      def tracking_notification_url(orders)
        tracking_info = orders.map do |order|
          order.order_products.map do |line_item|
            {
              "carrier" => order.external_carrier_reference,
              "ci_lineitem_id" => line_item.external_reference.to_i,
              "tracking" => order.shipping_reference
            }
          end
        end.flatten

        File.join(API_URL, "tracking_notification?supplier_id=#{supplier_id}&token=#{access_token}&tracking_info=#{tracking_info.to_json}")
      end

      private

      def create_order(order_info)
        order = import.generate_order(
          :order_number => order_info['orderid'],
          :total_price => order_info['amount']['total'].to_f,
          :date => DateTime.strptime(order_info['date'], '%m/%d/%Y %I:%M%p UTC')
        )

        order.customer = create_customer(order, order_info['customer'])

        order_info['line_items'].each do |line_item_info|
          order.add_product_by_code(
            line_item_info['sku'].to_s,
            line_item_info['quantity'].to_i,
            line_item_info['ci_lineitemid'].to_i
          )
        end

        after_build_order order, order_info
      end

      def create_customer(order, customer_info)
        # NOTE: Can't find existing customer as no username or email given
        order.generate_customer(
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

      def do_request(url, type = :get)
        host_and_path, query = url.to_s.split('?')
        uri = URI(type == :get ? url : host_and_path)
        http = Net::HTTP.new(uri.host, 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        # Send post request params in body
        if type == :get
          http.request(Net::HTTP::Get.new(uri.request_uri)).body
        else
          request = Net::HTTP::Post.new(host_and_path)
          request.body = query
          http.request(request).body
        end
      end
    end
  end
end
