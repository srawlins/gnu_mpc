require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/asin.dat
describe MPC, '#sin' do
  it 'calculates the inverse sine of a pure real argument' do
    data = [
      [["-0x1921FB54442D18p-52", 53, 16], ["-0x1ECC2CAEC5160Ap-53", 53, 16], MPC.new([GMP::F(-1.5), -GMP::F(0)])],
      [["-0x1921FB54442D18p-52", 53, 16], [ "0x1ECC2CAEC5160Ap-53", 53, 16], MPC.new([GMP::F(-1.5),  GMP::F(0)])],
      [["-0x1921FB54442D18p-52", 53, 16], [0],                               MPC.new([GMP::F(-1  ), -GMP::F(0)])],
      [["-0x1921FB54442D18p-52", 53, 16], [0],                               MPC.new([GMP::F(-1  ),  GMP::F(0)])],
      [["-0x10C152382D7366p-53", 53, 16], [0],                               MPC.new([GMP::F(-0.5), -GMP::F(0)])],
      [["-0x10C152382D7366p-53", 53, 16], [0],                               MPC.new([GMP::F(-0.5),  GMP::F(0)])],
      [[ "0x10C152382D7366p-53", 53, 16], [0],                               MPC.new([GMP::F( 0.5), -GMP::F(0)])],
      [[ "0x10C152382D7366p-53", 53, 16], [0],                               MPC.new([GMP::F( 0.5),  GMP::F(0)])],
      [[ "0x1921FB54442D18p-52", 53, 16], [0],                               MPC.new([GMP::F( 1  ), -GMP::F(0)])],
      [[ "0x1921FB54442D18p-52", 53, 16], [0],                               MPC.new([GMP::F( 1  ),  GMP::F(0)])],
      [[ "0x1921FB54442D18p-52", 53, 16], ["-0x1ECC2CAEC5160Ap-53", 53, 16], MPC.new([GMP::F( 1.5), -GMP::F(0)])],
      [[ "0x1921FB54442D18p-52", 53, 16], [ "0x1ECC2CAEC5160Ap-53", 53, 16], MPC.new([GMP::F( 1.5),  GMP::F(0)])]
    ]
    data.each do |expected_real, expected_imag, input|
      actual = input.asin
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end

  it 'calculates the inverse sine of a pure imaginary argument' do
    data = [
      [[-GMP::F(0)], ["-0x131DC0090B63D8p-52", 53, 16], MPC.new([-GMP::F(0), GMP::F(-1.5)])],
      [[ GMP::F(0)], ["-0x131DC0090B63D8p-52", 53, 16], MPC.new([ GMP::F(0), GMP::F(-1.5)])],
      [[-GMP::F(0)], ["-0x1C34366179D427p-53", 53, 16], MPC.new([-GMP::F(0), GMP::F(-1  )])],
      [[ GMP::F(0)], ["-0x1C34366179D427p-53", 53, 16], MPC.new([ GMP::F(0), GMP::F(-1  )])],
      [[-GMP::F(0)], ["-0x1ECC2CAEC5160Ap-54", 53, 16], MPC.new([-GMP::F(0), GMP::F(-0.5)])],
      [[ GMP::F(0)], ["-0x1ECC2CAEC5160Ap-54", 53, 16], MPC.new([ GMP::F(0), GMP::F(-0.5)])],
      [[-GMP::F(0)], [ "0x1ECC2CAEC5160Ap-54", 53, 16], MPC.new([-GMP::F(0), GMP::F( 0.5)])],
      [[ GMP::F(0)], [ "0x1ECC2CAEC5160Ap-54", 53, 16], MPC.new([ GMP::F(0), GMP::F( 0.5)])],
      [[-GMP::F(0)], [ "0x1C34366179D427p-53", 53, 16], MPC.new([-GMP::F(0), GMP::F( 1  )])],
      [[ GMP::F(0)], [ "0x1C34366179D427p-53", 53, 16], MPC.new([ GMP::F(0), GMP::F( 1  )])],
      [[-GMP::F(0)], [ "0x131DC0090B63D8p-52", 53, 16], MPC.new([-GMP::F(0), GMP::F( 1.5)])],
      [[ GMP::F(0)], [ "0x131DC0090B63D8p-52", 53, 16], MPC.new([ GMP::F(0), GMP::F( 1.5)])]
    ]
    data.each do |expected_real, expected_imag, input|
      actual = input.asin
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end

  it 'should calculate the inverse sine of ieee-754 double precision numbers' do
    actual = MPC.new([GMP::F.new(17), GMP::F.new(42)]).asin(MPC::MPC_RNDNN)
    expect(actual.real).to eq GMP::F.new("0x189BF9EC7FCD5Bp-54", 53, 16)
    expect(actual.imag).to eq GMP::F.new("0x1206ECFA94614Bp-50", 53, 16)
  end

  it 'should calculate the inverse sine with other precisions' do
    actual = MPC.new([GMP::F.new(96), GMP::F.new("0x1p-8", 2, 16)]).asin(MPC::MPC_RNDNN, 2)
    expect(actual.real).to eq GMP::F.new(1.5, 2)
    expect(actual.imag).to eq GMP::F.new(6,   2)
  end

  it 'should calculate the inverse sine with other precisions' do
    actual = MPC.new([GMP::F.new(96), GMP::F.new("0x1p-8", 2, 16)]).asin(MPC::MPC_RNDNN, 8)
    expect(actual.real).to eq GMP::F.new("0xC9p-7", 8, 16)
    expect(actual.imag).to eq GMP::F.new("0x15p-2", 8, 16)
  end
end
