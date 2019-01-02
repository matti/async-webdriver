RSpec.describe Async::Webdriver::Client do
  let(:client) {
    Async::Webdriver::Client.new endpoint: "http://localhost:9515"
  }
  before :each do
    @pid = Process.spawn "chromedriver"
    raise unless @pid
    #TODO:
    # - check if the launch was successful (currently another chromedriver/process can be running)
    # - wait for it instead of sleep:
    sleep 0.1
  end

  after :each do
    client.sessions.map(&:delete!)
    Process.kill "TERM", @pid
  end

  it do
    new_session = client.session.create!
    expect(new_session.id).not_to eq ""
  end
end
