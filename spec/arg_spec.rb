require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "#arg" do
  it "returns the argument of an MPC generated with a Fixnum" do
    expect(MPC.new(0).arg).to eq GMP::F(0)
    expect(MPC.new(1).arg).to eq GMP::F(0)
    expect(MPC.new([0, 1]).arg).to eq((2*Math::PI) / 4)
    expect(MPC.new([1, 1]).arg).to eq((2*Math::PI) / 8)
  end

  it "returns the argument an MPC generated with a Float" do
    expect(MPC.new([1.0, Math.sqrt(3)]).arg).to eq((2*Math::PI) / 6)
  end
end
