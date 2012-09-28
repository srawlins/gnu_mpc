require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/acos.dat
describe MPC, '#acos' do
  it 'should calculate the inverse cosine of a pure real argument' do
    data = [
      [[ "0x1921FB54442D18p-51", 53, 16], [ "0x13D2B7539DBA4Cp-51", 53, 16], MPC.new([GMP::F(-6  ), -GMP::F(0)])],
      [[ "0x1921FB54442D18p-51", 53, 16], ["-0x13D2B7539DBA4Cp-51", 53, 16], MPC.new([GMP::F(-6  ),  GMP::F(0)])],
      [[ "0x1921FB54442D18p-51", 53, 16], [ "0x15124271980435p-52", 53, 16], MPC.new([GMP::F(-2  ), -GMP::F(0)])],
      [[ "0x1921FB54442D18p-51", 53, 16], ["-0x15124271980435p-52", 53, 16], MPC.new([GMP::F(-2  ),  GMP::F(0)])],
      [[ "0x1921FB54442D18p-51", 53, 16], [0],                               MPC.new([GMP::F(-1  ), -GMP::F(0)])],
      [[ "0x1921FB54442D18p-51", 53, 16], [0],                               MPC.new([GMP::F(-1  ),  GMP::F(0)])],
      [[ "0x10C152382D7366p-51", 53, 16], [0],                               MPC.new([GMP::F(-0.5), -GMP::F(0)])],
      [[ "0x10C152382D7366p-51", 53, 16], [0],                               MPC.new([GMP::F(-0.5),  GMP::F(0)])],
      [[ "0x10C152382D7366p-52", 53, 16], [0],                               MPC.new([GMP::F( 0.5),  GMP::F(0)])],
      [[ "0x10C152382D7366p-52", 53, 16], [0],                               MPC.new([GMP::F( 0.5), -GMP::F(0)])],
      [[0],                               [0],                               MPC.new([GMP::F( 1  ),  GMP::F(0)])],
      [[0],                               [0],                               MPC.new([GMP::F( 1  ), -GMP::F(0)])],
      [[0],                               ["-0x15124271980435p-52", 53, 16], MPC.new([GMP::F( 2  ),  GMP::F(0)])],
      [[0],                               [ "0x15124271980435p-52", 53, 16], MPC.new([GMP::F( 2  ), -GMP::F(0)])],
      [[0],                               ["-0x13D2B7539DBA4Cp-51", 53, 16], MPC.new([GMP::F( 6  ),  GMP::F(0)])],
      [[0],                               [ "0x13D2B7539DBA4Cp-51", 53, 16], MPC.new([GMP::F( 6  ), -GMP::F(0)])]
    ]
    data.each do |expected_real, expected_imag, input|
      actual = input.acos
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end

  it 'should calculate the inverse cosine of a pure imaginary argument' do
    data = [
      [["0x1921FB54442D18p-52", 53, 16], [ "0x1D185B507EDC0Ep-52", 53, 16], MPC.new([-GMP::F(0), GMP::F(-3   )])],
      [["0x1921FB54442D18p-52", 53, 16], [ "0x1D185B507EDC0Ep-52", 53, 16], MPC.new([ GMP::F(0), GMP::F(-3   )])],
      [["0x1921FB54442D18p-52", 53, 16], [ "0x1FACFB2399E637p-55", 53, 16], MPC.new([-GMP::F(0), GMP::F(-0.25)])],
      [["0x1921FB54442D18p-52", 53, 16], [ "0x1FACFB2399E637p-55", 53, 16], MPC.new([ GMP::F(0), GMP::F(-0.25)])],
      [["0x1921FB54442D18p-52", 53, 16], ["-0x1FACFB2399E637p-55", 53, 16], MPC.new([-GMP::F(0), GMP::F( 0.25)])],
      [["0x1921FB54442D18p-52", 53, 16], ["-0x1FACFB2399E637p-55", 53, 16], MPC.new([ GMP::F(0), GMP::F( 0.25)])],
      [["0x1921FB54442D18p-52", 53, 16], ["-0x1D185B507EDC0Ep-52", 53, 16], MPC.new([-GMP::F(0), GMP::F( 3   )])],
      [["0x1921FB54442D18p-52", 53, 16], ["-0x1D185B507EDC0Ep-52", 53, 16], MPC.new([ GMP::F(0), GMP::F( 3   )])],
    ]
    data.each do |expected_real, expected_imag, input|
      actual = input.acos
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end

  it 'should calculate the inverse cosine with other precisions' do
    actual = MPC.new([GMP::F.new(2), GMP::F.new(1)]).acos(MPC::MPC_RNDNZ, 2)
    actual.real.should eq GMP::F.new( 0.5, 2)
    actual.imag.should eq GMP::F.new(-1,   2)
  end

  it 'should calculate the inverse cosine with other precisions' do
    actual = MPC.new([GMP::F.new(8.5), GMP::F.new(-71)]).acos(MPC::MPC_RNDNU, 9)
    actual.real.should eq GMP::F.new("0x5Dp-6", 9, 16)
    actual.imag.should eq GMP::F.new("0x9Fp-5", 9, 16)
  end

  it 'should calculate the inverse cosine with other precisions' do
    actual = MPC.new([GMP::F.new("0x3243F6A8885A3p-48", 53, 16), GMP::F.new("0x162E42FEFA39EFp-53", 53, 16)]).acos
    actual.real.should eq GMP::F.new("0x74C141310E695p-53", 53, 16)
    actual.imag.should eq GMP::F.new("-0x1D6D2CFA9F3F11p-52", 53, 16)
  end
end
