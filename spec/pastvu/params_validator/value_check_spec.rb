RSpec.describe Pastvu::ValueCheck do
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
    polygon = JSON.parse('{"type":"Polygon","coordinates":[[[37.29034423828125,55.56902805913944],[37.95501708984375,55.56902805913944],[37.95501708984375,55.92150795277898],[37.29034423828125,55.92150795277898],[37.29034423828125,55.56902805913944]]]}')
    polygon["type"] = "Point"
    [
      "random string",
      polygon
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
end