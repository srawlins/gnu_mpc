require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/add.dat
describe MPC, '#add' do
  it 'calculates the sum of two real MPCs' do
    op1 = MPC.new([1, 0])
    op2_106 = GMP::F("0x10000000000001p-106", 53, 16)
    actual = op1.add(op2_106, MPC::MPC_RNDNN)
    expect(actual.real).to eq GMP::F("0x10000000000000p-52", 53, 16)
    expect(actual.imag).to eq GMP::F(0)

    op2_105 = GMP::F("0x10000000000001p-105", 53, 16)
    actual = op1.add(op2_105, MPC::MPC_RNDNN)
    expect(actual.real).to eq GMP::F("0x10000000000001p-52", 53, 16)
    expect(actual.imag).to eq GMP::F(0)

    op2_104 = GMP::F("0x10000000000001p-104", 53, 16)
    actual = op1.add(op2_104, MPC::MPC_RNDNN)
    expect(actual.real).to eq GMP::F("0x10000000000001p-52", 53, 16)
    expect(actual.imag).to eq GMP::F(0)

    actual = op1.add(op2_105, MPC::MPC_RNDZZ)
    expect(actual.real).to eq GMP::F("0x10000000000000p-52", 53, 16)
    expect(actual.imag).to eq GMP::F(0)

    actual = op1.add(op2_105, MPC::MPC_RNDUU)
    expect(actual.real).to eq GMP::F("0x10000000000001p-52", 53, 16)
    expect(actual.imag).to eq GMP::F(0)

    actual = op1.add(op2_105, MPC::MPC_RNDDD)
    expect(actual.real).to eq GMP::F("0x10000000000000p-52", 53, 16)
    expect(actual.imag).to eq GMP::F(0)
  end

  it 'calculates the sum of an imaginary argument with a complex one.' do
    op1 = MPC.new([0, 1])
    op2 = GMP::F(1)
    actual = op1.add(op2, MPC::MPC_RNDNN)
    expect(actual.real).to eq GMP::F(1)
    expect(actual.imag).to eq GMP::F(1)

    actual = op1.add(op2, MPC::MPC_RNDZZ)
    expect(actual.real).to eq GMP::F(1)
    expect(actual.imag).to eq GMP::F(1)

    actual = op1.add(op2, MPC::MPC_RNDUU)
    expect(actual.real).to eq GMP::F(1)
    expect(actual.imag).to eq GMP::F(1)

    actual = op1.add(op2, MPC::MPC_RNDDD)
    expect(actual.real).to eq GMP::F(1)
    expect(actual.imag).to eq GMP::F(1)
  end
end
