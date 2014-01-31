$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rspec/matchers'
require 'strongjob_client'
require 'faraday_middleware'

# Requires supporting files with custom matchers and macros, etc.,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end

def fake_connection(&block)
  @fake_connection ||= Faraday.new do |fdy|
    fdy.response :json
    fdy.adapter :test do |stubs|
      yield(stubs)
    end
  end
end

