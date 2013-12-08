require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/log10.dat
describe MPC, '#log10' do
  it 'calculates the base 10 logarithm of +1 +- i*0' do
    pending("log10 introduced in MPC 1.0.0") if MPC::MPC_VERSION[0] == "0"

    actual = MPC.new([1, 0], 2).log10
    expect(actual.real).to eq 0
    expect(actual.imag).to eq 0
  end

  it 'calculates the base 10 logarithm of 10 +- i*0' do
    pending("log10 introduced in MPC 1.0.0") if MPC::MPC_VERSION[0] == "0"

    actual = MPC.new([GMP::F(10, 4), GMP::F(0, 2)]).log10
    expect(actual.real).to eq 1
    expect(actual.imag).to eq 0
  end

  it 'calculates the base 10 logarithm of 100 +- i*0' do
    pending("log10 introduced in MPC 1.0.0") if MPC::MPC_VERSION[0] == "0"

    actual = MPC.new([GMP::F(100, 5), GMP::F(0, 2)]).log10
    expect(actual.real).to eq 2
    expect(actual.imag).to eq 0
  end

  it 'calculates the base 10 logarithm of x +i*y with either x or y zero and the other non-zero' do
    pending("log10 introduced in MPC 1.0.0") if MPC::MPC_VERSION[0] == "0"

    data = [
      [["0x13afeb354b7d97p-52", 53, 16], [ 0,  2],                          MPC.new([GMP::F( "0x11", 5, 16),  GMP::F(0, 2)]), MPC::MPC_RNDNN],
      [["0x13afeb354b7d97p-52", 53, 16], [ "0x15d47c4cb2fba1p-53", 53, 16], MPC.new([GMP::F(0, 2),  GMP::F( "0x11", 5, 16)]), MPC::MPC_RNDNN],
      [["0x1475c655fbc11p-48",  53, 16], [ "0x15d47c4cb2fba1p-52", 53, 16], MPC.new([GMP::F("-0x13", 5, 16),  GMP::F(0, 2)]), MPC::MPC_RNDNN],
      [["0x1475c655fbc11p-48",  53, 16], ["-0x15d47c4cb2fba1p-52", 53, 16], MPC.new([GMP::F("-0x13", 5, 16), -GMP::F(0, 2)]), MPC::MPC_RNDNN],
      [["0x1475c655fbc11p-48",  53, 16], ["-0x15d47c4cb2fba1p-53", 53, 16], MPC.new([GMP::F(0, 2),  GMP::F("-0x13", 5, 16)]), MPC::MPC_RNDNN],
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.log10(rounding_mode)
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end

  ### There are still more tests in log10.data, each a result of some bug or other thing
end
