class FileOperator
  def initialize(agent, mode)
    @agent = agent
    @mode = mode
  end

  def list(params)
    # https://stage.mygcx.org/AndrewTest/module/resourceCenter/get_files?sys_ts=1242592593314
    page = @agent.get construct_url(@mode, "#{params[:community]}/module/resourceCenter/get_files")
    page_xml = Hpricot(page.body)
    puts page_xml.inspect
  end

  protected

  def construct_url(mode, resource)
    if mode == :production
      base = GcxResource::PRODUCTION_BASE
    elsif mode == :staging
      base = GcxResource::STAGING_BASE
    else
      throw 'construct_url requires a mode, one of :production or :staging'
    end

    "#{base}/#{resource}"
  end
end
