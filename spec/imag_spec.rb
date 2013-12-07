require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "#imag" do
  it "returns the imaginary part of an MPC generated with a Fixnum" do
    expect(MPC.new(0).imag).to eq GMP::F(0)
    expect(MPC.new(1).imag).to eq GMP::F(0)
    expect(MPC.new([0, 1]).imag).to eq GMP::F(1)
  end

  it "returns the imaginary part of an MPC generated with a GMP::Z" do
    expect(MPC.new(GMP::Z(0)).imag).to eq GMP::F(0)
    expect(MPC.new(GMP::Z(1)).imag).to eq GMP::F(0)
    expect(MPC.new([GMP::Z(7), GMP::Z(2**64)]).imag).to eq GMP::F(2**64)
    expect(MPC.new([GMP::Z(0), GMP::Z(1)]).imag).to eq GMP::F(1)
  end

  it "returns the imaginary part an MPC generated with a Float" do
    expect(MPC.new(0.0).imag).to eq GMP::F(0)
    expect(MPC.new([0.0, 1.0]).imag).to eq GMP::F(1)
    expect(MPC.new([1.0, 1.0]).imag).to eq GMP::F(1)
    expect(MPC.new([2*Math::PI, Math::PI]).imag).to eq GMP::F(Math::PI)
  end
end
