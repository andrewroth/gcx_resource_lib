module GcxResourceCenter
  class Folder
    attr_reader :id, :parent, :label, :community

    def initialize(parent, node, file_operator)
      @parent = parent
      @id = node[:id].to_i
      @label = node[:label]
      @community = node[:community]
      @file_operator = file_operator
    end

    def files
      ensure_files_and_folders_updated
      @files
    end

    def folders
      ensure_files_and_folders_updated
      @folders
    end

    def reload!
      @files = @folders = nil
    end

    protected

    def ensure_files_and_folders_updated
      unless @files && @folders
        @files, @folder = @file_operator.list(:community => @community, :id => @id)
      end
    end
  end
end
