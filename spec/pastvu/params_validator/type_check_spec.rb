RSpec.describe Pastvu::TypeCheck do
  let(:params) do
    {
      cid: 5,
      distance: 5000,
      except: 6,
      geo: [5.2, 10.303],
      isPainting: true,
      limit: 30,
      localWork: true,
      skip: 5,
      type: "photo",
      year: 1900,
      year2: 1950,
      z: 10
    }
  end

  let(:bad_params) {
    params.transform_values { |v| v.instance_of?(String) ? 0 : v.to_s }
  }

  it "does not raise error if params are correct" do
    expect { described_class.validate params }.not_to raise_error
  end

  it "raises error if one param is incorrect" do
    bad_params.each do |k, v|
      previous_value = params[k]
      params[k] = v
      expect { described_class.validate params }.to raise_error(ArgumentError)
      params[k] = previous_value
    end
  end

  it "raises error if multiple params are incorrect" do
    expect { described_class.validate bad_params }.to raise_error(ArgumentError)
  end

  it "does not raise error if a boolean param is false" do
    params[:isPainting] = false
    expect{ described_class.validate params }.not_to raise_error

    params[:isPainting] = true
    params[:localWork] = false
    expect{ described_class.validate params }.not_to raise_error
  end
end