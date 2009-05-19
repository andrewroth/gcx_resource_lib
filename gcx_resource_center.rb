module GcxResourceCenter
  LOGIN_URL = 'https://signin.mygcx.org/cas/login'
  PRODUCTION_BASE = 'https://www.mygcx.org'
  STAGING_BASE = 'https://stage.mygcx.org'

  def initialize(agent, mode)
    @agent = agent
    @mode = mode
  end

  # resource should be the url after the domain
  def get(resource)
    @agent.get construct_url(@mode, url)
  end

  protected

  def construct_url(mode, resource)
    if mode == :production
      base = GcxResourceCenter::PRODUCTION_BASE
    elsif mode == :staging
      base = GcxResourceCenter::STAGING_BASE
    else
      throw 'construct_url requires a mode, one of :production or :staging'
    end

    "#{base}/#{resource}"
  end
end
