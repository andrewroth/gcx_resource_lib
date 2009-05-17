require "#{File.dirname(__FILE__)}/../init"

describe Auth do
  it "should login given a valid username and password" do
    lambda {
      auth = Auth.new 'studentseven7@gmail.com', 'student7!'
      auth.authenticated?.should == true
    }.should_not raise_error
  end

  it "should not login given an invalid username and password" do
    lambda {
      auth = Auth.new 'studentseven7@gmail.com', 'invalid'
    }.should raise_error
  end
end
