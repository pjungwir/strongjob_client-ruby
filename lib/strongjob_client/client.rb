require 'faraday_middleware'

module StrongjobClient
  class Client

    def initialize(api_key)
      @api_key = api_key
    end

    def run(job_slug, options={}, &block)
      r = ::StrongjobClient::Run.new(connection(options), job_slug)
      r.start!

      yield r if block

      r.finish!
      return r.result
    end

    def connection(options={})
      @conn ||= Faraday.new(url: options[:server_url] || "https://api.strongjob.com",
                            headers: { 'Authorization' => "Token token=\"#{@api_key}\"" }) do |fdy|
        fdy.response :json
        fdy.adapter Faraday.default_adapter
      end
      
    end

  end
end

