require 'json'

module StrongjobClient
  class Run

    def initialize(conn, job_slug)
      @conn = conn
      @job = job_slug
      @result = StrongjobClient::Result.new(self)
      @network_errors = []
      @errors = []
      @failed = false
      @finished = false
      @done = false
      @run_id = nil
    end

    def id
      @run_id
    end

    def result
      @result
    end

    def errors
      @errors
    end

    def finished?
      @finished
    end

    def failed?
      @failed
    end

    def start!
      resp = post("/v1/jobs/#{@job}/runs")
      if resp.success?
        body = resp.body
        puts body
        @run_id = body['success']['id']
      end
    end

    def fail!(msg=nil, options={})
      if @run_id
        @errors << msg
        args = {}
        if msg.is_a?(Exception)
          args[:message] = msg.message
          args[:stack_trace] = msg.backtrace.join("\n")
        else
          args[:message] = msg
        end
        post("/v1/jobs/#{@job}/runs/#{@run_id}/fail", args)
        @done = true
        @failed = true
      end
    end

    def finish!(msg=nil, options={})
      if @run_id and not @done
        post("/v1/jobs/#{@job}/runs/#{@run_id}/finish")
        @done = true
        @finished = true
      end
    end

    private

    def post(path, body={}, &block)
      t = Time.now
      resp = @conn.post do |req|
        req.path = path
        req.headers['Content-Type'] = 'application/json'
        req.body = body.merge(sent_at: t.to_s)
        yield req if block
      end
      record_network_errors(path, t, resp)
      resp
    end

    def record_network_errors(path, t, resp)
      if not resp.success?
        @network_errors << NetworkError.new(path, t, resp.status, resp.body)
      end
    end

  end
end
