require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/log.dat
describe MPC, '#log' do
  it 'should calculate the logarithm of 1 + 0i' do
    actual = MPC.new([1, 0]).log
    actual.real.should eq 0
    actual.imag.should eq 0
  end

  it 'should calculate the logarithm of -1 + 0i' do
    actual = MPC.new([-1, 0]).log
    actual.real.should eq 0
    actual.imag.should eq GMP::F("0x3243F6A8885A3p-48", 53, 16)

    actual = MPC.new([GMP::F(-1), -GMP::F(0)]).log
    actual.real.should eq 0
    actual.imag.should eq GMP::F("-0x3243F6A8885A3p-48", 53, 16)
  end

  it 'should calculate the logarithm of x +i*y with either x or y zero and the other non-zero' do
    data = [
      [["0xB5535E0FD3FBDp-50", 53, 16], [ 0,  2],                         MPC.new([GMP::F( "0x11", 5, 16),  GMP::F(0, 2)]), MPC::MPC_RNDNN],
      [["0xB5535E0FD3FBDp-50", 53, 16], [ "0x3243F6A8885A3p-49", 53, 16], MPC.new([GMP::F(0, 2),  GMP::F( "0x11", 5, 16)]), MPC::MPC_RNDNN],
      [["0x5E38D81812CCBp-49", 53, 16], [ "0x3243F6A8885A3p-48", 53, 16], MPC.new([GMP::F("-0x13", 5, 16),  GMP::F(0, 2)]), MPC::MPC_RNDNN],
      [["0x5E38D81812CCBp-49", 53, 16], ["-0x3243F6A8885A3p-48", 53, 16], MPC.new([GMP::F("-0x13", 5, 16), -GMP::F(0, 2)]), MPC::MPC_RNDNN],
      [["0x5E38D81812CCBp-49", 53, 16], ["-0x3243F6A8885A3p-49", 53, 16], MPC.new([GMP::F(0, 2),  GMP::F("-0x13", 5, 16)]), MPC::MPC_RNDNN],
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.log(rounding_mode)
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end

  ### There are still more tests in log.data, each a result of some bug or other thing
end
