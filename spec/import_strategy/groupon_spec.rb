require 'spec_helper'

describe Omniorder::ImportStrategy::Groupon do
  let(:import) { Omniorder::Import.new }
  let(:strategy) { Omniorder::ImportStrategy::Groupon.new(import, strategy_options) }
  let(:strategy_options) { { supplier_id: '1', access_token: 'xYRPKcoakMoiRzWgKLV5TqPSdNAaZQT' } }

  before do
    stub_request(
      :get,
      "https://scm.commerceinterface.com/api/v2/get_orders?supplier_id=1&token=xYRPKcoakMoiRzWgKLV5TqPSdNAaZQT"
    ).to_return(
      body: File.new('spec/assets/imports/groupon/get_orders.json'),
      status: 200
    )
  end

  context 'no supplier_id is supplied' do
    let(:strategy_options) { { access_token: 'xYRPKcoakMoiRzWgKLV5TqPSdNAaZQT' } }

    it 'raises an exception' do
      expect { strategy }.to raise_exception "Omniorder::ImportStrategy::Groupon requires a supplier_id"
    end
  end

  context 'no access_token is supplied' do
    let(:strategy_options) { { supplier_id: '1' } }

    it 'raises an exception' do
      expect { strategy }.to raise_exception "Omniorder::ImportStrategy::Groupon requires an access_token"
    end
  end

  it 'imports orders with products and a customer' do
    orders = []
    strategy.import_orders { |o| orders << o }

    order = orders.first
    expect(order.order_number).to eq("FFB7A681BE")
    expect(order.total_price).to eq(10.99)
    expect(order.date.to_s).to eq("2013-05-16T08:10:00+00:00")
    expect(order.order_products.count).to eq(1)

    order_product = order.order_products.first
    expect(order_product.quantity).to eq(3)
    expect(order_product.product.code).to eq('03658246')

    customer = order.customer
    expect(customer.name).to eq("SOME BODY HERE")
    expect(customer.phone).to eq("01234 982103")
    expect(customer.address1).to eq("901")
    expect(customer.address2).to eq("GREENFIELDS LANE")
    expect(customer.address3).to eq("BRADFORD")
    expect(customer.address4).to eq("KENT")
    expect(customer.postcode).to eq("SOME ZIP")
    expect(customer.country).to eq("UK")
  end

  context 'the mark_exported option is set' do
    let(:strategy_options) { { supplier_id: '1', access_token: 'xYRPKcoakMoiRzWgKLV5TqPSdNAaZQT', mark_exported: true } }

    let(:mark_exported_result) { '{ "success": true }' }
    let!(:mark_exported_stub) do
      stub_request(
        :post,
        "https://scm.commerceinterface.com/api/v2/mark_exported"
      ).with(
        body: "supplier_id=1&token=xYRPKcoakMoiRzWgKLV5TqPSdNAaZQT&ci_lineitem_ids=[54553920,54553921]"
      ).to_return(
        body: mark_exported_result,
        status: 200
      )
    end

    it 'marks orders as exported when the order handler is truthy' do
      strategy.import_orders { |o| true if o.order_number == "FFB7A68990" }
      expect(mark_exported_stub).to have_been_requested.once
    end

    context "mark exported API call fails" do
      let(:mark_exported_result) { '{ "success": false, "reason": "Something went wrong" }' }

      it 'raises an exception' do
        expect {
          strategy.import_orders { |o| true if o.order_number == "FFB7A68990" }
        }.to raise_exception "Failed to mark Groupon order #FFB7A68990 as exported (Something went wrong)"
      end
    end
  end
end
