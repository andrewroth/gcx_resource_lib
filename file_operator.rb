class FileOperator
  def initialize(agent, mode)
    @agent = agent
    @mode = mode
  end

  def list(params)
    # https://stage.mygcx.org/AndrewTest/module/resourceCenter/get_files?sys_ts=1242592593314
    url = "#{params[:community]}/module/resourceCenter/get_files"
    url += "?id=#{params[:id]}" if params[:id]
    page = @agent.get construct_url(@mode, url)
    page_xml = Hpricot(page.body)
    parse_list_response page_xml.inspect
  end

  protected

  def parse_list_response(xml)

  end

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
