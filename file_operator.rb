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
    parse_list_response Hpricot(page.body)
  end

  protected

  def parse_list_response(xml)
    [ ((xml/'files').first.children || []).collect{ |node| GcxResource::File.new(nil, node) }, 
      ((xml/'folders').first.children || []).collect{ |node| GcxResource::Folder.new(nil, node) } ]
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
