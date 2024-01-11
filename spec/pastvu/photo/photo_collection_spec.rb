require "set"

RSpec.describe Pastvu::PhotoCollection do
  subject(:instance) { described_class.new photos_json }

  let(:photos_json) { '{"result":{"photos":[{"s":5,"cid":449459,"file":"t/t/m/ttmrs80811yfro4md7.jpeg","title":"View of the Marin Tower of the Golden Gate Bridge under construction","dir":"nw","geo":[37.82287,-122.474985],"year":1934},{"cid":269502,"file":"l/f/2/lf2pu8mk8wf4chvpix.jpg","s":5,"year":1955,"title":"Aerial view of the Golden Gate Bridge with seagull","dir":"w","geo":[37.814496,-122.468926]},{"cid":424582,"file":"0/g/y/0gyilodb8u3d92zcll.jpg","s":5,"title":"USAAF B-17 Flying Fortress Over Golden Gate Bridge","year":1944,"dir":"nw","geo":[37.824565,-122.475821],"ccount":2},{"s":5,"cid":449475,"file":"t/s/d/tsda7z1skar3kl3isk.jpeg","title":"Construction of the Golden Gate Bridge with a view of the catwalks being placed under the cables","dir":"s","geo":[37.819437,-122.478411],"year":1936},{"s":5,"cid":449471,"file":"g/r/h/grh4nvjmieg2p1xj55.jpeg","title":"View from the middle of Golden Gate Bridge under construction","year":1935,"dir":"s","geo":[37.819988,-122.478587]},{"s":5,"cid":1446865,"file":"3/d/l/3dlc0xkhwhoqq6xkyv.png","title":"Unfinished Golden Gate Bridge","geo":[37.820175,-122.478686],"year":1935},{"s":5,"cid":1953900,"file":"s/y/w/syw1att95kq40dfmj6.png","title":"Golden Gate Bridge, constructing catwalks","dir":"s","geo":[37.817649,-122.478247],"year":1935},{"s":5,"cid":1953899,"file":"j/h/1/jh1gjmewbd4ezc3m0n.png","title":"Golden Gate Bridge construction workers standing on cables","dir":"n","geo":[37.816539,-122.478278],"year":1936},{"s":5,"cid":449477,"file":"2/d/v/2dvd0975xm279l6q78.jpeg","title":"Men on the catwalks working on the cables","year":1935,"dir":"e","geo":[37.816683,-122.478371]},{"s":5,"cid":1953897,"file":"e/y/n/eynaxgt59mpg0xh37j.png","title":"Golden Gate Bridge construction workers on catwalks during cable spinning","dir":"n","geo":[37.822082,-122.478998],"year":1936},{"s":5,"cid":551764,"file":"w/6/e/w6eu707c7be9s7ynzo.jpg","title":"Under the Golden Gate Bridge","dir":"n","geo":[37.815818,-122.478075],"year":1951,"ccount":1},{"cid":211178,"file":"e/y/5/ey52lf928iynoto16c.jpg","s":5,"year":1935,"title":"Waiting on Catwalk","dir":"e","geo":[37.81603,-122.478257]}]},"rid":"um4egbkgwn"}' }

  it "works with enumerable methods" do
    expect(instance.count).to eq(12)
  end

  it "produces Photo class on iteration" do
    set = instance.each_with_object(Set.new) do |photo, set|
      set << photo.class
    end

    expect(set.size).to be(1)
    expect(set.first).to be Pastvu::Photo
  end

  context "when asking for photos by bounds" do
    it "raise if when calling next method" do
      expect { subject.next }.to raise_error(RuntimeError)
    end
  end

  context "when asking for nearest photos" do
    subject(:instance) { described_class.new photos_json, params }

    let(:params) { {geo: [10, 20]} }

    it "makes a request for next 30 photos" do
      expect(Pastvu).to receive(:nearest_photos) do |args|
        expect(args[:skip]).to eq(30)
      end

      instance.next
    end

    it "makes a request for next photos when some photos are already skipped" do
      params[:skip] = 30

      expect(Pastvu).to receive(:nearest_photos) do |args|
        expect(args[:skip]).to eq(60)
      end

      instance.next
    end

    it "makes a request for a custom number of photos" do
      params[:skip] = 30

      expect(Pastvu).to receive(:nearest_photos) do |args|
        expect(args[:skip]).to eq(35)
      end

      instance.next(5)
    end

    it "raises error if asked more than 30 photos or less than one" do
      expect { instance.next(1.5) }.to raise_error(ArgumentError)
      expect { instance.next(31) }.to raise_error(ArgumentError)
      expect { instance.next(0) }.to raise_error(ArgumentError)
      expect { instance.next(-1) }.to raise_error(ArgumentError)
    end
  end
end