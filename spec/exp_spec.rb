require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/exp.dat
describe MPC, '#exp' do
  it 'calculates the exponential of a pure real number' do
    data = [
      [["0x1936dc5690c08fp-44", 53, 16], [ 0,  2], MPC.new([GMP::F( 6, 53),  GMP::F(0, 17)]), MPC::MPC_RNDNN],
      [["0x4b0556e084f3d0p-60", 53, 16], [ 0,  3], MPC.new([GMP::F(-4, 54),  GMP::F(0, 16)]), MPC::MPC_RNDZN],
      [["0xec7325c6a6ed70p-53", 53, 16], [ 0,  4], MPC.new([GMP::F( 2, 55),  GMP::F(0, 15)]), MPC::MPC_RNDUN],
      [["0x178b56362cef37p-54", 53, 16], [ 0,  5], MPC.new([GMP::F(-1, 56),  GMP::F(0, 14)]), MPC::MPC_RNDDN],
      [["0x3699205c4e74b0p-48", 53, 16], [ 0,  6], MPC.new([GMP::F( 4, 57),  GMP::F(0, 13)]), MPC::MPC_RNDZZ],
      [["0x454aaa8efe0730p-57", 53, 16], [ 0,  7], MPC.new([GMP::F(-2, 58),  GMP::F(0, 12)]), MPC::MPC_RNDUZ],
      [["0x15bf0a8b145769p-51", 53, 16], [ 0,  8], MPC.new([GMP::F( 1, 59),  GMP::F(0, 11)]), MPC::MPC_RNDDZ],
      [["0xa2728f889ea6b0p-64", 53, 16], [ 0,  9], MPC.new([GMP::F(-6, 60),  GMP::F(0, 10)]), MPC::MPC_RNDNZ],
      [["0xec7325c6a6ed70p-53", 53, 16], [ 0, 10], MPC.new([GMP::F( 2, 61),  GMP::F(0,  9)]), MPC::MPC_RNDUU],
      [["0x178b56362cef37p-54", 53, 16], [ 0, 11], MPC.new([GMP::F(-1, 62),  GMP::F(0,  8)]), MPC::MPC_RNDDU],
      [["0x1936dc5690c08fp-44", 53, 16], [ 0, 12], MPC.new([GMP::F( 6, 63),  GMP::F(0,  7)]), MPC::MPC_RNDNU],
      [["0x4b0556e084f3d0p-60", 53, 16], [ 0, 13], MPC.new([GMP::F(-4, 64),  GMP::F(0,  6)]), MPC::MPC_RNDZU],
      [["0x15bf0a8b145769p-51", 53, 16], [ 0, 14], MPC.new([GMP::F( 1, 65),  GMP::F(0,  5)]), MPC::MPC_RNDDD],
      [["0xa2728f889ea6b0p-64", 53, 16], [ 0, 15], MPC.new([GMP::F(-6, 66),  GMP::F(0,  4)]), MPC::MPC_RNDND],
      [["0x3699205c4e74b0p-48", 53, 16], [ 0, 16], MPC.new([GMP::F( 4, 66),  GMP::F(0,  3)]), MPC::MPC_RNDZD],
      [["0x454aaa8efe0730p-57", 53, 16], [ 0, 17], MPC.new([GMP::F(-2, 66),  GMP::F(0,  2)]), MPC::MPC_RNDUD]
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.exp(rounding_mode)
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end

  it 'calculates the exponential of a pure imaginary number' do
    data = [
      [[ "0x1eb9b7097822f5p-53", 53, 16], ["-0x4787c62ac28b0p-52",  53, 16], MPC.new([GMP::F(0,53), GMP::F( 6, 53)]), MPC::MPC_RNDNN],
      [["-0x53aa981b6c9300p-55", 53, 16], ["-0xc1bdceeee0f57p-52",  53, 16], MPC.new([GMP::F(0,51), GMP::F( 4, 54)]), MPC::MPC_RNDZN],
      [["-0x6a88995d4dc810p-56", 53, 16], ["-0xe8c7b7568da23p-52",  53, 16], MPC.new([GMP::F(0,49), GMP::F(-2, 55)]), MPC::MPC_RNDUN],
      [[ "0x114a280fb5068bp-53", 53, 16], ["-0xd76aa47848677p-52",  53, 16], MPC.new([GMP::F(0,47), GMP::F(-1, 56)]), MPC::MPC_RNDDN],
      [["-0x53aa981b6c9300p-55", 53, 16], ["-0xc1bdceeee0f57p-52",  53, 16], MPC.new([GMP::F(0,45), GMP::F( 4, 57)]), MPC::MPC_RNDZZ],
      [["-0x6a88995d4dc810p-56", 53, 16], [ "0x1d18f6ead1b445p-53", 53, 16], MPC.new([GMP::F(0,43), GMP::F( 2, 58)]), MPC::MPC_RNDUZ],
      [[ "0x114a280fb5068bp-53", 53, 16], ["-0xd76aa47848677p-52",  53, 16], MPC.new([GMP::F(0,41), GMP::F(-1, 59)]), MPC::MPC_RNDDZ],
      [[ "0x1eb9b7097822f5p-53", 53, 16], [ "0x4787c62ac28b0p-52",  53, 16], MPC.new([GMP::F(0,39), GMP::F(-6, 60)]), MPC::MPC_RNDNZ],
      [["-0x6a88995d4dc810p-56", 53, 16], [ "0xe8c7b7568da23p-52",  53, 16], MPC.new([GMP::F(0,37), GMP::F( 2, 61)]), MPC::MPC_RNDUU],
      [[ "0x114a280fb5068bp-53", 53, 16], [ "0x1aed548f090cefp-53", 53, 16], MPC.new([GMP::F(0,35), GMP::F( 1, 62)]), MPC::MPC_RNDDU],
      [[ "0x1eb9b7097822f5p-53", 53, 16], [ "0x11e1f18ab0a2c1p-54", 53, 16], MPC.new([GMP::F(0,33), GMP::F(-6, 63)]), MPC::MPC_RNDNU],
      [["-0x53aa981b6c9300p-55", 53, 16], [ "0x1837b9dddc1eafp-53", 53, 16], MPC.new([GMP::F(0,31), GMP::F(-4, 64)]), MPC::MPC_RNDZU],
      [[ "0x114a280fb5068bp-53", 53, 16], [ "0xd76aa47848677p-52",  53, 16], MPC.new([GMP::F(0,29), GMP::F( 1, 65)]), MPC::MPC_RNDDD],
      [[ "0x1eb9b7097822f5p-53", 53, 16], ["-0x11e1f18ab0a2c1p-54", 53, 16], MPC.new([GMP::F(0,27), GMP::F( 6, 66)]), MPC::MPC_RNDND],
      [["-0x53aa981b6c9300p-55", 53, 16], [ "0xc1bdceeee0f57p-52",  53, 16], MPC.new([GMP::F(0,25), GMP::F(-4, 67)]), MPC::MPC_RNDZD],
      [["-0x6a88995d4dc810p-56", 53, 16], ["-0xe8c7b7568da23p-52",  53, 16], MPC.new([GMP::F(0,23), GMP::F(-2, 68)]), MPC::MPC_RNDUD]
    ]
    data.each do |expected_real, expected_imag, input, rounding_mode|
      actual = input.exp(rounding_mode)
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end

  it 'calculates the exponential of input close to zero' do
      actual = MPC.new([GMP::F("0x1E02AE0D0F6Fp-7213521", 53, 16), GMP::F("0x5D7A2148071Fp-7213522", 53, 16)]).exp(MPC::MPC_RNDNN)
      expect(actual.real).to eq GMP::F(1)
      expect(actual.imag).to eq GMP::F("0x5D7A2148071Fp-7213522", 53, 16)
  end
end
