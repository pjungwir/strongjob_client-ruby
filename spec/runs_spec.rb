require 'json'
require 'faraday'
require 'spec_helper'

describe StrongjobClient::Client do

  before(:each) do
    @api_key = '123'
    @client = StrongjobClient::Client.new(@api_key)
  end

  it "should start a new run" do
    fake_connection do |stubs|
      stubs.post("/v1/jobs/1/runs") do
        [200, {}, JSON.dump({ success: { id: 5 } })]
      end
      stubs.post("/v1/jobs/1/runs/5/finish") do
        [200, {}, JSON.dump({ success: { id: 9 } })]
      end
    end
    allow(@client).to receive(:connection).and_return(fake_connection)

    @result = @client.run('1') { }
    @result.errors.should be_empty
    @result.should be_finished
    @result.should_not be_failed
    @result.run_id.should_not be_nil
  end

end
