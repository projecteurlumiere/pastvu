require "tempfile"
require "fileutils"

RSpec.describe Pastvu::Comment do
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
    expect(instance.replies.first).to be_a Pastvu::Comment
  end

  it "returns commments as mere Array of Hashes" do
    expect(instance.comments).to be_a Array
    expect(instance.comments.first).to be_a Hash
  end

  it "returns hash" do
    expect(instance.to_hash).to eq(comment_attr)
  end

  it "returns json" do
    expect(instance.to_json).to be_a String
    expect { instance.to_json }.not_to raise_error
  end

  context "when shallowly snakecasing/camelizing attributes" do
    subject(:instance) { described_class.new comment_attr[:comments][0] }

    it "snakecases variables" do
      expect { instance.last_changed }.not_to raise_error
      expect { instance.lastChanged }.to raise_error(NoMethodError)
    end

    it "does not camelizes variables when returns hash" do
      expect(instance.to_hash).to eq(comment_attr[:comments][0])
    end
  end
end