module StrongjobClient
  class Result

    def initialize(run)
      @run = run
    end

    def errors
      @run.errors
    end

    def finished?
      @run.finished?
    end

    def failed?
      @run.failed?
    end

    def run_id
      @run.id
    end

  end
end
