# frozen_string_literal: true

RSpec.describe Pastvu do
  let(:success_json) { "{\"result\":{\"text\":\"success!\"}}" }
  let(:success_hash) { { "result" => { "text" => "success!" } } }

  let(:polygon_hash) { JSON.parse('{"type":"Polygon","coordinates":[[[37.29034423828125,55.56902805913944],[37.95501708984375,55.56902805913944],[37.95501708984375,55.92150795277898],[37.29034423828125,55.92150795277898],[37.29034423828125,55.56902805913944]]]}') }
  let(:polygon_json) { polygon_hash.to_json }

  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  context "when requesting photo information" do
    before do
      uri = URI.parse('https://pastvu.com/api2?method=photo.giveForPage&params={"cid":5}')

      stub_request(:get, uri).
        to_return(body: success_json)
    end

    it "returns json" do
      expect(described_class.photo_info(5).to_json).to eq(success_json)
    end

    it "returns hash" do
      expect(described_class.photo_info(5).to_h).to eq(success_hash)
    end


    it "raises ArgumentError when supplied id is not integer" do
      expect { described_class.photo_info("5") }.to raise_error(ArgumentError)
    end
  end

  context "when requesting commentaries for a photo" do
    before do
      uri = 'https://pastvu.com/api2?method=comment.giveForObj&params={"cid":23314}'

      stub_request(:get, uri).
        to_return(body: success_json)
    end

    it "returns json" do
      expect(described_class.comments(23314).to_json).to eq(success_json)
    end

    it "returns hash" do
      expect(described_class.comments(23314).to_h).to eq(success_hash)
    end

    it "raises ArgumentError when supplied id is not integer" do
      expect { described_class.comments("23314") }.to raise_error(ArgumentError)
    end
  end

  context "when requesting nearest photos" do
    before do
      uri = 'https://pastvu.com/api2?method=photo.giveNearestPhotos&params={"geo":[37.82,-122.469322],"except":228481,"limit":12}'

      stub_request(:get, uri).
        to_return(body: success_json)
    end

    it "returns json" do
      expect(described_class.nearest_photos(geo: [37.82, -122.469322], limit: 12, except: 228481).to_json).to eq(success_json)
    end

    it "returns hash" do
      expect(described_class.nearest_photos(geo: [37.82, -122.469322], limit: 12, except: 228481).to_h).to eq(success_hash)
    end
  end

  context "when requesting photos by bounds" do
    before do
      uri = 'https://pastvu.com/api2?method=photo.getByBounds&params={"geometry":{"type":"Polygon","coordinates":[[[37.29034423828125,55.56902805913944],[37.95501708984375,55.56902805913944],[37.95501708984375,55.92150795277898],[37.29034423828125,55.92150795277898],[37.29034423828125,55.56902805913944]]]},"z":11}'

      stub_request(:get, uri).
        to_return(body: success_json)
    end

    describe "when geojson hash is an argument" do
      it "returns json" do
        expect(described_class.by_bounds(geometry: polygon_hash, z: 11).to_json).to eq(success_json)
      end

      it "returns hash" do
        expect(described_class.by_bounds(geometry: polygon_hash, z: 11).to_h).to eq(success_hash)
      end
    end

    describe "when geojson string is argument" do
      it "returns json" do
        expect(described_class.by_bounds(geometry: polygon_json, z: 11).to_json).to eq(success_json)
      end

      it "returns hash" do
        expect(described_class.by_bounds(geometry: polygon_json, z: 11).to_h).to eq(success_hash)
      end
    end

    it "raises ArgumentError when geojson geometry type is neither polygon nor multypolygon" do
      polygon_hash["type"] = "Point"
      polygon_json = JSON.dump(polygon_hash)

      expect { described_class.by_bounds(geometry: polygon_hash, z: 11) }.to raise_error(ArgumentError)
      expect { described_class.by_bounds(geometry: polygon_json, z: 11) }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError when geojson geometry type is incorrect geometry" do
      polygon_hash["type"] = "solopolygon"
      polygon_json = JSON.dump(polygon_hash)

      expect { described_class.by_bounds(geometry: polygon_hash, z: 11) }.to raise_error(ArgumentError)
      expect { described_class.by_bounds(geometry: polygon_json, z: 11) }.to raise_error(ArgumentError)
    end
  end
end
