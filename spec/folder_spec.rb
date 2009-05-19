require "#{File.dirname(__FILE__)}/../init"

describe GcxResourceCenter::Folder do
  before do
    @parent = mock('parent', :id => 3)
    @node = Hpricot(%|
<node community="AndrewTest" id="6" label="News">
|).root

    auth = Auth.new 'studentseven7@gmail.com', 'student7!'
    @agent = auth.agent
    @gcx = mock('gcx')
  end

  it "should store and extract attributes properly" do
    @folder = GcxResourceCenter::Folder.new(@parent, @node, @gcx)

    @folder.parent.should == @parent
    @folder.id.should == 6
    @folder.community.should == 'AndrewTest'
  end

  it "should correctly list a folder's sub-files and sub-folders" do
    subfolder_xml = %|
<?xml version="1.0" encoding="UTF-8"?>
<resourceCenter>
  <files>
    <node community="AndrewTest" filename="file.jpg" folderid="1" id="2" label="file label" size="39608" type="image/jpeg" uploaderGUID="guid">
    <node community="AndrewTest" filename="file2.jpg" folderid="1" id="3" label="file2 label" size="1048" type="image/jpeg" uploaderGUID="guid"/>
  </files>
  <folders community="Folder1" id="1" label="">
    <node community="AndrewTest" id="3" label="Folder1"></node>
  </folders>
</resourceCenter>
|
    root_xml =%|
<?xml version="1.0" encoding="UTF-8"?>
<resourceCenter>
  <files>
    <node community="AndrewTest" filename="root.jpg" folderid="0" id="4" label="root file label" size="222" type="image/jpeg" uploaderGUID="guid">
  </files>
  <folders community="AndrewTest" id="0" label="">
    <node community="AndrewTest" id="1" label="Folder1"></node>
  </folders>
</resourceCenter>
|
    root_folder = GcxResourceCenter::Folder.new(
      nil, 
      Hpricot(root_xml).root,
      @gcx
    )

    root_folder.files.length.should == 1
    root_folder.folders.length.should == 1
    @gcx.should_receive(:get).with("AndrewTest/module/resourceCenter/get_files?id=1").and_return(mock('page', :body => subfolder_xml))
    root_folder.folders.first.files.length.should == 2
    root_folder.folders.first.folders.length.should == 1
  end

end
