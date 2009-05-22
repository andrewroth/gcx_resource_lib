class Gcx::ResourceCenter
  class Folder
    attr_reader :id, :parent, :label, :community

    # node can be the resourceCenter node, in which case
    # child data is loaded, otherwise child data is lazy loaded
    # leave node and parent nil if you want to load the resourceCenter
    # initial data here
    def initialize(rc, parent = nil, node = nil)
      @parent = parent
      @rc = rc

      unless node
        @community = rc.community
        node = get_files_and_folders_xml.root
      end

      if node.name == 'resourcecenter'
        root_xml = node
        @node = (root_xml/'folders').first
        # load children later so that id is set first, since sub-files verify the parent id
        # matches what's given in their xml
        load_children = true 
      else
        @node = node
      end

      @id = @node[:id].to_i
      @label = @node[:label]
      @community = @node[:community]

      load_children_from_xml(root_xml) if load_children
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

    def to_s
      "<#{self.class.name}:#{object_id} @label=#{@label} @id=#{@id}>"
    end

    def inspect() to_s end

    protected

    def ensure_files_and_folders_loaded
      load_children_remotely unless @files && @folders
    end

    # sample url: https://stage.mygcx.org/AndrewTest/module/resourceCenter/get_files?sys_ts=1242592593314
    def load_children_remotely
      load_children_from_xml get_files_and_folders_xml
    end

    def get_files_and_folders_xml
      url = "#{@community}/module/resourceCenter/get_files"
      url += "?id=#{@id}" if @id
      page = @rc.get url
      Hpricot(page.body)
    end

    def load_children_from_xml(xml)
      @files, @folders = parse_list_response(xml)
    end

    # returns [ [ file1, file2, .. fileN ] [ folder1, folder2, .. folderN ] ]
    # parse from xml
    def parse_list_response(xml)
      [ nodes_for(xml, 'files').collect{ |node| File.new(self, node) },
        nodes_for(xml, 'folders').collect{ |node| Folder.new(@rc, self, node) } ]
    end

    def nodes_for(xml, node_name)
      (xml/node_name).first/'node'
    end
  end
end
