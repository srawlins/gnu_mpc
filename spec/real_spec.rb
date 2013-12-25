require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "#real" do
  it "returns the real part of an MPC generated with a Fixnum" do
    expect(MPC.new(0).real).to eq GMP::F(0)
    expect(MPC.new(1).real).to eq GMP::F(1)
    expect(MPC.new([1, 1]).real).to eq GMP::F(1)
  end

  it "returns the real part of an MPC generated with a GMP::Z" do
    expect(MPC.new(GMP::Z(0)).real).to eq GMP::F(0)
    expect(MPC.new(GMP::Z(1)).real).to eq GMP::F(1)
    expect(MPC.new(GMP::Z(2**64)).real).to eq GMP::F(2**64)
    expect(MPC.new([GMP::Z(1), GMP::Z(1)]).real).to eq GMP::F(1)
  end

  it "returns the real part of an MPC generated with a Float" do
    expect(MPC.new(0.0).real).to eq GMP::F(0)
    expect(MPC.new(1.0).real).to eq GMP::F(1)
    expect(MPC.new([1.0, 1.0]).real).to eq GMP::F(1)
    expect(MPC.new([2*Math::PI, Math::PI]).real).to eq GMP::F(2*Math::PI)
  end
end
