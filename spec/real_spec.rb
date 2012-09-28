require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "#real" do
  it "should return correctly for an MPC generated with a Fixnum" do
    MPC.new(0).real.should eq GMP::F(0)
    MPC.new(1).real.should eq GMP::F(1)
    MPC.new([1, 1]).real.should eq GMP::F(1)
  end

  it "should return correctly for an MPC generated with a GMP::Z" do
    MPC.new(GMP::Z(0)).real.should eq GMP::F(0)
    MPC.new(GMP::Z(1)).real.should eq GMP::F(1)
    MPC.new(GMP::Z(2**64)).real.should eq GMP::F(2**64)
    MPC.new([GMP::Z(1), GMP::Z(1)]).real.should eq GMP::F(1)
  end

  it "should return correctly for an MPC generated with a Float" do
    MPC.new(0.0).real.should eq GMP::F(0)
    MPC.new(1.0).real.should eq GMP::F(1)
    MPC.new([1.0, 1.0]).real.should eq GMP::F(1)
    MPC.new([2*Math::PI, Math::PI]).real.should eq GMP::F(2*Math::PI)
  end
end
