require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC::Rnd, '#mode' do
  it 'returns MPC::MPC_RNDNN.mode correctly' do
    expect(MPC::MPC_RNDNN.mode).to eq 0
  end

  it 'returns MPC::MPC_RNDZN.mode correctly' do
    expect(MPC::MPC_RNDZN.mode).to eq 1
  end

  it 'returns MPC::MPC_RNDUN.mode correctly' do
    expect(MPC::MPC_RNDUN.mode).to eq 2
  end

  it 'returns MPC::MPC_RNDDN.mode correctly' do
    expect(MPC::MPC_RNDDN.mode).to eq 3
  end

  it 'returns MPC::MPC_RNDNZ.mode correctly' do
    expect(MPC::MPC_RNDNZ.mode).to eq 16
  end

  it 'returns MPC::MPC_RNDZZ.mode correctly' do
    expect(MPC::MPC_RNDZZ.mode).to eq 17
  end

  it 'returns MPC::MPC_RNDUZ.mode correctly' do
    expect(MPC::MPC_RNDUZ.mode).to eq 18
  end

  it 'returns MPC::MPC_RNDDZ.mode correctly' do
    expect(MPC::MPC_RNDDZ.mode).to eq 19
  end

  it 'returns MPC::MPC_RNDNU.mode correctly' do
    expect(MPC::MPC_RNDNU.mode).to eq 32
  end

  it 'returns MPC::MPC_RNDNU.mode correctly' do
    expect(MPC::MPC_RNDZU.mode).to eq 33
  end

  it 'returns MPC::MPC_RNDNU.mode correctly' do
    expect(MPC::MPC_RNDUU.mode).to eq 34
  end

  it 'returns MPC::MPC_RNDNU.mode correctly' do
    expect(MPC::MPC_RNDDU.mode).to eq 35
  end

  it 'returns MPC::MPC_RNDND.mode correctly' do
    expect(MPC::MPC_RNDND.mode).to eq 48
  end

  it 'returns MPC::MPC_RNDND.mode correctly' do
    expect(MPC::MPC_RNDZD.mode).to eq 49
  end

  it 'returns MPC::MPC_RNDND.mode correctly' do
    expect(MPC::MPC_RNDUD.mode).to eq 50
  end

  it 'returns MPC::MPC_RNDND.mode correctly' do
    expect(MPC::MPC_RNDDD.mode).to eq 51
  end
end

describe MPC::Rnd, '#name' do
  it 'returns MPC::MPC_RNDNN.name correctly' do
    expect(MPC::MPC_RNDNN.name).to eq 'MPC_RNDNN'
  end

  it 'returns MPC::MPC_RNDZN.name correctly' do
    expect(MPC::MPC_RNDZN.name).to eq 'MPC_RNDZN'
  end

  it 'returns MPC::MPC_RNDUN.name correctly' do
    expect(MPC::MPC_RNDUN.name).to eq 'MPC_RNDUN'
  end

  it 'returns MPC::MPC_RNDDN.name correctly' do
    expect(MPC::MPC_RNDDN.name).to eq 'MPC_RNDDN'
  end

  it 'returns MPC::MPC_RNDNZ.name correctly' do
    expect(MPC::MPC_RNDNZ.name).to eq 'MPC_RNDNZ'
  end

  it 'returns MPC::MPC_RNDZZ.name correctly' do
    expect(MPC::MPC_RNDZZ.name).to eq 'MPC_RNDZZ'
  end

  it 'returns MPC::MPC_RNDUZ.name correctly' do
    expect(MPC::MPC_RNDUZ.name).to eq 'MPC_RNDUZ'
  end

  it 'returns MPC::MPC_RNDDZ.name correctly' do
    expect(MPC::MPC_RNDDZ.name).to eq 'MPC_RNDDZ'
  end

  it 'returns MPC::MPC_RNDNU.name correctly' do
    expect(MPC::MPC_RNDNU.name).to eq 'MPC_RNDNU'
  end

  it 'returns MPC::MPC_RNDZU.name correctly' do
    expect(MPC::MPC_RNDZU.name).to eq 'MPC_RNDZU'
  end

  it 'returns MPC::MPC_RNDUU.name correctly' do
    expect(MPC::MPC_RNDUU.name).to eq 'MPC_RNDUU'
  end

  it 'returns MPC::MPC_RNDDU.name correctly' do
    expect(MPC::MPC_RNDDU.name).to eq 'MPC_RNDDU'
  end

  it 'returns MPC::MPC_RNDND.name correctly' do
    expect(MPC::MPC_RNDND.name).to eq 'MPC_RNDND'
  end

  it 'returns MPC::MPC_RNDZD.name correctly' do
    expect(MPC::MPC_RNDZD.name).to eq 'MPC_RNDZD'
  end

  it 'returns MPC::MPC_RNDUD.name correctly' do
    expect(MPC::MPC_RNDUD.name).to eq 'MPC_RNDUD'
  end

  it 'returns MPC::MPC_RNDDD.name correctly' do
    expect(MPC::MPC_RNDDD.name).to eq 'MPC_RNDDD'
  end
end

describe MPC::Rnd, '#ieee754' do
  it 'returns MPC::MPC_RNDNN.ieee754 correctly' do
    expect(MPC::MPC_RNDNN.ieee754).to eq '(roundTiesToEven,roundTiesToEven)'
  end

  it 'returns MPC::MPC_RNDZN.ieee754 correctly' do
    expect(MPC::MPC_RNDZN.ieee754).to eq '(roundTowardZero,roundTiesToEven)'
  end

  it 'returns MPC::MPC_RNDUN.ieee754 correctly' do
    expect(MPC::MPC_RNDUN.ieee754).to eq '(roundTowardPositive,roundTiesToEven)'
  end

  it 'returns MPC::MPC_RNDDN.ieee754 correctly' do
    expect(MPC::MPC_RNDDN.ieee754).to eq '(roundTowardNegative,roundTiesToEven)'
  end

  it 'returns MPC::MPC_RNDNZ.ieee754 correctly' do
    expect(MPC::MPC_RNDNZ.ieee754).to eq '(roundTiesToEven,roundTowardZero)'
  end

  it 'returns MPC::MPC_RNDZZ.ieee754 correctly' do
    expect(MPC::MPC_RNDZZ.ieee754).to eq '(roundTowardZero,roundTowardZero)'
  end

  it 'returns MPC::MPC_RNDUZ.ieee754 correctly' do
    expect(MPC::MPC_RNDUZ.ieee754).to eq '(roundTowardPositive,roundTowardZero)'
  end

  it 'returns MPC::MPC_RNDDZ.ieee754 correctly' do
    expect(MPC::MPC_RNDDZ.ieee754).to eq '(roundTowardNegative,roundTowardZero)'
  end

  it 'should return MPC::MPC_RNDNU.ieee754 correctly' do
    expect(MPC::MPC_RNDNU.ieee754).to eq '(roundTiesToEven,roundTowardPositive)'
  end

  it 'should return MPC::MPC_RNDZU.ieee754 correctly' do
    expect(MPC::MPC_RNDZU.ieee754).to eq '(roundTowardZero,roundTowardPositive)'
  end

  it 'should return MPC::MPC_RNDUU.ieee754 correctly' do
    expect(MPC::MPC_RNDUU.ieee754).to eq '(roundTowardPositive,roundTowardPositive)'
  end

  it 'returns MPC::MPC_RNDDU.ieee754 correctly' do
    expect(MPC::MPC_RNDDU.ieee754).to eq '(roundTowardNegative,roundTowardPositive)'
  end

  it 'returns MPC::MPC_RNDND.ieee754 correctly' do
    expect(MPC::MPC_RNDND.ieee754).to eq '(roundTiesToEven,roundTowardNegative)'
  end

  it 'returns MPC::MPC_RNDZD.ieee754 correctly' do
    expect(MPC::MPC_RNDZD.ieee754).to eq '(roundTowardZero,roundTowardNegative)'
  end

  it 'returns MPC::MPC_RNDUD.ieee754 correctly' do
    expect(MPC::MPC_RNDUD.ieee754).to eq '(roundTowardPositive,roundTowardNegative)'
  end

  it 'returns MPC::MPC_RNDDD.ieee754 correctly' do
    expect(MPC::MPC_RNDDD.ieee754).to eq '(roundTowardNegative,roundTowardNegative)'
  end
end
