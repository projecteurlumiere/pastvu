RSpec.describe Pastvu::ParamsValidator do
  let(:params) { { cid: 5 } }

  before { Pastvu.config.reset! }
  after { Pastvu.config.reset! }

  it "validates type by default" do
    expect(Pastvu::TypeCheck).to receive(:validate).with(params)
    described_class.validate params
  end

  it "does not validate types when configured" do
    Pastvu.configure { |c| c.check_params_type = false }

    expect(Pastvu::TypeCheck).not_to receive(:validate).with(params)
    described_class.validate params
  end

  it "validates values by default" do
    expect(Pastvu::ValueCheck).to receive(:validate).with(params)
    described_class.validate params
  end

  it "does not validate values when configured" do
    Pastvu.configure { |c| c.check_params_value = false }

    expect(Pastvu::ValueCheck).not_to receive(:validate).with(params)
    described_class.validate params
  end
end