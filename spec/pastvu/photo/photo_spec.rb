require "tempfile"
require "fileutils"

RSpec.describe Pastvu::Photo do
  subject(:instance) { described_class.new photo_attr }

  let(:photo_attr) do
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

  let(:temp_img) { Tempfile.create("ttmrs80811yfro4md7.jpeg") }
  let(:link_standard) { "https://pastvu.com/_p/d/t/t/m/ttmrs80811yfro4md7.jpeg" }
  let(:link_original) { "https://pastvu.com/_p/a/t/t/m/ttmrs80811yfro4md7.jpeg" }
  let(:link_thumbnail) { "https://pastvu.com/_p/h/t/t/m/ttmrs80811yfro4md7.jpeg" }

  it "responds to supplied hash parameters as methods" do
    photo_attr.each do |key, value|
      expect(instance).to respond_to(key)
      expect(instance.send(key)).to eq(value)
    end
  end

  it "responds to supplied hash parameters as methods dynamically" do
    photo_attr[:ccount] = 0

    photo_attr.each do |key, value|
      expect(instance).to respond_to(key)
      expect(instance.send(key)).to eq(value)
    end
  end

  it "returns hash" do
    expect(instance.to_hash).to eq(photo_attr)
  end

  it "returns json" do
    expect(instance.to_json).to be_a String
    expect { instance.to_json }.not_to raise_error
  end

  context "when requesting new objects" do
    let(:success_json) { "{\"result\":{\"text\":\"success!\",\"photos\":[1,2,3], \"photo\":[\"I\",\"am\",\"a\",\"photo\"]}}"}

    it "returns a new Photo instance with full information" do
      uri = URI.parse('https://pastvu.com/api2?method=photo.giveForPage&params={"cid":449459}')
      stub_request(:get, uri).
        to_return(body: success_json)

      expect(instance.reload).to be_a Pastvu::Photo
    end

    it "returns comments for a relevant photo" do
      uri = 'https://pastvu.com/api2?method=comment.giveForObj&params={"cid":449459}'

      stub_request(:get, uri).
        to_return(body: success_json)

        expect(instance.comments).to be_a Pastvu::CommentaryCollection
    end
  end

  context "when providing links" do
    it "returns standard size file link" do
      expect(instance.standard).to eq(link_standard)
    end

    it "returns original size file link" do
      expect(instance.original).to eq(link_original)
    end

    it "returns thumbnail size file link" do
      expect(instance.thumbnail).to eq(link_thumbnail)
      expect(instance.thumb).to eq(link_thumbnail)
    end
  end

  context "when downloading" do
    before do
      [link_standard, link_original, link_thumbnail].each do |link|
        stub_request(:get, link).
          to_return(body: File.open(temp_img))
      end
    end

    after do
      File.unlink(temp_img)
    end

    it "downloads the requested photo in all sizes" do
      %i[standard original thumbnail thumb].each do |size|
        downloaded_file = instance.download(size, "test.jpeg")
        expect(FileUtils.identical?(downloaded_file, File.open(temp_img))).to eq(true)
      ensure
        File.delete(downloaded_file)
      end
    end

    it "raises ArgumentError if size for download is not in :standard, :original, :thumbnail, :thumb" do
      expect { instance.download(:stondard, "test.jpeg") }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError unless path ends with .jpg or .jpeg" do
      expect { instance.download(:thumb, "test.mpeg") }.to raise_error(ArgumentError)
    end
  end
end