require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/cos.dat
describe MPC, '#cos' do
  it 'calculates the cosine of a pure real argument' do
    data = [
      ["0x8a51407da8344p-52",   MPC.new([GMP::F(-1, 7), GMP::F(0, 7)])],
      ["0x8a51407da8344p-52",   MPC.new([GMP::F( 1, 7), GMP::F(0, 7)])]
    ]
    data.each do |expected, input|
      actual = input.cos(MPC::MPC_RNDNN, 50, 50)
      expect(actual.real).to eq GMP::F.new(expected, 50, 16)
      expect(actual.imag).to eq GMP::F(0)
    end
  end

  it 'calculates the cosine of a pure imaginary argument' do
    data = [
      ["0x18b07551d9f55p-48",   MPC.new([GMP::F(0, 7), GMP::F(-1, 7)])],
      ["0x18b07551d9f55p-48",   MPC.new([GMP::F(0, 7), GMP::F( 1, 7)])]
    ]
    data.each do |expected, input|
      actual = input.cos(MPC::MPC_RNDNN, 50, 50)
      expect(actual.real).to eq GMP::F.new(expected, 50, 16)
      expect(actual.imag).to eq GMP::F(0)
    end
  end

  it 'calculates the cosine of an argument with +1 and -1' do
    data = [
      ["0xd56f54b7a1accp-52", "-0xfd28666957478p-52",  MPC.new([GMP::F(-1, 7), GMP::F(-1, 7)])],
      ["0xd56f54b7a1accp-52",  "0xfd28666957478p-52",  MPC.new([GMP::F(-1, 7), GMP::F( 1, 7)])],
      ["0xd56f54b7a1accp-52",  "0xfd28666957478p-52",  MPC.new([GMP::F( 1, 7), GMP::F(-1, 7)])],
      ["0xd56f54b7a1accp-52", "-0xfd28666957478p-52",  MPC.new([GMP::F( 1, 7), GMP::F( 1, 7)])]
    ]
    data.each do |expected_real, expected_imag, input|
      actual = input.cos(MPC::MPC_RNDNN, 50, 50)
      expect(actual.real).to eq GMP::F.new(expected_real, 50, 16)
      expect(actual.imag).to eq GMP::F.new(expected_imag, 50, 16)
    end
  end

  it 'calculates the cosine of ieee-754 double precision numbers' do
    data = [
      [[514],                            [0], [0], ["0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDNN],
      [["0x100FFFFFFFFFFFp-43", 53, 16], [0], [0], ["0x1BBDD1808C59A3p-50", 53, 16], MPC::MPC_RNDDD],
    ]
    data.each do |expected_real, expected_imag, input_real, input_imag, rounding_mode|
      actual = MPC.new([GMP::F.new(*input_real), GMP::F.new(*input_imag)]).cos(rounding_mode)
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end
end
