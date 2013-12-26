require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/sin.dat
describe MPC, '#sin' do
  it 'calculates the sine of a pure real argument' do
    data = [
      ["0x4787C62AC28Bp-48",   MPC.new([GMP::F(-6), GMP::F(0)])],
      ["0xC1BDCEEEE0F57p-52",  MPC.new([GMP::F(-4), GMP::F(0)])],
      ["-0xE8C7B7568DA23p-52", MPC.new([GMP::F(-2), GMP::F(0)])],
      ["-0xD76AA47848677p-52", MPC.new([GMP::F(-1), GMP::F(0)])],
      ["0xD76AA47848677p-52",  MPC.new([GMP::F( 1), GMP::F(0)])],
      ["0xE8C7B7568DA23p-52",  MPC.new([GMP::F( 2), GMP::F(0)])],
      ["-0xC1BDCEEEE0F57p-52", MPC.new([GMP::F( 4), GMP::F(0)])],
      ["-0x4787C62AC28Bp-48",  MPC.new([GMP::F( 6), GMP::F(0)])]
    ]
    data.each do |expected, input|
      actual = input.sin
      expect(actual.real).to eq GMP::F.new(expected, 53, 16)
      expect(actual.imag).to eq GMP::F(0)
    end
  end

  it 'calculates the sine of a pure imaginary argument' do
    data = [
      ["-0x1936D22F67C805p-45", MPC.new([GMP::F(0), GMP::F(-6)])],
      ["-0x1B4A3803703631p-48", MPC.new([GMP::F(0), GMP::F(-4)])],
      ["-0x1D03CF63B6E19Fp-51", MPC.new([GMP::F(0), GMP::F(-2)])],
      ["-0x966CFE2275CC1p-51",  MPC.new([GMP::F(0), GMP::F(-1)])],
      ["0x966CFE2275CC1p-51",   MPC.new([GMP::F(0), GMP::F( 1)])],
      ["0x1D03CF63B6E19Fp-51",  MPC.new([GMP::F(0), GMP::F( 2)])],
      ["0x1B4A3803703631p-48",  MPC.new([GMP::F(0), GMP::F( 4)])],
      ["0x1936D22F67C805p-45",  MPC.new([GMP::F(0), GMP::F( 6)])]
    ]
    data.each do |expected, input|
      actual = input.sin
      expect(actual.imag).to eq GMP::F.new(expected, 53, 16)
      expect(actual.real).to eq GMP::F(0)
    end
  end

  it 'calculates the sine of ieee-754 double precision numbers' do
    data = [
      [[514],                            ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDNN],
      [[514],                            ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDNZ],
      [[514],                            ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDNU],
      [[514],                            ["-0x8DBE5135A8CA9p-96",  53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDND],
      [["0x100FFFFFFFFFFFp-43", 53, 16], ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDZN],
      [["0x100FFFFFFFFFFFp-43", 53, 16], ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDZZ],
      [["0x100FFFFFFFFFFFp-43", 53, 16], ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDZU],
      [["0x100FFFFFFFFFFFp-43", 53, 16], ["-0x8DBE5135A8CA9p-96",  53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDZD],
      [[514],                            ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDUN],
      [[514],                            ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDUZ],
      [[514],                            ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDUU],
      [[514],                            ["-0x8DBE5135A8CA9p-96",  53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDUD],
      [["0x100FFFFFFFFFFFp-43", 53, 16], ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDDN],
      [["0x100FFFFFFFFFFFp-43", 53, 16], ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDDZ],
      [["0x100FFFFFFFFFFFp-43", 53, 16], ["-0x11B7CA26B51951p-97", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDDU],
      [["0x100FFFFFFFFFFFp-43", 53, 16], ["-0x8DBE5135A8CA9p-96",  53, 16], ["0x3243F6A8885A3p-49", 53, 16], ["-0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDDD]
    ]
    data.each do |expected_real, expected_imag, input_real, input_imag, rounding_mode|
      actual = MPC.new([GMP::F.new(*input_real), GMP::F.new(*input_imag)]).sin(rounding_mode)
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end
end
