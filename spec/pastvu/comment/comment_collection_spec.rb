require "set"

RSpec.describe Pastvu::CommentCollection do
  subject(:instance) { described_class.new comments_json }

  let(:comments_json) { '{"result":{"comments":[{"cid":92701,"user":"shurup","stamp":1297361921000,"txt":"А пробка у светофора, где Гастроном, тогда уже была. Я это помню, да и на снимке её видно.","s":5,"type":1,"level":0,"comments":[{"cid":148531,"user":"Toxa","stamp":1307108655000,"txt":"Кроме собственно светофора, люди притормаживали в районе гастронома, да и поворот налево к Киевскому вокзалу существовал...","parent":92701,"level":1,"s":5,"lastChanged":1458538239566,"type":1,"latest":true}]},{"cid":92702,"user":"Likinskij","stamp":1297362004000,"txt":"ВАЗ-2104, выпуск которого был начат в 1984 году.","frag":true,"s":5,"type":1,"level":0}],"countTotal":3,"users":{"Likinskij":{"avatar":"/_a/h/Likinskij.png","disp":"Likinskij","login":"Likinskij","ranks":[],"online":false},"shurup":{"avatar":"/_a/h/shurup.png","disp":"shurup","login":"shurup","ranks":[],"online":false},"Toxa":{"avatar":"/_a/h/Toxa.png","disp":"Toxa","login":"Toxa","ranks":[],"online":false}},"latestCid":148531,"cid":5},"rid":"qv7kffyjc2"}' }

  it "works with enumerable methods" do
    expect(instance.count).to eq(2)
  end

  it "returns a Photo" do
    uri = URI.parse('https://pastvu.com/api2?method=photo.giveForPage&params={"cid":5}')
    stub_request(:get, uri).
      to_return(body: "{\"result\":{\"photo\":{\"s\":5,\"file\":\"t/t/m/ttmrs80811yfro4md7.jpeg\",\"title\":\"View of the Marin Tow...Golden Gate Bridge under construction\",\"dir\":\"nw\",\"geo\":[37.82287,-122.47985],\"year\":1934}}}")

      expect(instance.photo).to be_a Pastvu::Photo
  end

  it "produces Comment class on iteration" do
    set = instance.each_with_object(Set.new) do |photo, set|
      set << photo.class
    end

    expect(set.size).to be(1)
    expect(set.first).to be Pastvu::Comment
  end

  it "(or rather Comment) populates replies to Commentaries as another instances of Comment" do
    expect(instance.first.replies.first).to be_a Pastvu::Comment
  end

  it "returns hash with all users" do
    expect(instance.users).to eq(JSON.parse(comments_json)["result"]["users"])
  end
end