require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/sinh.dat
describe MPC, '#sinh' do
  it 'should calculate the hyperbolic sine of a pure real argument' do
    data = [
      ["-0x12cd9fc44eb98p-48",   MPC.new([GMP::F(-1, 7), GMP::F(0, 7)])],
      [ "0x12cd9fc44eb98p-48",   MPC.new([GMP::F( 1, 7), GMP::F(0, 7)])]
    ]
    data.each do |expected, input|
      actual = input.sinh(MPC::MPC_RNDNN, 50, 50)
      actual.real.should eq GMP::F.new(expected, 50, 16)
      actual.imag.should eq GMP::F(0)
    end
  end

  it 'should calculate the hyperbolic sine of a pure real argument, using hash arguments' do
    data = [
      ["-0x12cd9fc44eb98p-48",   MPC.new([GMP::F(-1, 7), GMP::F(0, 7)])],
      [ "0x12cd9fc44eb98p-48",   MPC.new([GMP::F( 1, 7), GMP::F(0, 7)])]
    ]
    data.each do |expected, input|
      actual = input.sinh(:rounding_mode => MPC::MPC_RNDNN, :precision => 50)
      actual.real.should eq GMP::F.new(expected, 50, 16)
      actual.imag.should eq GMP::F(0)
    end
  end

  it 'should calculate the hyperbolic sine of a pure imaginary argument' do
    data = [
      ["-0xd76aa47848678p-52",   MPC.new([GMP::F(0, 7), GMP::F(-1, 7)])],
      [ "0xd76aa47848678p-52",   MPC.new([GMP::F(0, 7), GMP::F( 1, 7)])]
    ]
    data.each do |expected, input|
      actual = input.sinh(MPC::MPC_RNDNN, 50, 50)
      actual.real.should eq GMP::F(0)
      actual.imag.should eq GMP::F.new(expected, 50, 16)
    end
  end

  it 'should calculate the hyperbolic sine of an argument with +1 and -1' do
    data = [
      ["-0xa28cfec023fc8p-52", "-0x14c67b74f6cc5p-48",  MPC.new([GMP::F(-1, 7), GMP::F(-1, 7)])],
      ["-0xa28cfec023fc8p-52",  "0x14c67b74f6cc5p-48",  MPC.new([GMP::F(-1, 7), GMP::F( 1, 7)])],
      [ "0xa28cfec023fc8p-52", "-0x14c67b74f6cc5p-48",  MPC.new([GMP::F( 1, 7), GMP::F(-1, 7)])],
      [ "0xa28cfec023fc8p-52",  "0x14c67b74f6cc5p-48",  MPC.new([GMP::F( 1, 7), GMP::F( 1, 7)])],
    ]
    data.each do |expected_real, expected_imag, input|
      actual = input.sinh(MPC::MPC_RNDNN, 50, 50)
      actual.real.should eq GMP::F.new(expected_real, 50, 16)
      actual.imag.should eq GMP::F.new(expected_imag, 50, 16)
    end
  end

  it 'should calculate the hyperbolic sine of ieee-754 double precision numbers' do
    data = [
      [["0xF48D4FDF29C53p-105", 53, 16], [2], ["0x15124271980435p-52", 53, 16], ["0x3243F6A8885A3p-49", 53, 16], MPC::MPC_RNDNN],
    ]
    data.each do |expected_real, expected_imag, input_real, input_imag, rounding_mode|
      actual = MPC.new([GMP::F.new(*input_real), GMP::F.new(*input_imag)]).sinh(rounding_mode)
      actual.real.should eq GMP::F.new(*expected_real)
      actual.imag.should eq GMP::F.new(*expected_imag)
    end
  end
end
