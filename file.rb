class Gcx::ResourceCenter
  class File
    attr_reader :parent
    attr_reader :id, :community, :name, :label, :size, :content_type, :uploader_guid

    def initialize(parent, node)
      @parent = parent
      @id = node[:id].to_i
      @community = node[:community]
      @name = node[:filename]
      @label = node[:label]
      @size = node[:size].to_i
      @content_type = node[:type]
      @uploader_guid = node[:uploaderGUID]

      folder_id = node[:folderid].to_i
      raise "folder id #{folder_id} and parent id #{@parent.id} do not match" unless folder_id == @parent.id
    end
  end
end
