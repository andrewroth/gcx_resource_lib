require "#{File.dirname(__FILE__)}/../init"

describe GcxResourceCenter::Folder do
  before do
    @parent = mock('parent', :id => 3)
    @root = Hpricot(%|
<node community="AndrewTest" id="6" label="News">
|).root

    #
    auth = Auth.new 'studentseven7@gmail.com', 'student7!'
    @fo = FileOperator.new(auth.agent, :staging)
  end

  it "should store and extract attributes properly" do
    @folder = GcxResourceCenter::Folder.new(@parent, @root, @fo)

    @folder.parent.should == @parent
    @folder.id.should == 6
    @folder.community.should == 'AndrewTest'
  end

  it "should get a list of all files when requested" do
    @folder = GcxResourceCenter::Folder.new(@parent, @root, @fo)
    @fo.should_receive(:list).with(:community => 'AndrewTest',
                                   :id => @folder.id)
    @folder.files 
  end
end
