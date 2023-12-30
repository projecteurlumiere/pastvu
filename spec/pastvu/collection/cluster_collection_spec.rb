RSpec.describe Pastvu::ClusterCollection do
  subject(:instance) { described_class.new cluster_json }

  let(:cluster_json) { '{"result":{"z":11,"photos":[],"clusters":[{"geo":[55.567462,37.526489],"c":151,"p":{"cid":909367,"file":"y/0/o/y0owcpzjjkhzxbycmu.jpg","title":"Бачурино","dir":"w","geo":[37.513289,55.571187],"year":1969,"year2":1969}},{"geo":[55.567462,37.598586],"c":282,"p":{"cid":469885,"file":"5/0/z/50zax74yxst3yvg67c.jpg","title":"В Ботаническом саду ВИЛАР","geo":[37.595912,55.565967],"year":1952,"year2":1958,"dir":"n"}},{"geo":[55.567462,37.886973999999995],"c":809,"p":{"cid":262117,"file":"f/j/g/fjgm1lqqm5jxxlm2n0.jpg","year2":1980,"year":1980,"title":"На фоне Лыткарино. ","dir":"ne","geo":[37.883834,55.572813]}},{"c":10,"geo":[55.567462,37.814876999999996],"p":{"cid":1443366,"file":"t/b/l/tblbqtknb3xebj01yz.jpg","title":"Спутник. М71.6.35","dir":"aero","geo":[37.812452,55.573492],"year":1971,"year2":1971}},{"geo":[55.608036999999996,37.814876999999996],"c":426,"p":{"cid":1443356,"file":"i/5/x/i5x75yngtjho4ggrdj.jpg","title":"Спутник. М71.6.15","dir":"aero","geo":[37.818546,55.610014],"year":1971,"year2":1971}},{"geo":[55.567462,37.742779999999996],"c":84,"p":{"cid":1443370,"file":"h/7/m/h7mkn16he0nwuzq0qa.jpg","title":"Спутник. М71.6.44","dir":"aero","geo":[37.748465,55.565242],"year":1971,"year2":1971}}]},"rid":"jlt17j3vrj"}' }

  it "works with enumerable methods" do
    expect(instance.count).to eq(6)
  end

  it "produces Cluster class on iteration" do
    set = instance.each_with_object(Set.new) do |cluster, set|
      set << cluster.class
    end

    expect(set.size).to be(1)
    expect(set.first).to be Pastvu::Cluster
  end
end