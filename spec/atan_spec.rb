require File.join(File.dirname(__FILE__), 'spec_helper')

# All tests adapted from MPC 1.0.1's tests/atan.dat
describe MPC, '#atan' do
  it 'calculates the inverse tangent of a pure real argument' do
    data = [
      [["-0x16DCC57BB565FDp-52", 53, 16], [0], MPC.new([GMP::F(-7    ), -GMP::F(0)])],
      [["-0x1F730BD281F69Bp-53", 53, 16], [0], MPC.new([GMP::F(-1.5  ), -GMP::F(0)])],
      [["-0x1921FB54442D18p-53", 53, 16], [0], MPC.new([GMP::F(-1    ), -GMP::F(0)])],
      [["-0x1700A7C5784634p-53", 53, 16], [0], MPC.new([GMP::F(-0.875), -GMP::F(0)])],
      [["-0x1FD5BA9AAC2F6Ep-56", 53, 16], [0], MPC.new([GMP::F(-0.125), -GMP::F(0)])],
      [[ "0x1FD5BA9AAC2F6Ep-56", 53, 16], [0], MPC.new([GMP::F( 0.125), -GMP::F(0)])],
      [[ "0x1700A7C5784634p-53", 53, 16], [0], MPC.new([GMP::F( 0.875), -GMP::F(0)])],
      [[ "0x1921FB54442D18p-53", 53, 16], [0], MPC.new([GMP::F( 1    ), -GMP::F(0)])],
      [[ "0x1F730BD281F69Bp-53", 53, 16], [0], MPC.new([GMP::F( 1.5  ), -GMP::F(0)])],
      [[ "0x16DCC57BB565FDp-52", 53, 16], [0], MPC.new([GMP::F( 7    ), -GMP::F(0)])]
    ]
    data.each do |expected_real, expected_imag, input|
      actual = input.atan
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end

  it 'calculates the inverse tangent of a pure imaginary argument' do
    data = [
      [["-0x1921FB54442D18p-52", 53, 16], ["-0x1269621134DB92p-55", 53, 16], MPC.new([-GMP::F(0), GMP::F(-7    )])],
      [[ "0x1921FB54442D18p-52", 53, 16], ["-0x1269621134DB92p-55", 53, 16], MPC.new([ GMP::F(0), GMP::F(-7    )])],
      [["-0x1921FB54442D18p-52", 53, 16], ["-0x19C041F7ED8D33p-53", 53, 16], MPC.new([-GMP::F(0), GMP::F(-1.5  )])],
      [[ "0x1921FB54442D18p-52", 53, 16], ["-0x19C041F7ED8D33p-53", 53, 16], MPC.new([ GMP::F(0), GMP::F(-1.5  )])],
      [[0],                               ["-0x15AA16394D481Fp-52", 53, 16], MPC.new([-GMP::F(0), GMP::F(-0.875)])],
      [[0],                               ["-0x1015891C9EAEF7p-55", 53, 16], MPC.new([-GMP::F(0), GMP::F(-0.125)])],
      [[0],                               [ "0x1015891C9EAEF7p-55", 53, 16], MPC.new([-GMP::F(0), GMP::F( 0.125)])],
      [[0],                               [ "0x15AA16394D481Fp-52", 53, 16], MPC.new([-GMP::F(0), GMP::F( 0.875)])],
      [[ "0x1921FB54442D18p-52", 53, 16], [ "0x19C041F7ED8D33p-53", 53, 16], MPC.new([ GMP::F(0), GMP::F( 1.5  )])],
      [["-0x1921FB54442D18p-52", 53, 16], [ "0x19C041F7ED8D33p-53", 53, 16], MPC.new([-GMP::F(0), GMP::F( 1.5  )])],
      [[ "0x1921FB54442D18p-52", 53, 16], [ "0x1269621134DB92p-55", 53, 16], MPC.new([ GMP::F(0), GMP::F( 7    )])],
      [["-0x1921FB54442D18p-52", 53, 16], [ "0x1269621134DB92p-55", 53, 16], MPC.new([-GMP::F(0), GMP::F( 7    )])],
      [[0],                               [ "0x1FFFFFFFFFFF82p-52", 53, 16], MPC.new([ GMP::F(0), GMP::F("0x1ED9505E1BC3C2p-53", 53, 16)])]
    ]
    data.each do |expected_real, expected_imag, input|
      actual = input.atan
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end

  it 'calculates the inverse tangent of a pure imaginary argument, 512 precision' do
    input = MPC.new([
      GMP::F(0, 512),
      GMP::F("0x1018734E311AB77B710F9212969B3C86E8F388BB7DA5BAF74ADE078F43D96456D088C8A0B2A370159DFB8D4A4BC51BCDA91F2DCD01B2EC610C62AA33FAD1688p-504", 512, 16)
    ], 512)
    actual = input.atan(MPC::MPC_RNDNZ, 512, 512)
    expect(actual.real).to eq GMP::F.new("0x6487ED5110B4611A62633145C06E0E68948127044533E63A0105DF531D89CD9128A5043CC71A026EF7CA8CD9E69D218D98158536F92F8A1BA7F09AB6B6A8E123p-510", 512, 16)
    expect(actual.imag).to eq GMP::F.new("0x5D137113B914461DA3202D77346EE4980DA5FD0BAD68F5A7928DCA9F632750D9BFFA00654C523929F15DED554EC6BC476DB2C46FA433E569227085E0BDEA86FFp-509", 512, 16)
  end

  it 'calculates the inverse tangent of a pure imaginary argument, 12 precision' do
    input = MPC.new([
      GMP::F(0, 12),
      GMP::F("0x9380000000", 12, 16)
    ], 12)
    actual = input.atan
    expect(actual.real).to eq GMP::F.new("0xC91p-11", 12, 16)
    expect(actual.imag).to eq GMP::F.new("0x6F1p-50", 12, 16)
  end

  it 'calculates the inverse tangent of a general inputs' do
    data = [
      [["0x91EA521228BFC46ACAp-118", 72, 16], ["-0x9E96A01DBAD6470974p-73", 72, 16], ["0x84C3E02A5C6DEE8410p-118", 72, 16], ["-0x99B43C52A95A21C220p-73", 72, 16], MPC::MPC_RNDUN],
      [["0x91EA521228BFC46AC9p-118", 72, 16], ["-0x9E96A01DBAD6470974p-73", 72, 16], ["0x84C3E02A5C6DEE8410p-118", 72, 16], ["-0x99B43C52A95A21C220p-73", 72, 16], MPC::MPC_RNDDD],
      [["0x91EA521228BFC46AC9p-118", 72, 16], ["-0x9E96A01DBAD6470973p-73", 72, 16], ["0x84C3E02A5C6DEE8410p-118", 72, 16], ["-0x99B43C52A95A21C220p-73", 72, 16], MPC::MPC_RNDDU],
      [["0x91EA521228BFC46ACAp-118", 72, 16], [ "0x9E96A01DBAD6470974p-73", 72, 16], ["0x84C3E02A5C6DEE8410p-118", 72, 16], [ "0x99B43C52A95A21C220p-73", 72, 16], MPC::MPC_RNDUN],
      [["0x91EA521228BFC46AC9p-118", 72, 16], [ "0x9E96A01DBAD6470974p-73", 72, 16], ["0x84C3E02A5C6DEE8410p-118", 72, 16], [ "0x99B43C52A95A21C220p-73", 72, 16], MPC::MPC_RNDDU],
      [["0x91EA521228BFC46AC9p-118", 72, 16], [ "0x9E96A01DBAD6470973p-73", 72, 16], ["0x84C3E02A5C6DEE8410p-118", 72, 16], [ "0x99B43C52A95A21C220p-73", 72, 16], MPC::MPC_RNDDD],
    ]
    data.each do |expected_real, expected_imag, input_real, input_imag, rounding_mode|
      actual = MPC.new([GMP::F(*input_real), GMP::F(*input_imag)], 72).atan(rounding_mode)
      expect(actual.real).to eq GMP::F.new(*expected_real)
      expect(actual.imag).to eq GMP::F.new(*expected_imag)
    end
  end

  it 'calculates the inverse tangent of a general inputs, 156 precision' do
    input = MPC.new([
      GMP::F("-0xF0CE58073F866A53F25DB85DE8D503FBDD81051p-109", 156, 16),
      GMP::F( "0xCF81D7C76BB9754A52056CB0F144B0C6700CC8Cp-128", 156, 16)
    ], 156)
    actual = input.atan
    expect(actual.real).to eq GMP::F.new("-0xC90FDAA22167B20DB08A0C3B1FF415CABE49624p-155", 156, 16)
    expect(actual.imag).to eq GMP::F.new("0xEA84E971BD52E49CCEE036E303D5ECB2D9D9B9Ap-222", 156, 16)
  end

  it 'calculates the inverse tangent of a general inputs, 2 precision' do
    actual = MPC.new([GMP::F("0x1p-7", 2, 16), GMP::F(-1, 2, 16)], 2).atan
    expect(actual.real).to eq GMP::F.new( 0.75, 2, 16)
    expect(actual.imag).to eq GMP::F.new(-3,    2, 16)

    actual = MPC.new([GMP::F("0x1p-7", 2, 16), GMP::F(1, 2, 16)], 2).atan
    expect(actual.real).to eq GMP::F.new( 0.75, 2, 16)
    expect(actual.imag).to eq GMP::F.new( 3,    2, 16)
  end

  it 'calculates the inverse tangent: "improve test coverage"' do
    actual = MPC.new([GMP::F("-0xa.529626a89a1960@23", 57, 16), GMP::F("-0x3.9a5472b5709e74@14", 57, 16)], 57).atan
    expect(actual.real).to eq GMP::F.new("-0x1.921fb54442d184", 57, 16)
    expect(actual.imag).to eq GMP::F.new("-0x8.a7e33db93ecf18@-34", 57, 16)
  end
end
