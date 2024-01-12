RSpec.describe Pastvu::Request do
  before do
    stub_request(:get, /.*/).
      with(headers: { user_agent: Pastvu::config.user_agent })
  end

  it "makes requests with the user_agent specified in config" do
    File.delete(described_class.download "https://doesnotexist.com", "#{described_class}_test")
  end

  it "downloads with the user agent specified in config" do
    described_class.new("any", { any: "any" })
  end
end

