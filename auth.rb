module Gcx
  class Auth
    attr_reader :username
    attr_reader :password
    attr_reader :agent

    def initialize(agent, username, password)
      @username = username
      @password = password
      @agent = agent

      @authenticated = connect!
      throw "Invalid username or password" unless authenticated?
    end

    def authenticated?
      @authenticated
    end

    private

    def connect!
      form_params = { 
        :username => @username,
        :password => @password,
        :service => '' 
      }

      cas_url = LOGIN_URL
      page = @agent.post(cas_url, form_params)
      result_query = page.uri.query

      # nil result means auth succeeded
      result_query.nil? || !result_query.include?('BadPassword')
    end
  end
end
