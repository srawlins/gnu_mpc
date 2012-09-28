require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "#proj" do
  it "should calculate the projection correctly" do
    MPC.new([GMP::F(-1), -GMP::F(0)]).proj.real.should eq -1
    MPC.new([GMP::F(-1), -GMP::F(0)]).proj.imag.should eq 0

    MPC.new([-GMP::F(0),  GMP::F(-1)]).proj.real.should eq 0
    MPC.new([-GMP::F(0),  GMP::F(-1)]).proj.imag.should eq -1

    MPC.new([-GMP::F(0), -GMP::F(0)]).proj.real.should eq 0
    MPC.new([-GMP::F(0), -GMP::F(0)]).proj.imag.should eq 0

    MPC.new([-GMP::F(0),  GMP::F(1)]).proj.real.should eq 0
    MPC.new([-GMP::F(0),  GMP::F(1)]).proj.imag.should eq 1

    MPC.new([ GMP::F(1),  GMP::F(0)]).proj.real.should eq 1
    MPC.new([ GMP::F(1),  GMP::F(0)]).proj.imag.should eq 0
  end
end
