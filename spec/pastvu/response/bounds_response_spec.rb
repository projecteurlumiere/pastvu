RSpec.describe Pastvu::BoundsResponse do
  let(:clusters_json) { '{"result":{"z":11,"photos":[],"clusters":[{"geo":[55.567462,37.526489],"c":151,"p":{"cid":909367,"file":"y/0/o/y0owcpzjjkhzxbycmu.jpg","title":"Бачурино","dir":"w","geo":[37.513289,55.571187],"year":1969,"year2":1969}},{"geo":[55.567462,37.598586],"c":282,"p":{"cid":469885,"file":"5/0/z/50zax74yxst3yvg67c.jpg","title":"В Ботаническом саду ВИЛАР","geo":[37.595912,55.565967],"year":1952,"year2":1958,"dir":"n"}},{"geo":[55.567462,37.886973999999995],"c":809,"p":{"cid":262117,"file":"f/j/g/fjgm1lqqm5jxxlm2n0.jpg","year2":1980,"year":1980,"title":"На фоне Лыткарино. ","dir":"ne","geo":[37.883834,55.572813]}},{"c":10,"geo":[55.567462,37.814876999999996],"p":{"cid":1443366,"file":"t/b/l/tblbqtknb3xebj01yz.jpg","title":"Спутник. М71.6.35","dir":"aero","geo":[37.812452,55.573492],"year":1971,"year2":1971}},{"geo":[55.608036999999996,37.814876999999996],"c":426,"p":{"cid":1443356,"file":"i/5/x/i5x75yngtjho4ggrdj.jpg","title":"Спутник. М71.6.15","dir":"aero","geo":[37.818546,55.610014],"year":1971,"year2":1971}},{"geo":[55.567462,37.742779999999996],"c":84,"p":{"cid":1443370,"file":"h/7/m/h7mkn16he0nwuzq0qa.jpg","title":"Спутник. М71.6.44","dir":"aero","geo":[37.748465,55.565242],"year":1971,"year2":1971}}]},"rid":"jlt17j3vrj"}' }
  let(:photos_json) { '{"result":{"z":11,"clusters":[],"photos":[{"s":5,"cid":449459,"file":"t/t/m/ttmrs80811yfro4md7.jpeg","title":"View of the Marin Tower of the Golden Gate Bridge under construction","dir":"nw","geo":[37.82287,-122.474985],"year":1934},{"cid":269502,"file":"l/f/2/lf2pu8mk8wf4chvpix.jpg","s":5,"year":1955,"title":"Aerial view of the Golden Gate Bridge with seagull","dir":"w","geo":[37.814496,-122.468926]},{"cid":424582,"file":"0/g/y/0gyilodb8u3d92zcll.jpg","s":5,"title":"USAAF B-17 Flying Fortress Over Golden Gate Bridge","year":1944,"dir":"nw","geo":[37.824565,-122.475821],"ccount":2},{"s":5,"cid":449475,"file":"t/s/d/tsda7z1skar3kl3isk.jpeg","title":"Construction of the Golden Gate Bridge with a view of the catwalks being placed under the cables","dir":"s","geo":[37.819437,-122.478411],"year":1936},{"s":5,"cid":449471,"file":"g/r/h/grh4nvjmieg2p1xj55.jpeg","title":"View from the middle of Golden Gate Bridge under construction","year":1935,"dir":"s","geo":[37.819988,-122.478587]},{"s":5,"cid":1446865,"file":"3/d/l/3dlc0xkhwhoqq6xkyv.png","title":"Unfinished Golden Gate Bridge","geo":[37.820175,-122.478686],"year":1935},{"s":5,"cid":1953900,"file":"s/y/w/syw1att95kq40dfmj6.png","title":"Golden Gate Bridge, constructing catwalks","dir":"s","geo":[37.817649,-122.478247],"year":1935},{"s":5,"cid":1953899,"file":"j/h/1/jh1gjmewbd4ezc3m0n.png","title":"Golden Gate Bridge construction workers standing on cables","dir":"n","geo":[37.816539,-122.478278],"year":1936},{"s":5,"cid":449477,"file":"2/d/v/2dvd0975xm279l6q78.jpeg","title":"Men on the catwalks working on the cables","year":1935,"dir":"e","geo":[37.816683,-122.478371]},{"s":5,"cid":1953897,"file":"e/y/n/eynaxgt59mpg0xh37j.png","title":"Golden Gate Bridge construction workers on catwalks during cable spinning","dir":"n","geo":[37.822082,-122.478998],"year":1936},{"s":5,"cid":551764,"file":"w/6/e/w6eu707c7be9s7ynzo.jpg","title":"Under the Golden Gate Bridge","dir":"n","geo":[37.815818,-122.478075],"year":1951,"ccount":1},{"cid":211178,"file":"e/y/5/ey52lf928iynoto16c.jpg","s":5,"year":1935,"title":"Waiting on Catwalk","dir":"e","geo":[37.81603,-122.478257]}]},"rid":"um4egbkgwn"}' }
  let(:combined_json) {
    base_hash = JSON.parse(clusters_json)
    add_hash = JSON.parse(photos_json)

    base_hash["result"]["photos"] = add_hash["result"]["photos"]
    JSON.dump(base_hash)
  }

  context "when clusters and photos are present" do
    subject(:instance) { described_class.new combined_json }

    it "returns non-empty ClusterCollection" do
      expect(instance.clusters).to be_a Pastvu::ClusterCollection
      expect(instance.clusters.any?).to eq(true)
    end

    it "returns non-empty PhotoCollection" do
      expect(instance.photos).to be_a Pastvu::PhotoCollection
      expect(instance.photos.any?).to eq(true)
    end
  end

  context "when clusters only are present" do
    subject(:instance) { described_class.new clusters_json }

    it "returns non-empty ClusterCollection" do
      expect(instance.clusters).to be_a Pastvu::ClusterCollection
      expect(instance.clusters.any?).to eq(true)
    end

    it "returns empty PhotoCollection" do
      expect(instance.photos).to be_a Pastvu::PhotoCollection
      expect(instance.photos.any?).to eq(false)
    end
  end

  context "when photos only are present" do
    subject(:instance) { described_class.new photos_json }

    it "returns non-empty ClusterCollection" do
      expect(instance.clusters).to be_a Pastvu::ClusterCollection
      expect(instance.clusters.any?).to eq(false)
    end

    it "returns empty PhotoCollection" do
      expect(instance.photos).to be_a Pastvu::PhotoCollection
      expect(instance.photos.any?).to eq(true)
    end
  end
end