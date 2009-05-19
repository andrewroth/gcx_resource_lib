require "#{File.dirname(__FILE__)}/../init"

module Gcx
  describe ResourceCenter::File do
    before do
      @parent = mock('parent', :id => 3)
      @root = Hpricot(%|
<node community="AndrewTest" filename="name"
folderid="3" id="4" label="label" size="23" 
type="application/octet-stream" uploaderGUID="guid"/>
|).root
    end

    it "should check that parent's id and folderid match passing case" do
      @parent.should_receive(:id).and_return(3)
      lambda {
        @file = ResourceCenter::File.new(@parent, @root)
      }.should_not raise_error
    end

    it "should check that parent's id and folderid match failing case" do
      @parent.should_receive(:id).and_return(4)
      lambda {
        @file = ResourceCenter::File.new(@parent, @root)
      }.should raise_error
    end

    it "should store and extract attributes properly" do
      @file = ResourceCenter::File.new(@parent, @root)

      @file.community.should == 'AndrewTest'
      @file.name.should == 'name'
      @file.label.should == 'label'
      @file.size.should == 23
      @file.id.should == 4
      @file.content_type.should == 'application/octet-stream'
      @file.uploader_guid.should == 'guid'
    end
  end
end
