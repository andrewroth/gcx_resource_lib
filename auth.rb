class Auth
  attr_reader :username
  attr_reader :password

  def initialize(username, password)
    @username = username
    @password = password

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

    cas_url = 'https://signin.mygcx.org/cas/login'
    agent = WWW::Mechanize.new
    page = agent.post(cas_url, form_params)
    result_query = page.uri.query

    # nil result means auth succeeded
    result_query.nil? || !result_query.include?('BadPassword')
  end
end
