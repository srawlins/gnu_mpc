require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/neg.dat
describe MPC, '#sqr' do
  it 'should calculate the square of a pure real argument' do
    data = [
      [["0x12345676543230p+52", 53, 16], [ 0,  2], MPC.new([GMP::F( "0x1111111000000f", 53, 16), GMP::F(0, 17)]), MPC::MPC_RNDNN],
      [["0x1234567654322fp+52", 53, 16], [ 0,  3], MPC.new([GMP::F("-0x1111111000000f", 54, 16), GMP::F(0, 16)]), MPC::MPC_RNDZN],
      [["0x12345676543230p+52", 53, 16], [ 0,  4], MPC.new([GMP::F( "0x1111111000000f", 55, 16), GMP::F(0, 15)]), MPC::MPC_RNDUN],
      [["0x1234567654322fp+52", 53, 16], [ 0,  5], MPC.new([GMP::F("-0x1111111000000f", 56, 16), GMP::F(0, 14)]), MPC::MPC_RNDDN],
      [["0x1234567654322fp+52", 53, 16], [ 0,  6], MPC.new([GMP::F( "0x1111111000000f", 57, 16), GMP::F(0, 13)]), MPC::MPC_RNDZZ],
      [["0x12345676543230p+52", 53, 16], [ 0,  7], MPC.new([GMP::F("-0x1111111000000f", 58, 16), GMP::F(0, 12)]), MPC::MPC_RNDUZ],
      [["0x1234567654322fp+52", 53, 16], [ 0,  8], MPC.new([GMP::F( "0x1111111000000f", 59, 16), GMP::F(0, 11)]), MPC::MPC_RNDDZ],
      [["0x12345676543230p+52", 53, 16], [ 0,  9], MPC.new([GMP::F("-0x1111111000000f", 60, 16), GMP::F(0, 10)]), MPC::MPC_RNDNZ],
      [["0x12345676543230p+52", 53, 16], [ 0, 10], MPC.new([GMP::F( "0x1111111000000f", 61, 16), GMP::F(0,  9)]), MPC::MPC_RNDUU],
      [["0x1234567654322fp+52", 53, 16], [ 0, 11], MPC.new([GMP::F("-0x1111111000000f", 62, 16), GMP::F(0,  8)]), MPC::MPC_RNDDU],
      [["0x12345676543230p+52", 53, 16], [ 0, 12], MPC.new([GMP::F( "0x1111111000000f", 63, 16), GMP::F(0,  7)]), MPC::MPC_RNDNU],
      [["0x1234567654322fp+52", 53, 16], [ 0, 13], MPC.new([GMP::F("-0x1111111000000f", 64, 16), GMP::F(0,  6)]), MPC::MPC_RNDZU],
      [["0x1234567654322fp+52", 53, 16], [ 0, 14], MPC.new([GMP::F( "0x1111111000000f", 65, 16), GMP::F(0,  5)]), MPC::MPC_RNDDD],
      [["0x12345676543230p+52", 53, 16], [ 0, 15], MPC.new([GMP::F("-0x1111111000000f", 66, 16), GMP::F(0,  4)]), MPC::MPC_RNDND],
      [["0x1234567654322fp+52", 53, 16], [ 0, 16], MPC.new([GMP::F( "0x1111111000000f", 67, 16), GMP::F(0,  3)]), MPC::MPC_RNDZD],
      [["0x12345676543230p+52", 53, 16], [ 0, 17], MPC.new([GMP::F("-0x1111111000000f", 68, 16), GMP::F(0,  2)]), MPC::MPC_RNDUD],
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.sqr(rounding_mode)
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end

  it 'should calculate the square of a pure imaginary argument' do
    data = [
      [["-0xE1000002000000p+56", 53, 16], [ 0, 53], MPC.new([GMP::F(0, 53), GMP::F( "0xf0000001111111", 53, 16)]), MPC::MPC_RNDNN],
      [["-0xe1000001fffff8p+56", 53, 16], [ 0, 52], MPC.new([GMP::F(0, 51), GMP::F( "0xf0000001111111", 54, 16)]), MPC::MPC_RNDZN],
      [["-0xe1000001fffff8p+56", 53, 16], [ 0, 51], MPC.new([GMP::F(0, 49), GMP::F("-0xf0000001111111", 55, 16)]), MPC::MPC_RNDUN],
      [["-0xE1000002000000p+56", 53, 16], [ 0, 50], MPC.new([GMP::F(0, 47), GMP::F("-0xf0000001111111", 56, 16)]), MPC::MPC_RNDDN],
      [["-0xe1000001fffff8p+56", 53, 16], [ 0, 49], MPC.new([GMP::F(0, 45), GMP::F( "0xf0000001111111", 57, 16)]), MPC::MPC_RNDZZ],
      [["-0xe1000001fffff8p+56", 53, 16], [ 0, 48], MPC.new([GMP::F(0, 43), GMP::F( "0xf0000001111111", 58, 16)]), MPC::MPC_RNDUZ],
      [["-0xE1000002000000p+56", 53, 16], [ 0, 47], MPC.new([GMP::F(0, 41), GMP::F("-0xf0000001111111", 59, 16)]), MPC::MPC_RNDDZ],
      [["-0xE1000002000000p+56", 53, 16], [ 0, 46], MPC.new([GMP::F(0, 39), GMP::F("-0xf0000001111111", 60, 16)]), MPC::MPC_RNDNZ],
      [["-0xe1000001fffff8p+56", 53, 16], [ 0, 45], MPC.new([GMP::F(0, 37), GMP::F( "0xf0000001111111", 61, 16)]), MPC::MPC_RNDUU],
      [["-0xE1000002000000p+56", 53, 16], [ 0, 44], MPC.new([GMP::F(0, 35), GMP::F( "0xf0000001111111", 62, 16)]), MPC::MPC_RNDDU],
      [["-0xE1000002000000p+56", 53, 16], [ 0, 43], MPC.new([GMP::F(0, 33), GMP::F("-0xf0000001111111", 63, 16)]), MPC::MPC_RNDNU],
      [["-0xe1000001fffff8p+56", 53, 16], [ 0, 42], MPC.new([GMP::F(0, 31), GMP::F("-0xf0000001111111", 64, 16)]), MPC::MPC_RNDZU],
      [["-0xE1000002000000p+56", 53, 16], [ 0, 41], MPC.new([GMP::F(0, 29), GMP::F("-0xf0000001111111", 65, 16)]), MPC::MPC_RNDDD],
      [["-0xE1000002000000p+56", 53, 16], [ 0, 40], MPC.new([GMP::F(0, 27), GMP::F("-0xf0000001111111", 66, 16)]), MPC::MPC_RNDND],
      [["-0xe1000001fffff8p+56", 53, 16], [ 0, 39], MPC.new([GMP::F(0, 25), GMP::F("-0xf0000001111111", 67, 16)]), MPC::MPC_RNDZD],
      [["-0xe1000001fffff8p+56", 53, 16], [ 0, 38], MPC.new([GMP::F(0, 23), GMP::F("-0xf0000001111111", 68, 16)]), MPC::MPC_RNDUD],
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.sqr(rounding_mode)
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end

  it 'should calculate the square of a pure imaginary argument' do
    data = [
      [[ "0x10000000020000p+04", 53, 16], [ "0x10000000effff",      53, 16], [ "0x400008000180fp-22", 53, 16], [ "0x7ffff0077efcbp-32",   53, 16], MPC::MPC_RNDNN],
      [[ "0x3ffffffffffffd",     53, 16], [ "0x7ffffffffffff4p+52", 53, 16], [ "0x1fffffffffffff",    53, 16], [ "0x1ffffffffffffe",      53, 16], MPC::MPC_RNDZN],
      [[ "0x1c16e5d4c4d5e7p-45", 53, 16], ["-0x7ffffff800007p-47",  53, 16], [ "0xf",                 53, 16], [ "-0x1111111000000fp-53", 53, 16], MPC::MPC_RNDUN],
    ]
    data.each do |expected_real, expected_imag, input_real, input_imag, rounding_mode|
      actual = MPC.new([GMP::F.new(*input_real), GMP::F(*input_imag)]).sqr(rounding_mode)
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end
end
