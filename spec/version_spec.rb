require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "MPC_VERSION" do
  it "should have the MPC_VERSION constant defined" do
    MPC.const_defined?(:MPC_VERSION).should be true
  end
end
