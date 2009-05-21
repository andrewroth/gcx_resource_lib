require "#{File.dirname(__FILE__)}/../init"

module Gcx
  describe Auth do
    before do
      @agent = WWW::Mechanize.new
    end

    it "should login given a valid username and password" do
      lambda {
        auth = Auth.new @agent, 'studentseven7@gmail.com', 'student7!'
        auth.authenticated?.should == true
      }.should_not raise_error
    end

    it "should not login given an invalid username and password" do
      lambda {
        auth = Auth.new @agent, 'studentseven7@gmail.com', 'invalid'
      }.should raise_error
    end
  end
end
