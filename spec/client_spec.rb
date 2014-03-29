require 'json'
require 'faraday'
require 'spec_helper'

describe StrongjobClient::Client do

  before(:each) do
    @api_key = '123'
  end

  it "should do nothing with a noop parameter" do
    @client = StrongjobClient::Client.new(noop: true)
    @result = @client.run('1') { }
    @result.should be_nil
  end

  it "should initialize with an API key" do
    fake_connection do |stubs|
      stubs.post("/v1/jobs/1/runs") do
        [200, {}, JSON.dump({ success: { id: 5 } })]
      end
      stubs.post("/v1/jobs/1/runs/5/finish") do
        [200, {}, JSON.dump({ success: { id: 9 } })]
      end
    end
    allow(@client).to receive(:connection).and_return(fake_connection)

    StrongjobClient::Run.any_instance.should_receive :start!
    @client = StrongjobClient::Client.new(api_key: @api_key)
    @client.run('1') { }
  end

  it "should require an API key" do
    expect {
      StrongjobClient::Client.new
    }.to raise_error ArgumentError, ":api_key is required to initialize the Strongjob Client"
  end

  it "should accept nested symbol options" do
    @client = StrongjobClient::Client.new(api_key: @api_key, ssl: { verify: false })
    @conn = @client.send(:connection, {})
    puts @conn.instance_variables
    puts @conn.instance_variable_get(:@ssl)
    @conn.instance_variable_get(:@ssl)[:verify].should == false
  end

  it "should accept nested string options" do
    @client = StrongjobClient::Client.new('api_key' => @api_key, 'ssl' => { 'verify' => false })
    @conn = @client.send(:connection, {})
    @conn.instance_variable_get(:@ssl)[:verify].should == false
  end


end
