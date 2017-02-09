# 費用対効果の高いテストを設計する

# 変更可能なコードを書くことを実践するために必要な3つの要素
# オブジェクト指向設計の理解


# コードのリファクタリングに長けていること
# 外部の振る舞いを保ったままで、内部の構造を改善していく作業

# 価値の高いテストを書く能力
# 自信をもってリファクタリングを継続的にできる
# コードの変更によってテストの書き直しを強制されない


# テストを行う根拠として、よくある目的
# バグを減らす、文書になる、より設計がいいものになる

# 真の目的は「コストを減らすこと」

# テストの意図
# バグを見つける
# 仕様書となる
# 設計の決定を遅らせる
# 抽象を支える
# 設計の欠陥を明らかにする


# 受信メッセージをテストする

class Wheel
  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def width
    rim + (tire * 2)
  end
end

class Gear
  attr_reader :chainring, :cog, :wheel, :observer

  def initialize(args)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @wheel = args[:wheel]
    @observer = args[:observer]
  end

  def gear_inches
    ratio * wheel.diameter
  end

  def ratio
    chainring / cog.to_f
  end

  def set_cog(new_cog)
    @cog = new_cog
    changed
  end

  def set_chainring(new_chainring)
    @chainring = new_chainring
    changed
  end

  def changed
    p "yobareta"
    p observer
    observer.changed(chainring, cog)
    p observer
  end
end

# 使われていないインターフェースを削除する
# パブリックインターフェースを証明する
require "minitest/autorun"
class WheelTest < MiniTest::Test

  def test_calculates_diamiter
    wheel = Wheel.new(26, 1.5)

    assert_in_delta(29,
      wheel.width,
      0.01)
  end
end

class DiameterDouble
  def diameter
    10
  end
end

class GearTest < MiniTest::Test

  def setup
    @observer = MiniTest::Mock.new
    p "@observer"
    p @observer
    @gear = Gear.new(
      chainring: 52,
      cog: 11,
      observer: @observer)
  end

  def test_notifies_observer4s_when_cogs_change
    @observer.expect(:changed, true, [52, 27])
    @gear.set_cog(27)
    @observer.verify
  end

  def test_notifies_observers_when_chainring_change
    @observer.expect(:changed, true, [42, 11])
    @gear.set_chainring(42)
    @observer.verify
  end

  # def test_calculates_gear_inches
  #   gear = Gear.new(
  #     chainring: 52,
  #     cog: 11,
  #     wheel: DiameterDouble.new
  #   )

  #   assert_in_delta(47.27,
  #     gear.gear_inches,
  #     0.01)
  # end
end

