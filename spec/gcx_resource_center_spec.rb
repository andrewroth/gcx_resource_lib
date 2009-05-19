require "#{File.dirname(__FILE__)}/../init"

module Gcx
  describe ResourceCenter do

    before do
      auth = Auth.new('studentseven7@gmail.com', 'student7!')
      @agent = auth.agent
      @rc = ResourceCenter.new(@agent, :staging)
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

=begin
# this should be an integration test
#
  it "should upload a file correctly, including setting the details" do
    @rc.root.upload :file => File.open('test.txt'),
      :title => 'title',
      :author => 'author',
      :owner => 'owner',
      :language => 'language',
      :summary => 'summary',
      :permissions => 'permissions'

    @rc.reload!
    file = @rc.root.files.find{ |f| f.title == 'title' }

    file.title.should == 'title'
    file.author.should == 'author'
    file.owner.should == 'owner'
    file.language.should == 'language'
    file.summary.should == 'summary'

    file.destroy!
  end
=end
  end
end
