require 'spec_helper'

describe Omniorder::ImportStrategy::Base do
  let(:strategy_class) { Class.new(Omniorder::ImportStrategy::Base) }

  context 'with a global option' do
    around do |example|
      strategy_class.options global_option: true
      example.run
      strategy_class.clear_options
    end

    it 'includes the global options' do
      expect(strategy_class.new(nil, local_option: true).options).to eq(global_option: true, local_option: true)
    end
  end

  describe '.from_name' do
    it 'selects a specific strategy from its name' do
      expect(Omniorder::ImportStrategy::Base.from_name(:groupon)).to eq(Omniorder::ImportStrategy::Groupon)
    end
  end
end
