require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/sub.dat
describe MPC, '#sub' do
  it 'calculates the difference between two real MPCs' do
    op1 = MPC.new([GMP::F(1), GMP::F(0)])
    op2 = MPC.new([GMP::F("0x1p-105", 53, 16), GMP::F(0)])

    actual = op1.sub(op2, MPC::MPC_RNDNN)
    actual.real.should eq GMP::F("0x10000000000000p-52", 53, 16)
    actual.imag.should eq GMP::F(0)

    actual = op1.sub(op2, MPC::MPC_RNDZZ)
    actual.real.should eq GMP::F("0x1fffffffffffffp-53", 53, 16)
    actual.imag.should eq GMP::F(0)

    actual = op1.sub(op2, MPC::MPC_RNDUU)
    actual.real.should eq GMP::F("0x10000000000000p-52", 53, 16)
    actual.imag.should eq GMP::F(0)

    actual = op1.sub(op2, MPC::MPC_RNDDD)
    actual.real.should eq GMP::F("0x1fffffffffffffp-53", 53, 16)
    actual.imag.should eq GMP::F(0)
  end

  it 'calculates the difference between two a real and two imaginary MPCs' do
    op1 = MPC.new([GMP::F(0), GMP::F("0x10000000000000p-106", 53, 16)])
    op2 = MPC.new([0, 1])

    actual = op1.sub(op2, MPC::MPC_RNDNN)
    actual.real.should eq GMP::F(0)
    actual.imag.should eq GMP::F("-0x10000000000000p-52", 53, 16)

    op1 = MPC.new([GMP::F(0), GMP::F("0x10000000000001p-106", 53, 16)])

    actual = op1.sub(op2, MPC::MPC_RNDNN)
    actual.real.should eq GMP::F(0)
    actual.imag.should eq GMP::F("-0x1fffffffffffffp-53", 53, 16)

    actual = op1.sub(op2, MPC::MPC_RNDZZ)
    actual.real.should eq GMP::F(0)
    actual.imag.should eq GMP::F("-0x1fffffffffffffp-53", 53, 16)

    actual = op1.sub(op2, MPC::MPC_RNDUU)
    actual.real.should eq GMP::F(0)
    actual.imag.should eq GMP::F("-0x1fffffffffffffp-53", 53, 16)

    actual = op1.sub(op2, MPC::MPC_RNDDD)
    actual.real.should eq GMP::F(0)
    actual.imag.should eq GMP::F("-0x10000000000000p-52", 53, 16)
  end
end

describe MPC, '#-' do
  it 'calculates the difference between MPCs with #-' do
    op1 = MPC.new([GMP::F(1), GMP::F(0)])
    op2 = MPC.new([GMP::F("0x1p-105", 53, 16), GMP::F(0)])

    actual = op1 - op2
    expect(actual.real).to eq GMP::F("0x10000000000000p-52", 53, 16)
    expect(actual.imag).to eq GMP::F(0)
  end
end

describe MPC, '#sub with more arguments' do
  it 'calculates the difference between MPCs with a rounding mode and precision' do
    op1 = MPC.new([GMP::F(1), GMP::F(0)])
    op2 = MPC.new([GMP::F("0x1p-105", 53, 16), GMP::F(0)])

    actual = op1.sub(op2, MPC::MPC_RNDNN, 32)
    expect(actual.real).to eq GMP::F("0x10000000000000p-52", 32, 16)
    expect(actual.imag).to eq GMP::F(0)
  end

  it 'calculates the difference between MPCs with a rounding mode and precision in a hash' do
    op1 = MPC.new([GMP::F(1), GMP::F(0)])
    op2 = MPC.new([GMP::F("0x1p-105", 53, 16), GMP::F(0)])

    actual = op1.sub(op2, rounding_mode: MPC::MPC_RNDZZ, precision: 64)
    expect(actual.real).to eq GMP::F("0x1fffffffffffffffep-65", 96, 16)
    expect(actual.imag).to eq GMP::F(0)
  end

  it 'raises when 0 arguments are passed' do
    expect { MPC.new(1).sub() }.to raise_error
  end

  it 'raises when too many arguments are passed' do
    expect { MPC.new(1).sub(1,2,3,4,5) }.to raise_error
  end
end
