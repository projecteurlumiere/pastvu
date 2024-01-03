RSpec.describe Pastvu::Parser do
  let(:hash) do
  {
    s: 5,
    cid: 449459,
    file: "t/t/m/ttmrs80811yfro4md7.jpeg",
    title: "View of the Marin Tower of the Golden Gate Bridge under construction",
    dir: "nw",
    geo: [37.82287, -122.47985],
    year: 1934
  }
  end

  it "dumps hash and parses back without errors" do
    expect { described_class.to_json hash }.not_to raise_error
    json = described_class.to_json hash
    expect(described_class.to_json hash).to be_a String
    expect(described_class.to_hash json).to eq(hash.transform_keys(&:to_s))
  end
end