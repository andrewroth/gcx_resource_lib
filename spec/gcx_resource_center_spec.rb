require "#{File.dirname(__FILE__)}/../init"

describe GcxResourceCenter do

  before do
    auth = Auth.new('studentseven7@gmail.com', 'student7!')
    @agent = auth.agent
    @gcx = GcxResourceCenter.new(@agent, :staging)
    create_test_file
  end

  after do
    delete_test_file
  end

  def create_test_file
    f = File.open('test.txt', 'w')
    f.puts('test gcx upload')
    f.close
  end

  def delete_test_file
    File.delete 'test.txt'
  end

  it "should list files" do
    # I've previously set up a community on staging, 
    # https://stage.mygcx.org/AndrewTest/screen/resourceCenter

    lambda {
      @gcx.list :community => 'AndrewTest'
    }.should_not raise_error
  end

=begin
# this should be an integration test
#
  it "should upload a file correctly, including setting the details" do
    @fo.upload :community => 'AndrewTest',
      :file => File.open('test.txt'),
      :title => 'title',
      :author => 'author',
      :owner => 'owner',
      :language => 'language',
      :summary => 'summary',
      :permissions => 'permissions'

    file = @fo.list(:community => 'AndrewTest').find{ |f| f.title == 'title' }

    file.title.should == 'title'
    file.author.should == 'author'
    file.owner.should == 'owner'
    file.language.should == 'language'
    file.summary.should == 'summary'

    file.destroy!
  end
=end

  it "should correctly list a folder" do
    @agent.should_receive(:get).and_return(mock('page', :body => %|
<?xml version="1.0" encoding="UTF-8"?><resourceCenter><files><node community="AndrewTest2" filename="test2.jpg" folderid="9" id="2" label="PublicHome_topgraphic.jpg" size="39608" type="image/jpeg" uploaderGUID="3A3168E8-5E53-5177-3835-CDE816BDB897"/><node community="AndrewTest" filename="PublicHome_topgraphic.jpg" folderid="9" id="1" label="PublicHome_topgraphic.jpg" size="39608" type="image/jpeg" uploaderGUID="3A3168E8-5E53-5177-3835-CDE816BDB897"/></files><folders community="AndrewTest" id="9" label=""></folders></resourceCenter>
|))
    files, folders = @fo.list(:community => 'AndrewTest')
    files.length.should == 2
    folders.length.should == 0
  end
end
