module Gcx
  class ResourceCenter

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
        base = PRODUCTION_BASE
      elsif mode == :staging
        base = STAGING_BASE
      else
        throw 'construct_url requires a mode, one of :production or :staging'
      end

    "#{base}/#{resource}"
    end
  end
end
