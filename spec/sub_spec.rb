require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/sub.dat
describe MPC, '#sub' do
  it 'should calculate the difference between two real MPCs' do
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

  it 'should calculate the difference between two a real and two imaginary MPCs' do
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
