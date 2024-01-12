RSpec.describe Pastvu::ValueCheck do
  let(:params) do
    {
      cid: 5,
      distance: 5000,
      except: 6,
      geo: [5.2, 10.303],
      geometry: Pastvu::Parser.to_hash('{"coordinates":[[[2.34218629483172,48.88623415508624],[2.34218629483172,48.88425956838617],[2.3449771858020085,48.88425956838617],[2.3449771858020085,48.88623415508624],[2.34218629483172,48.88623415508624]]],"type":"Polygon"}'),
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

  let(:bad_params) do
    {
      distance: [-1, 1000000000],
      geo: bad_geo_params,
      geometry: bad_geometry_params,
      limit: [-1, 31],
      type: "sketch"
    }
  end

  let(:bad_geo_params) do
    [
      [5.2, 10.303, 40.434],
      ["5.2", 10.303],
      ["5.2", "10.303"]
    ]
  end

  let(:bad_geometry_params) do
    params[:geometry]["type"] = "Point"
    [
      "random string",
      params[:geometry]
    ]
  end

  it "does not raise error if params are correct" do
    expect { described_class.validate params }.not_to raise_error
  end

  it "raises error if a single param is incorrect" do
    bad_params.each do |k, v|
      v.instance_of?(Array) ? v : v = [] << v
      v.each do |p|
        previous_value = params[k]
        params[k] = p
        expect { described_class.validate params }.to raise_error(ArgumentError)
        params[k] = previous_value
      end
    end
  end

  it "raises error if multiple params are incorrect" do
    bad_params.transform_values! { |v| v.instance_of?(Array) ? v.sample : v }
    expect { described_class.validate bad_params }.to raise_error(ArgumentError)
  end

  it "does not raise an error if type param is of inconsistent register" do
    params[:type] = "PhOtO"

    expect { described_class.validate params }.not_to raise_error
  end

  it "raises ArgumentError if geometry's type is of inconsistent register" do
    params[:geometry]["type"] = "PoLyGoN"

    expect { described_class.validate params }.to raise_error(ArgumentError)
  end
end