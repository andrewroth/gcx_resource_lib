class Gcx::ResourceCenter
  class Folder
    attr_reader :id, :parent, :label, :community

    # node can be the resourceCenter node, in which case
    # child data is loaded, otherwise child data is lazy loaded
    def initialize(parent, node, gcx)
      @parent = parent

      if node.name == 'resourcecenter'
        @node = (node/'folders').first
        load_children = true 
      else
        @node = node
      end

      @id = @node[:id].to_i
      @label = @node[:label]
      @community = @node[:community]
      @gcx = gcx

      # load children last so that id is set, since sub-files verify the parent id
      # matches what's given in their xml
      load_children_from_xml(node) if load_children
    end

    def files
      ensure_files_and_folders_loaded
      @files
    end

    def folders
      ensure_files_and_folders_loaded
      @folders
    end

    def reload!
      @files = @folders = nil
    end

    protected

    def ensure_files_and_folders_loaded
      load_children_remotely unless @files && @folders
    end

    # sample url: https://stage.mygcx.org/AndrewTest/module/resourceCenter/get_files?sys_ts=1242592593314
    def load_children_remotely
      url = "#{@community}/module/resourceCenter/get_files"
      url += "?id=#{@id}" if @id
      page = @gcx.get url
      load_children_from_xml Hpricot(page.body)
    end

    def load_children_from_xml(xml)
      @files, @folders = parse_list_response(xml)
    end

    # returns [ [ file1, file2, .. fileN ] [ folder1, folder2, .. folderN ] ]
    # parse from xml
    def parse_list_response(xml)
      [ nodes_for(xml, 'files').collect{ |node| File.new(self, node) },
        nodes_for(xml, 'folders').collect{ |node| Folder.new(nil, node, @gcx) } ]
    end

    def nodes_for(xml, node_name)
      (xml/node_name).first/'node'
    end
  end
end
