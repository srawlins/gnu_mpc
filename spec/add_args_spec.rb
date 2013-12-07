require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC, '#add' do
  it 'calculate the sum of an MPC and a Fixnum' do
    op1 = MPC.new([7, 16])
    actual = op1.add(0)
    expect(actual.real).to eq 7
    expect(actual.imag).to eq 16

    actual = op1.add(6)
    expect(actual.real).to eq 13
    expect(actual.imag).to eq 16

    actual = op1.add(-1000)
    expect(actual.real).to eq -993
    expect(actual.imag).to eq 16

    op1 = MPC.new([GMP::F(3.1), GMP::F(16)])
    actual = op1.add(3)
    expect(actual.real).to eq GMP::F(6.1)
    expect(actual.imag).to eq 16
  end

  it 'calculates the sum of an MPC and a GMP::Z' do
    op1 = MPC.new([7, 16])
    actual = op1.add(GMP::Z(0))
    expect(actual.real).to eq 7
    expect(actual.imag).to eq 16

    actual = op1.add(GMP::Z(-1000))
    expect(actual.real).to eq -993
    expect(actual.imag).to eq 16

    op1 = MPC.new([GMP::F(3.1), GMP::F(16)])
    actual = op1.add(GMP::Z(3))
    expect(actual.real).to eq GMP::F(6.1)
    expect(actual.imag).to eq 16
  end

  it 'calculates the sum of an MPC and a Bignum' do
    op1 = MPC.new([7, 16])
    actual = op1.add(2**65)  # 36893488147419103232
    expect(actual.real).to eq 36893488147419103239
    expect(actual.imag).to eq 16

    op1 = MPC.new([GMP::F(3.1), GMP::F(16)])
    actual = op1.add(2**65)  # 36893488147419103232
    expect(actual.real).to eq GMP::F("36893488147419103235.1")
    expect(actual.imag).to eq 16
  end
end
