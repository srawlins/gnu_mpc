require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, "#proj" do
  it "calculates the projection correctly" do
    expect(MPC.new([GMP::F(-1), -GMP::F(0)]).proj.real).to eq -1
    expect(MPC.new([GMP::F(-1), -GMP::F(0)]).proj.imag).to eq 0

    expect(MPC.new([-GMP::F(0),  GMP::F(-1)]).proj.real).to eq 0
    expect(MPC.new([-GMP::F(0),  GMP::F(-1)]).proj.imag).to eq -1

    expect(MPC.new([-GMP::F(0), -GMP::F(0)]).proj.real).to eq 0
    expect(MPC.new([-GMP::F(0), -GMP::F(0)]).proj.imag).to eq 0

    expect(MPC.new([-GMP::F(0),  GMP::F(1)]).proj.real).to eq 0
    expect(MPC.new([-GMP::F(0),  GMP::F(1)]).proj.imag).to eq 1

    expect(MPC.new([ GMP::F(1),  GMP::F(0)]).proj.real).to eq 1
    expect(MPC.new([ GMP::F(1),  GMP::F(0)]).proj.imag).to eq 0
  end
end
