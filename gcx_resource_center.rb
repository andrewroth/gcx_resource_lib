module Gcx
  class ResourceCenter

    attr_reader :mode, :agent, :auth, :root, :username, :community

    def initialize(username, password, community, mode = :production)
      @mode = mode
      @community = community
      @agent = WWW::Mechanize.new
      @auth = Auth.new(@agent, username, password)
      @root = Folder.new self
    end

    # resource should be the url after the domain
    def get(resource)
      @agent.get construct_url(@mode, resource)
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
