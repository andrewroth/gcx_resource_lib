require "#{File.dirname(__FILE__)}/../init"

describe 'FileOperator' do

  before do
    auth = Auth.new('studentseven7@gmail.com', 'student7!')
    @fo = FileOperator.new(auth.agent, :staging)
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
      @fo.list :community => 'AndrewTest'
    }.should_not raise_error
  end

  it "should upload a file" do
    @fo.upload :community => 'AndrewTest',
      :file => File.open('test.txt')
    file = fo.list(:community => 'AndrewTest').find { |f|
      f.title == 'test.txt'
    }
    file.should_not be_nil
    file.destroy!
  end

  it "should get details on a file" do
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
end
