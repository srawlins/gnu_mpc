require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/conj.dat
describe MPC, '#conj' do
  it 'calculates the conjugate of a pure real number' do
    data = [
      [[ "0x123456789abcdep+52", 53, 16], [ 0,  2], MPC.new([GMP::F( "0x123456789abcdep+52", 53, 16), GMP::F(0, 17)]), MPC::MPC_RNDNN],
      [["-0x123456789abcdep+52", 53, 16], [ 0,  3], MPC.new([GMP::F("-0x123456789abcdep+52", 53, 16), GMP::F(0, 16)]), MPC::MPC_RNDZN],
      [[ "0x123456789abcdep+52", 53, 16], [ 0,  4], MPC.new([GMP::F( "0x123456789abcdep+52", 53, 16), GMP::F(0, 15)]), MPC::MPC_RNDUN],
      [["-0x123456789abcdep+52", 53, 16], [ 0,  5], MPC.new([GMP::F("-0x123456789abcdep+52", 53, 16), GMP::F(0, 14)]), MPC::MPC_RNDDN],
      [[ "0x123456789abcdep+52", 53, 16], [ 0,  6], MPC.new([GMP::F( "0x123456789abcdep+52", 53, 16), GMP::F(0, 13)]), MPC::MPC_RNDZZ],
      [["-0x123456789abcdep+52", 53, 16], [ 0,  7], MPC.new([GMP::F("-0x123456789abcdep+52", 53, 16), GMP::F(0, 12)]), MPC::MPC_RNDUZ],
      [[ "0x123456789abcdep+52", 53, 16], [ 0,  8], MPC.new([GMP::F( "0x123456789abcdep+52", 53, 16), GMP::F(0, 11)]), MPC::MPC_RNDDZ],
      [["-0x123456789abcdep+52", 53, 16], [ 0,  9], MPC.new([GMP::F("-0x123456789abcdep+52", 53, 16), GMP::F(0, 10)]), MPC::MPC_RNDNZ],
      [[ "0x123456789abcdep+52", 53, 16], [ 0, 10], MPC.new([GMP::F( "0x123456789abcdep+52", 53, 16), GMP::F(0,  9)]), MPC::MPC_RNDUU],
      [["-0x123456789abcdep+52", 53, 16], [ 0, 11], MPC.new([GMP::F("-0x123456789abcdep+52", 53, 16), GMP::F(0,  8)]), MPC::MPC_RNDDU],
      [[ "0x123456789abcdep+52", 53, 16], [ 0, 12], MPC.new([GMP::F( "0x123456789abcdep+52", 53, 16), GMP::F(0,  7)]), MPC::MPC_RNDNU],
      [["-0x123456789abcdep+52", 53, 16], [ 0, 13], MPC.new([GMP::F("-0x123456789abcdep+52", 53, 16), GMP::F(0,  6)]), MPC::MPC_RNDZU],
      [[ "0x123456789abcdep+52", 53, 16], [ 0, 14], MPC.new([GMP::F( "0x123456789abcdep+52", 53, 16), GMP::F(0,  5)]), MPC::MPC_RNDDD],
      [["-0x123456789abcdep+52", 53, 16], [ 0, 15], MPC.new([GMP::F("-0x123456789abcdep+52", 53, 16), GMP::F(0,  4)]), MPC::MPC_RNDND],
      [[ "0x123456789abcdep+52", 53, 16], [ 0, 16], MPC.new([GMP::F( "0x123456789abcdep+52", 53, 16), GMP::F(0,  3)]), MPC::MPC_RNDZD],
      [["-0x123456789abcdep+52", 53, 16], [ 0, 17], MPC.new([GMP::F("-0x123456789abcdep+52", 53, 16), GMP::F(0,  2)]), MPC::MPC_RNDUD],
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.conj(rounding_mode)
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end

  it 'calculates the conjugate of a pure imaginary argument' do
    data = [
      [[0, 53], ["-0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 53), GMP::F( "0x123456789abcdep+52", 53, 16)]), MPC::MPC_RNDNN],
      [[0, 53], ["-0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 51), GMP::F( "0x123456789abcdep+52", 54, 16)]), MPC::MPC_RNDZN],
      [[0, 53], [ "0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 49), GMP::F("-0x123456789abcdep+52", 55, 16)]), MPC::MPC_RNDUN],
      [[0, 53], [ "0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 47), GMP::F("-0x123456789abcdep+52", 56, 16)]), MPC::MPC_RNDUN],
      [[0, 53], ["-0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 45), GMP::F( "0x123456789abcdep+52", 57, 16)]), MPC::MPC_RNDZZ],
      [[0, 53], ["-0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 43), GMP::F( "0x123456789abcdep+52", 58, 16)]), MPC::MPC_RNDUZ],
      [[0, 53], [ "0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 41), GMP::F("-0x123456789abcdep+52", 59, 16)]), MPC::MPC_RNDDZ],
      [[0, 53], [ "0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 39), GMP::F("-0x123456789abcdep+52", 60, 16)]), MPC::MPC_RNDNZ],
      [[0, 53], ["-0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 37), GMP::F( "0x123456789abcdep+52", 61, 16)]), MPC::MPC_RNDUU],
      [[0, 53], ["-0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 35), GMP::F( "0x123456789abcdep+52", 62, 16)]), MPC::MPC_RNDDU],
      [[0, 53], [ "0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 33), GMP::F("-0x123456789abcdep+52", 63, 16)]), MPC::MPC_RNDNU],
      [[0, 53], [ "0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 31), GMP::F("-0x123456789abcdep+52", 64, 16)]), MPC::MPC_RNDZU],
      [[0, 53], ["-0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 29), GMP::F( "0x123456789abcdep+52", 65, 16)]), MPC::MPC_RNDDD],
      [[0, 53], ["-0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 27), GMP::F( "0x123456789abcdep+52", 66, 16)]), MPC::MPC_RNDND],
      [[0, 53], [ "0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 25), GMP::F("-0x123456789abcdep+52", 67, 16)]), MPC::MPC_RNDZD],
      [[0, 53], [ "0x123456789abcdep+52", 53, 16], MPC.new([GMP::F(0, 23), GMP::F("-0x123456789abcdep+52", 68, 16)]), MPC::MPC_RNDUD]
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.conj(rounding_mode)
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end
end
