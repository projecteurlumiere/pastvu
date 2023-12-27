# frozen_string_literal: true

RSpec.describe Pastvu do
  let(:success_json) { "{\"result\":{\"text\":\"success!\"}}" }
  let(:success_hash) { { "result" => { "text" => "success!" } } }

  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  context "when requesting photo information" do
    before do
      described_class.configure { |c| c.reset! }
      uri = URI.parse('https://pastvu.com/api2?method=photo.giveForPage&params={"cid":5}')

      stub_request(:get, uri).
        to_return(body: success_json)
    end

    it "returns json by default" do

      expect(described_class.photo_info(5)).to eq(success_json)
    end

    it "returns hash if configured" do
      described_class.configure { |config| config.output_format = :hash }

      expect(described_class.photo_info(5)).to eq(success_hash)
    end


    it "raises ArgumentError when supplied id is not integer" do
      expect { described_class.photo_info("5") }.to raise_error(ArgumentError)
    end
  end

  context "when requesting commentaries" do
    before do
      described_class.configure { |c| c.reset! }
      uri = 'https://pastvu.com/api2?method=comment.giveForObj&params={"cid":23314}'

      stub_request(:get, uri).
        to_return(body: success_json)
    end

    it "returns json by default" do
      expect(described_class.comments(23314)).to eq(success_json)
    end

    it "returns hash if configured" do
      described_class.configure { |config| config.output_format = :hash }

      expect(described_class.comments(23314)).to eq(success_hash)
    end


    it "raises ArgumentError when supplied id is not integer" do
      expect { described_class.comments("23314") }.to raise_error(ArgumentError)
    end
  end
end
