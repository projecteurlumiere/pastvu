RSpec.describe Pastvu::Cluster do
  subject(:instance) { described_class.new cluster_attr }

  let(:cluster_attr) do
    {
      geo: [55.567462, 	37.526489],
      c: 151,
      p: {
        cid: 909367,
        file: "y/0/o/y0owcpzjjkhzxbycmu.jpg",
        title: "Бачурино",
        dir: "w",
        geo: [37.513289, 	55.571187], # for some reason lat and lon are reversed in clusters...
        year: 1969,
        year2: 1969
      }
    }
  end

  it "responds to supplied hash parameters as methods" do
    cluster_attr.each do |key, value|
      expect(instance).to respond_to(key)
      expect(instance.send(key)).to eq(value)
    end
  end

  it "responds to supplied hash parameters as methods dynamically" do
    cluster_attr[:unknown_attribute] = 0

    cluster_attr.each do |key, value|
      expect(instance).to respond_to(key)
      expect(instance.send(key)).to eq(value)
    end
  end

  it "returns photo class" do
    expect(instance.photo).to be_a Pastvu::Photo
  end

  it "returns photo class that contains correct hash" do
    expect(instance.photo.to_hash).to eq(cluster_attr[:p])
  end

  it "returns hash" do
    expect(instance.to_hash).to eq(cluster_attr)
  end

  it "returns json" do
    expect(instance.to_json).to eq(JSON.dump(cluster_attr))
  end
end