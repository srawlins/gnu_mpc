require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, '#add' do
  it 'should calculate the sum of an MPC and a Fixnum' do
    op1 = MPC.new([7, 16])
    actual = op1.add(0)
    actual.real.should eq 7
    actual.imag.should eq 16

    actual = op1.add(6)
    actual.real.should eq 13
    actual.imag.should eq 16

    actual = op1.add(-1000)
    actual.real.should eq -993
    actual.imag.should eq 16

    op1 = MPC.new([GMP::F(3.1), GMP::F(16)])
    actual = op1.add(3)
    actual.real.should eq GMP::F(6.1)
    actual.imag.should eq 16
  end

  it 'should calculate the sum of an MPC and a GMP::Z' do
    op1 = MPC.new([7, 16])
    actual = op1.add(GMP::Z(0))
    actual.real.should eq 7
    actual.imag.should eq 16

    actual = op1.add(GMP::Z(-1000))
    actual.real.should eq -993
    actual.imag.should eq 16

    op1 = MPC.new([GMP::F(3.1), GMP::F(16)])
    actual = op1.add(GMP::Z(3))
    actual.real.should eq GMP::F(6.1)
    actual.imag.should eq 16
  end

  it 'should calculate the sum of an MPC and a Bignum' do
    op1 = MPC.new([7, 16])
    actual = op1.add(2**65)  # 36893488147419103232
    actual.real.should eq 36893488147419103239
    actual.imag.should eq 16

    op1 = MPC.new([GMP::F(3.1), GMP::F(16)])
    actual = op1.add(2**65)  # 36893488147419103232
    actual.real.should eq GMP::F("36893488147419103235.1")
    actual.imag.should eq 16
  end
end
