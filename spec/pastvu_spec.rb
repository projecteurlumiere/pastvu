# frozen_string_literal: true

RSpec.describe Pastvu do
  let(:success_json) { "{\"result\":{\"text\":\"success!\",\"photos\":[1,2,3]}}" }
  let(:unsuccesful_json) { "{\"error\":{\"detais\":\"bad\"}}" }
  let(:success_hash) { { "result" => { "text" => "success!", "photos" => [1, 2, 3] } } }

  let(:polygon_hash) { JSON.parse('{"type":"Polygon","coordinates":[[[37.29034423828125,55.56902805913944],[37.95501708984375,55.56902805913944],[37.95501708984375,55.92150795277898],[37.29034423828125,55.92150795277898],[37.29034423828125,55.56902805913944]]]}') }
  let(:polygon_json) { polygon_hash.to_json }

  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  context "when server returns error" do
    before do
      uri = URI.parse('https://pastvu.com/api2?method=photo.giveForPage&params={"cid":5}')

      stub_request(:get, uri).
        to_return(body: unsuccesful_json)
    end

    it "raises RuntimeError" do
      expect { described_class.photo_info(5) }.to raise_error(RuntimeError)
    end

    it "does not raise RuntimeError if configured (via config)" do
      described_class.config.ensure_successful_responses = false
      expect { described_class.photo_info(5) }.not_to raise_error
    end

    it "does not raise RuntimeError if configured (via configure block)" do
      described_class.config.ensure_successful_responses = false
      described_class.configure do |c|
        c.ensure_successful_responses = false
      end
      expect { described_class.photo_info(5) }.not_to raise_error
    end
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
      expect(described_class.photo_info(5).to_hash).to eq(success_hash)
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
      expect(described_class.comments(23314).to_hash).to eq(success_hash)
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
      expect(described_class.nearest_photos(geo: [37.82, -122.469322], limit: 12, except: 228481).to_hash).to eq(success_hash)
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
        expect(described_class.by_bounds(geometry: polygon_hash, z: 11).to_hash).to eq(success_hash)
      end
    end

    describe "when geojson string is argument" do
      it "returns json" do
        expect(described_class.by_bounds(geometry: polygon_json, z: 11).to_json).to eq(success_json)
      end

      it "returns hash" do
        expect(described_class.by_bounds(geometry: polygon_json, z: 11).to_hash).to eq(success_hash)
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

    it "sets localWork parameter if zoom >= 17" do
      uri = 'https://pastvu.com/api2?method=photo.getByBounds&params={"geometry":{"type":"Polygon","coordinates":[[[37.29034423828125,55.56902805913944],[37.95501708984375,55.56902805913944],[37.95501708984375,55.92150795277898],[37.29034423828125,55.92150795277898],[37.29034423828125,55.56902805913944]]]},"z":18,"localWork":true}'

      stub_request(:get, uri).
        to_return(body: success_json)

      expect(described_class.by_bounds(geometry: polygon_hash, z: 18).to_json).to eq(success_json)
    end
  end
end
