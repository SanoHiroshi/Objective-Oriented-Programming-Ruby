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

  def diameter
    rim + (tire * 2)
  end
end

class Gear
  attr_reader :chainring, :cog, :rim, :tire

  def initialize(args)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @rim = args[:cog]
    @tire = args[:tire]
  end

  def gear_inches
    ratio * Wheel.new(rim, tire).diameter
  end

  def ratio
    chainring / cog.to_f
  end
end


