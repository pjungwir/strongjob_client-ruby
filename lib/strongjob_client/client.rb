require 'faraday_middleware'

module StrongjobClient
  class Client

    def initialize(options={})
      @options = options
      @api_key = options[:api_key]
      raise ArgumentError, ":api_key is required to initialize the Strongjob Client" unless @api_key
    end

    def run(job_slug, options={}, &block)
      options = @options.merge(options)
      if options[:noop]
        return nil

      else
        r = ::StrongjobClient::Run.new(connection(options), job_slug)
        r.start!

        begin
          yield r if block
          r.finish!
        rescue ::Exception => e
          r.fail!(e)
        end
        return r.result
      end
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

