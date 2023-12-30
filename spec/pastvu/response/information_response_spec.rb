RSpec.describe Pastvu::InformationResponse do
  subject(:instance) { described_class.new info_json }

  let(:info_json) { '{"result":{"photo":{"type":1,"adate":"2009-03-06T06:52:00.000Z","address":"Смоленская-Сенная площадь, дом № 32","album":10,"ccount":3,"cid":5,"desc":"Более крупный вариант снимка предоставил пользователь Maksim2152","dir":"n","file":"b/1/0/b10d2d3243999d75a0f13fe2b7d0c87b.jpg","frags":[{"cid":92702,"l":27.43,"t":90.5,"w":7.12,"h":3.25}],"geo":[55.740768,37.584201],"h":1200,"hs":684,"ldate":"2009-03-06T06:52:00.000Z","source":"книга \"Советская архетиктура\"","title":"Высотное здание на Смоленской площади","user":{"login":"Ilya","avatar":"x/s/xstikn1arn.jpg","disp":"Ilya","ranks":["mec_gold"],"sex":"m"},"vcount":5217,"vdcount":2,"vwcount":17,"w":860,"ws":502,"year":1984,"year2":1986,"s":5,"y":"1984—1986","waterh":28,"waterhs":16,"cdate":"2018-11-02T18:06:10.675Z","ucdate":"2018-11-02T18:06:10.675Z","watersignCustom":"uploaded by Zyalt","watersignIndividual":false,"watersignOption":false,"watersignText":"uploaded by Ilya","watersignTextApplied":"2015-09-16T09:34:41.383Z","r2d":[91.28411657469428,80.38595300904133],"regions":[{"cid":1,"title_local":"Россия","phc":1080692,"pac":17862,"cc":2482626},{"cid":3,"title_local":"Москва","phc":271857,"pac":3927,"cc":1435180},{"cid":387,"title_local":"ЦАО","phc":139069,"pac":2529,"cc":574428},{"cid":404,"title_local":"Хамовники","phc":16464,"pac":309,"cc":64397}]},"can":{"download":"login"},"forEdit":false},"rid":"sciuhx0h2o"}' }

  it "returns Photo class" do
    expect(instance.to_photo).to be_a Pastvu::Photo
  end

  it "returns Photo class that works" do
    expect(instance.to_photo.thumb).to eq("https://pastvu.com/_p/h/b/1/0/b10d2d3243999d75a0f13fe2b7d0c87b.jpg")
  end
end