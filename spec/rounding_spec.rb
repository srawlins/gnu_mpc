require File.join(File.dirname(__FILE__), 'spec_helper')

describe MPC::Rnd, '#mode' do
  it 'should return MPC::MPC_RNDNN.mode correctly' do
    MPC::MPC_RNDNN.mode.should eq 0
  end

  it 'should return MPC::MPC_RNDZN.mode correctly' do
    MPC::MPC_RNDZN.mode.should eq 1
  end

  it 'should return MPC::MPC_RNDUN.mode correctly' do
    MPC::MPC_RNDUN.mode.should eq 2
  end

  it 'should return MPC::MPC_RNDDN.mode correctly' do
    MPC::MPC_RNDDN.mode.should eq 3
  end

  it 'should return MPC::MPC_RNDNZ.mode correctly' do
    MPC::MPC_RNDNZ.mode.should eq 16
  end

  it 'should return MPC::MPC_RNDZZ.mode correctly' do
    MPC::MPC_RNDZZ.mode.should eq 17
  end

  it 'should return MPC::MPC_RNDUZ.mode correctly' do
    MPC::MPC_RNDUZ.mode.should eq 18
  end

  it 'should return MPC::MPC_RNDDZ.mode correctly' do
    MPC::MPC_RNDDZ.mode.should eq 19
  end

  it 'should return MPC::MPC_RNDNU.mode correctly' do
    MPC::MPC_RNDNU.mode.should eq 32
  end

  it 'should return MPC::MPC_RNDNU.mode correctly' do
    MPC::MPC_RNDZU.mode.should eq 33
  end

  it 'should return MPC::MPC_RNDNU.mode correctly' do
    MPC::MPC_RNDUU.mode.should eq 34
  end

  it 'should return MPC::MPC_RNDNU.mode correctly' do
    MPC::MPC_RNDDU.mode.should eq 35
  end

  it 'should return MPC::MPC_RNDND.mode correctly' do
    MPC::MPC_RNDND.mode.should eq 48
  end

  it 'should return MPC::MPC_RNDND.mode correctly' do
    MPC::MPC_RNDZD.mode.should eq 49
  end

  it 'should return MPC::MPC_RNDND.mode correctly' do
    MPC::MPC_RNDUD.mode.should eq 50
  end

  it 'should return MPC::MPC_RNDND.mode correctly' do
    MPC::MPC_RNDDD.mode.should eq 51
  end
end

describe MPC::Rnd, '#name' do
  it 'should return MPC::MPC_RNDNN.name correctly' do
    MPC::MPC_RNDNN.name.should eq 'MPC_RNDNN'
  end

  it 'should return MPC::MPC_RNDZN.name correctly' do
    MPC::MPC_RNDZN.name.should eq 'MPC_RNDZN'
  end

  it 'should return MPC::MPC_RNDUN.name correctly' do
    MPC::MPC_RNDUN.name.should eq 'MPC_RNDUN'
  end

  it 'should return MPC::MPC_RNDDN.name correctly' do
    MPC::MPC_RNDDN.name.should eq 'MPC_RNDDN'
  end

  it 'should return MPC::MPC_RNDNZ.name correctly' do
    MPC::MPC_RNDNZ.name.should eq 'MPC_RNDNZ'
  end

  it 'should return MPC::MPC_RNDZZ.name correctly' do
    MPC::MPC_RNDZZ.name.should eq 'MPC_RNDZZ'
  end

  it 'should return MPC::MPC_RNDUZ.name correctly' do
    MPC::MPC_RNDUZ.name.should eq 'MPC_RNDUZ'
  end

  it 'should return MPC::MPC_RNDDZ.name correctly' do
    MPC::MPC_RNDDZ.name.should eq 'MPC_RNDDZ'
  end

  it 'should return MPC::MPC_RNDNU.name correctly' do
    MPC::MPC_RNDNU.name.should eq 'MPC_RNDNU'
  end

  it 'should return MPC::MPC_RNDZU.name correctly' do
    MPC::MPC_RNDZU.name.should eq 'MPC_RNDZU'
  end

  it 'should return MPC::MPC_RNDUU.name correctly' do
    MPC::MPC_RNDUU.name.should eq 'MPC_RNDUU'
  end

  it 'should return MPC::MPC_RNDDU.name correctly' do
    MPC::MPC_RNDDU.name.should eq 'MPC_RNDDU'
  end

  it 'should return MPC::MPC_RNDND.name correctly' do
    MPC::MPC_RNDND.name.should eq 'MPC_RNDND'
  end

  it 'should return MPC::MPC_RNDZD.name correctly' do
    MPC::MPC_RNDZD.name.should eq 'MPC_RNDZD'
  end

  it 'should return MPC::MPC_RNDUD.name correctly' do
    MPC::MPC_RNDUD.name.should eq 'MPC_RNDUD'
  end

  it 'should return MPC::MPC_RNDDD.name correctly' do
    MPC::MPC_RNDDD.name.should eq 'MPC_RNDDD'
  end
end

describe MPC::Rnd, '#ieee754' do
  it 'should return MPC::MPC_RNDNN.ieee754 correctly' do
    MPC::MPC_RNDNN.ieee754.should eq '(roundTiesToEven,roundTiesToEven)'
  end

  it 'should return MPC::MPC_RNDZN.ieee754 correctly' do
    MPC::MPC_RNDZN.ieee754.should eq '(roundTowardZero,roundTiesToEven)'
  end

  it 'should return MPC::MPC_RNDUN.ieee754 correctly' do
    MPC::MPC_RNDUN.ieee754.should eq '(roundTowardPositive,roundTiesToEven)'
  end

  it 'should return MPC::MPC_RNDDN.ieee754 correctly' do
    MPC::MPC_RNDDN.ieee754.should eq '(roundTowardNegative,roundTiesToEven)'
  end

  it 'should return MPC::MPC_RNDNZ.ieee754 correctly' do
    MPC::MPC_RNDNZ.ieee754.should eq '(roundTiesToEven,roundTowardZero)'
  end

  it 'should return MPC::MPC_RNDZZ.ieee754 correctly' do
    MPC::MPC_RNDZZ.ieee754.should eq '(roundTowardZero,roundTowardZero)'
  end

  it 'should return MPC::MPC_RNDUZ.ieee754 correctly' do
    MPC::MPC_RNDUZ.ieee754.should eq '(roundTowardPositive,roundTowardZero)'
  end

  it 'should return MPC::MPC_RNDDZ.ieee754 correctly' do
    MPC::MPC_RNDDZ.ieee754.should eq '(roundTowardNegative,roundTowardZero)'
  end

  it 'should return MPC::MPC_RNDNU.ieee754 correctly' do
    MPC::MPC_RNDNU.ieee754.should eq '(roundTiesToEven,roundTowardPositive)'
  end

  it 'should return MPC::MPC_RNDZU.ieee754 correctly' do
    MPC::MPC_RNDZU.ieee754.should eq '(roundTowardZero,roundTowardPositive)'
  end

  it 'should return MPC::MPC_RNDUU.ieee754 correctly' do
    MPC::MPC_RNDUU.ieee754.should eq '(roundTowardPositive,roundTowardPositive)'
  end

  it 'should return MPC::MPC_RNDDU.ieee754 correctly' do
    MPC::MPC_RNDDU.ieee754.should eq '(roundTowardNegative,roundTowardPositive)'
  end

  it 'should return MPC::MPC_RNDND.ieee754 correctly' do
    MPC::MPC_RNDND.ieee754.should eq '(roundTiesToEven,roundTowardNegative)'
  end

  it 'should return MPC::MPC_RNDZD.ieee754 correctly' do
    MPC::MPC_RNDZD.ieee754.should eq '(roundTowardZero,roundTowardNegative)'
  end

  it 'should return MPC::MPC_RNDUD.ieee754 correctly' do
    MPC::MPC_RNDUD.ieee754.should eq '(roundTowardPositive,roundTowardNegative)'
  end

  it 'should return MPC::MPC_RNDDD.ieee754 correctly' do
    MPC::MPC_RNDDD.ieee754.should eq '(roundTowardNegative,roundTowardNegative)'
  end
end
