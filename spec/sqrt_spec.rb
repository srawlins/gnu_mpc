require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/sqrt.dat
describe MPC, '#sqrt' do
  it 'should calculate the square root of a pure real number' do
    data = [
      [[ "0x16a09e667f3bcdp-52", 53, 16], [ 0,                       53],     MPC.new([GMP::F( 2, 53),  GMP::F(0, 17)]), MPC::MPC_RNDNN],
      [[ 0,                      53],     [ "0x16a09e667f3bcdp-52",  53, 16], MPC.new([GMP::F(-2, 54),  GMP::F(0, 16)]), MPC::MPC_RNDZN],
      [[ "0x16a09e667f3bcdp-52", 53, 16], [ 0,                       53],     MPC.new([GMP::F( 2, 55), -GMP::F(0, 15)]), MPC::MPC_RNDUN],
      [[ 0,                      53],     ["-0x16a09e667f3bcdp-52",  53, 16], MPC.new([GMP::F(-2, 56), -GMP::F(0, 14)]), MPC::MPC_RNDDN],
      [[ "0x5a827999fcef30p-54", 53, 16], [ 0,                       53],     MPC.new([GMP::F( 2, 57),  GMP::F(0, 13)]), MPC::MPC_RNDZZ],
      [[ 0,                      53],     [ "0x5a827999fcef30p-54",  53, 16], MPC.new([GMP::F(-2, 58),  GMP::F(0, 12)]), MPC::MPC_RNDUZ],
      [[ "0x5a827999fcef30p-54", 53, 16], [ 0,                       53],     MPC.new([GMP::F( 2, 59), -GMP::F(0, 11)]), MPC::MPC_RNDDZ],
      [[ 0,                      53],     ["-0x5a827999fcef30p-54",  53, 16], MPC.new([GMP::F(-2, 60), -GMP::F(0, 10)]), MPC::MPC_RNDNZ],
      [[ "0x16a09e667f3bcdp-52", 53, 16], [ 0,                       53],     MPC.new([GMP::F( 2, 61),  GMP::F(0,  9)]), MPC::MPC_RNDUU],
      [[ 0,                      53],     [ "0x16a09e667f3bcdp-52",  53, 16], MPC.new([GMP::F(-2, 62),  GMP::F(0,  8)]), MPC::MPC_RNDDU],
      [[ "0x16a09e667f3bcdp-52", 53, 16], [ 0,                       53],     MPC.new([GMP::F( 2, 63), -GMP::F(0,  7)]), MPC::MPC_RNDNU],
      [[ 0,                      53],     ["-0x5a827999fcef30p-54",  53, 16], MPC.new([GMP::F(-2, 64), -GMP::F(0,  6)]), MPC::MPC_RNDZU],
      [[ "0x5a827999fcef30p-54", 53, 16], [ 0,                       53],     MPC.new([GMP::F( 2, 65),  GMP::F(0,  5)]), MPC::MPC_RNDDD],
      [[ 0,                      53],     [ "0x5a827999fcef30p-54",  53, 16], MPC.new([GMP::F(-2, 66),  GMP::F(0,  4)]), MPC::MPC_RNDND],
      [[ "0x5a827999fcef30p-54", 53, 16], [ 0,                       53],     MPC.new([GMP::F( 2, 67), -GMP::F(0,  3)]), MPC::MPC_RNDZD],
      [[ 0,                      53],     ["-0x16a09e667f3bcdp-52",  53, 16], MPC.new([GMP::F(-2, 68), -GMP::F(0,  2)]), MPC::MPC_RNDUD]
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.sqrt(rounding_mode)
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end

  it 'should calculate the square root of a pure imaginary number' do
    data = [
      [["0x16a09e667f3bcdp-52", 53, 16], [ "0x16a09e667f3bcdp-52", 53, 16], MPC.new([GMP::F(0, 53), GMP::F( 4, 53, 16)]), MPC::MPC_RNDNN],
      [["0x5a827999fcef30p-54", 53, 16], [ "0x16a09e667f3bcdp-52", 53, 16], MPC.new([GMP::F(0, 51), GMP::F( 4, 54, 16)]), MPC::MPC_RNDZN],
      [["0x16a09e667f3bcdp-52", 53, 16], ["-0x16a09e667f3bcdp-52", 53, 16], MPC.new([GMP::F(0, 49), GMP::F(-4, 55, 16)]), MPC::MPC_RNDUN],
      [["0x5a827999fcef30p-54", 53, 16], ["-0x16a09e667f3bcdp-52", 53, 16], MPC.new([GMP::F(0, 47), GMP::F(-4, 56, 16)]), MPC::MPC_RNDDN],
      [["0x5a827999fcef30p-54", 53, 16], [ "0x5a827999fcef30p-54", 53, 16], MPC.new([GMP::F(0, 45), GMP::F( 4, 57, 16)]), MPC::MPC_RNDZZ],
      [["0x16a09e667f3bcdp-52", 53, 16], [ "0x5a827999fcef30p-54", 53, 16], MPC.new([GMP::F(0, 43), GMP::F( 4, 58, 16)]), MPC::MPC_RNDUZ],
      [["0x5a827999fcef30p-54", 53, 16], ["-0x5a827999fcef30p-54", 53, 16], MPC.new([GMP::F(0, 41), GMP::F(-4, 59, 16)]), MPC::MPC_RNDDZ],
      [["0x16a09e667f3bcdp-52", 53, 16], ["-0x5a827999fcef30p-54", 53, 16], MPC.new([GMP::F(0, 39), GMP::F(-4, 60, 16)]), MPC::MPC_RNDNZ],
      [["0x16a09e667f3bcdp-52", 53, 16], [ "0x16a09e667f3bcdp-52", 53, 16], MPC.new([GMP::F(0, 37), GMP::F( 4, 61, 16)]), MPC::MPC_RNDUU],
      [["0x5a827999fcef30p-54", 53, 16], [ "0x16a09e667f3bcdp-52", 53, 16], MPC.new([GMP::F(0, 35), GMP::F( 4, 62, 16)]), MPC::MPC_RNDDU],
      [["0x16a09e667f3bcdp-52", 53, 16], ["-0x5a827999fcef30p-54", 53, 16], MPC.new([GMP::F(0, 33), GMP::F(-4, 63, 16)]), MPC::MPC_RNDNU],
      [["0x5a827999fcef30p-54", 53, 16], ["-0x5a827999fcef30p-54", 53, 16], MPC.new([GMP::F(0, 31), GMP::F(-4, 64, 16)]), MPC::MPC_RNDZU],
      [["0x5a827999fcef30p-54", 53, 16], [ "0x5a827999fcef30p-54", 53, 16], MPC.new([GMP::F(0, 29), GMP::F( 4, 65, 16)]), MPC::MPC_RNDDD],
      [["0x16a09e667f3bcdp-52", 53, 16], [ "0x5a827999fcef30p-54", 53, 16], MPC.new([GMP::F(0, 27), GMP::F( 4, 66, 16)]), MPC::MPC_RNDND],
      [["0x5a827999fcef30p-54", 53, 16], ["-0x16a09e667f3bcdp-52", 53, 16], MPC.new([GMP::F(0, 25), GMP::F(-4, 67, 16)]), MPC::MPC_RNDZD],
      [["0x16a09e667f3bcdp-52", 53, 16], ["-0x16a09e667f3bcdp-52", 53, 16], MPC.new([GMP::F(0, 23), GMP::F(-4, 68, 16)]), MPC::MPC_RNDUD],
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.sqrt(rounding_mode)
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end

  it 'should calculate the square root of examples of bugs fixed in r160 2008-07-15' do
      actual = MPC.new([GMP::F("0b1.101010001010100000p+117", 19, 2), GMP::F("-0b1.001110111101100001p-158", 19, 2)]).sqrt(MPC::MPC_RNDNZ, 19)
      actual.real.should eq GMP::F( "0b11101001001001001100p+39", 19, 2)
      actual.imag.should eq GMP::F("-0b1010110101100111011p-236", 19, 2)

      actual = MPC.new([GMP::F(0, 2), GMP::F("-0b11p+203", 2, 2)]).sqrt(MPC::MPC_RNDNZ, 2)
      actual.real.should eq GMP::F( "0b11p+100", 2, 2)
      actual.imag.should eq GMP::F("-0b11p+100", 2, 2)

      actual = MPC.new([GMP::F("-0b11p+235", 2, 2), -GMP::F(0, 2)]).sqrt(MPC::MPC_RNDNZ, 2)
      actual.real.should eq GMP::F(0, 2)
      actual.imag.should eq GMP::F("-0b10p+117", 2, 2)
  end

  ### There are still more tests in sqrt.data, each a result of some bug or other thing
end
