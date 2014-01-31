module StrongjobClient
  class NetworkError

    def initialize(url, t, code, body)
      @url = url
      @t = t
      @code = code
      @body = body
    end

  end
end
