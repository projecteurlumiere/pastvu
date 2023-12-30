require "tempfile"
require "fileutils"

RSpec.describe Pastvu::Commentary do
  subject(:instance) { described_class.new comment_attr }

  let(:comment_attr) do
    {
      cid: 92701,
      user: "shurup",
      stamp: 1297361921000,
      txt: "А пробка у светофора, где Гастроном, тогда уже была. Я это помню, да и на снимке её видно.",
      s: 5,
      type: 1,
      level: 0,
      comments: [{
        cid: 148531,
        user: "Тоха",
        stamp: 1307108655000,
        txt: "Кроме собственно светофора, люди притормаживали в районе гастронома, да и поворот налево к Киевскому вокзалу существовал...",
        parent: 92701,
        level: 1,
        s: 5,
        lastChanged: 1458538239566,
        type: 1,
        latest: true
      }]
    }
  end

  it "responds to supplied hash parameters as methods" do
    comment_attr.each do |key, value|
      expect(instance).to respond_to(key)
      expect(instance.send(key)).to eq(value)
    end
  end

  it "responds to supplied hash parameters as methods dynamically" do
    comment_attr[:unknown_attribute] = 0

    comment_attr.each do |key, value|
      expect(instance).to respond_to(key)
      expect(instance.send(key)).to eq(value)
    end
  end

  it "returns replies as Comment class" do
    expect(instance.replies.first).to be_a Pastvu::Commentary
  end

  it "returns commments as mere Array of Hashes" do
    expect(instance.comments).to be_a Array
    expect(instance.comments.first).to be_a Hash
  end

  it "returns hash" do
    expect(instance.to_hash).to eq(comment_attr)
  end

  it "returns json" do
    expect(instance.to_json).to eq(JSON.dump(comment_attr))
  end

  # context "when providing links" do
  #   it "returns standard size file link" do
  #     expect(instance.standard).to eq(link_standard)
  #   end

  #   it "returns original size file link" do
  #     expect(instance.original).to eq(link_original)
  #   end

  #   it "returns thumbnail size file link" do
  #     expect(instance.thumbnail).to eq(link_thumbnail)
  #     expect(instance.thumb).to eq(link_thumbnail)
  #   end
  # end

  # context "when downloading" do
  #   before do
  #     [link_standard, link_original, link_thumbnail].each do |link|
  #       stub_request(:get, link).
  #         to_return(body: File.open(temp_img))
  #     end
  #   end

  #   after do
  #     File.unlink(temp_img)
  #   end

  #   it "downloads the requested photo in all sizes" do
  #     %i[standard original thumbnail thumb].each do |size|
  #       downloaded_file = instance.download(size, "test.jpeg")
  #       expect(FileUtils.identical?(downloaded_file, File.open(temp_img))).to eq(true)
  #     ensure
  #       File.delete(downloaded_file)
  #     end
  #   end

  #   it "raises ArgumentError if size for download is not in :standard, :original, :thumbnail, :thumb" do
  #     expect { instance.download(:stondard, "test.jpeg") }.to raise_error(ArgumentError)
  #   end

  #   it "raises ArgumentError unless path ends with .jpg or .jpeg" do
  #     expect { instance.download(:thumb, "test.mpeg") }.to raise_error(ArgumentError)
  #   end
  # end
end