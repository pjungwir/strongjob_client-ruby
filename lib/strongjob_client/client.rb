require 'faraday_middleware'
require 'active_support/core_ext/hash/indifferent_access'

module StrongjobClient
  class Client

    def initialize(options={})
      options = options.with_indifferent_access
      @api_key = options.delete(:api_key)
      @noop = options.delete(:noop)
      @options = options
      unless @noop
        raise ArgumentError, ":api_key is required to initialize the Strongjob Client" unless @api_key
      end
    end

    def run(job_slug, options={}, &block)
      if @noop || options[:noop]
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

    private

    def merge_options(options)
      options = @options.merge({
        headers: { 'Authorization' => "Token token=\"#{@api_key}\"" }.merge(options.delete(:headers) || {})
      }).merge(options.with_indifferent_access)

      options[:url] = options.delete(:server_url) if options[:server_url]
      options[:url] ||= 'https://api.strongjob.com'
      options
    end

    def connection(options)
      return @conn if @conn

      options = merge_options(options)

      @conn = Faraday.new(options) do |fdy|
        fdy.response :json
        fdy.adapter Faraday.default_adapter
      end
    end

  end
end

