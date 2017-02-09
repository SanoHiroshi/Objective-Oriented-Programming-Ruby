# class Gear
#   attr_reader :chainring, :cog, :wheel

#   def initialize(chainring, cog, wheel = nil)
#     @chainring = chainring
#     @cog = cog
#     @wheel = wheel
#   end

#   def ratio
#     chainring / cog.to_f
#   end

#   # gear inches = ring diameter * Gear related
#   # ring diameter = rim diameter + tire thickness * 2

#   def gear_inches
#     ratio * wheel.diameter
#   end
# end

# class Wheel
#   attr_reader :rim, :tire

#   def initialize(rim, tire)
#     @rim = rim
#     @tire = tire
#   end

#   def diameter
#     rim + (tire * 2)
#   end

#   def circumference
#     diameter * Math::PI
#   end
# end

# @wheel = Wheel.new(26, 1.5)
# puts @wheel.circumference

# puts Gear.new(52, 11, @wheel).gear_inches
# puts Gear.new(52, 11, @wheel).gear_inches
# puts Gear.new(52, 11).ratio

# class Gear

#   # attr_readerは定義した自身のクラスからデータを隠蔽する
#   # def cog
#   #  @cog
#   # end
#   def initialize(chainring, cog)
#     @chainring = chainring
#     @cog = cog
#   end

#   def ratio
#     @chainring / @cog.to_f
#   end
# end
# puts Gear.new(52, 11).ratio

# class ObscurringReferences
#   attr_reader :data

#   def initialize(data)
#     @data = data
#   end

#   def diameters
#     # 0はリム、1はタイアであることも知っている必要がある
#     # 配列の構造に依存しているので、配列の構造が変わるとコードの変更が必要
#     # 配列にデータを持たせない
#      data.collect { |cell| cell[0] + (cell[1] * 2)}
#   end
# end

# class RevealingReferences
#   attr_reader :wheels

#   def initialize(data)
#     @wheels = wheelify(data)
#   end

#   # 2つの役割を持っている「wheelsの繰り返し処理」と「wheel直径の計算」
#   # def diameters
#   #    wheels.collect { |wheel| wheel.rim + (wheel.tire * 2)}
#   # end

#   def diameters
#      wheels.collect { |wheel| diameter(wheel)}
#   end

#   # 要素に対し実行される繰り返し処理を分離する
#   def diameter(wheel)
#     wheel.rim + (wheel.tire * 2)
#   end

#   Wheel = Struct.new(:rim, :tire)

#   def wheelify(data)
#     data.collect { |cell| Wheel.new(cell[0], cell[1])}
#   end
# end


# 単一責任メソッドがもたらす恩恵
# 1. 隠蔽されていた性質が明らかになる
# 2. コメントをする必要がない
# 3. 再利用を促進する
# 4. 他のクラスへの移動がかんたん

# 依存関係を認識する

# オブジェクトが次のものを知っているとき、オブジェクトは依存関係を持っている

# 他のクラスの名前を知っているとき
# GearはWheelというクラスが存在することを予想している

# self以外のどこかに送ろうとするメッセージの名前
# Gearは、Wheelのインスタンスがdiameterメッセージに応答すること

# メッセージが要求する引数
# Gearは、Wheelがnewにrimとtireが必要なこと

# それら引数の順番
# GearはWheel.newの最初がrimで二番目がtireだということ

# 設計課題
# 依存関係を管理し、それぞれのクラスがもつ依存を最低限にすること


# 依存を隔離する
# インスタンス変数の作成を分離する


# class Gear
#   attr_reader :chainring, :cog, :wheel

#   # diameterに応答するオブジェクトを渡す
#   # def initialize(args)
#   #   @chainring = args[:chainring] || 40
#   #   @cog = args[:cog] || 18
#   #   @wheel = args[:wheel]
#   # end

#   # デフォルト値がBoolの場合でも対応可能
#   def initialize(args)
#     @chainring = args.fetch(:chainring, 40)
#     @cog = args.fetch(:cog, 18)
#     @wheel = args[:wheel]
#   end

#   # デフォルト値を隔離
#   def initialize(args)
#     args = defaults.merge(args)
#     @chainring = args[:chainring]
#     @cog = args[:cog]
#     @wheel = args[:wheel]
#   end

#   def defaults
#     {:chainring => 40, :cog => 10}
#   end


#   # どのクラスかという情報はGearクラスは知らない
#   # Dependency Injection
#   def gear_inches
#     ratio * diameter
#   end

#   def diameter
#     wheel.diameter
#   end

#   def ratio
#     chainring / cog.to_f
#   end
# end

# class Wheel
#   attr_reader :rim, :tire

#   def initialize(rim, tire)
#     @rim = rim
#     @tire = tire
#   end

#   def diameter
#     rim + (tire * 2)
#   end

#   def circumference
#     diameter * Math::PI
#   end
# end

# puts Gear.new(
#   chainring: 52,
#   cog: 11,
#   wheel: Wheel.new(26, 1.5)
# ).gear_inches

# # 引数への順番の依存をなくす
# # 初期化の際の引数にハッシュを使う
# # 明示的にドフォルト値を設定できる


# # 外部ライブラリが引数の順番や個数を求める場合
# module SomeFramework
#   class Gear
#     attr_reader :chainring, :cog, :wheel

#     def initialize(chainring, cog, wheel)
#       @chainring = chainring
#       @cog = cog
#       @wheel = wheel
#     end
#     # ...
#   end
# end

# # ファクトリー（他のクラスのインスタンスを作成することが唯一の目的であるオブジェクト）
# module GearWrapper
#   # ハッシュでラップする
#   def self.gear(args)
#     SomeFramework::Gear.new(args[:chainring],
#       args[:cog],
#       args[:wheel]
#     )
#   end
# end

# GearWrapper.gear(
#   :chainring => 52,
#   :cog => 11,
#   :wheel => Wheel.new(26, 1.5).gear_inches
# )


# 依存方向の管理
# Gearに依存するかWheelに依存するか？
# 自身より変更されないものに依存した方がよい

# 1.あるクラスは他のクラスよりも要件が変わりやすい
# 変更のおきやすさを理解する
# フレームワークのコードよりRuby自体のコードの方が変更されづらい
# アプリケーション内のクラスは変更の起きやすさに応じて順位づけができる
# 2.具象クラスは、抽象クラスよりも関わる可能性が高い
# 3.多くのところから依存されたクラスを変更すると、広範囲に影響が及ぶ



# 柔軟なインターフェース
# クラスは「ソースコードリポジトリに何が入るか」を制御する
# 「クラスから成り立つ」がメッセージによって「定義される」

# オブジェクトが何を知っているか（オブジェクトの責任）
# 誰が知ってるか？（オブジェクトの依存関係
# オブジェクトが互いにどのように会話するか？


# パブリックインターフェース
# クラスの主要な責任を明らかにする
# 外部から実行されることが想定される
# 気まぐれに変更されない
# 他者がそこに依存しても安全
# テストで完全に文書化されている

# パブリックインターフェースは、クラスの責任を明確に述べる契約書の役割



# プライベートインターフェース
# 実装の詳細に関わる
# ほかのオブジェクトから送られてくることは想定していない
# どんな理由でも変更され得る
# 他者がそこに依存するのは危険
# テストでは、言及さえされないこともある

# 設計の視点を変える方法
# このクラスが何をすべきか？ではなく、このメッセージにはだれが応答するべきか？を考える
# メッセージを送るためにオブジェクトは存在する

# 明示的なパブリックインターフェースを定義することが何よりも重要
# パブリックインターフェースに含まれるメソッド
# 明示的にパブリックインターフェースだと特定できる
# 「どのように」よりも「何を」になっている
# 名前は、考えられる限り変わり得ないものである
# オプション引数としてハッシュを取る

# オブジェクト指向設計の目的
# 変更にかかるコストを下げること
# 厳密に定義されたパブリックインターフェースを構築すること
# ダックタイピング

# class Trip
#   attr_reader :bicycles, :customers, :vehicle

#   # このmechanic引数はどんなクラスのものでもよい
#   def prepare(preparers)
#     preparers.each { |preparer|
#       preparer.prepare.trip(self)
#     }
#   end
#   # ...
# end

# class Mechanic
#   def prepare_trip(trip)
#     trip.bicycles.each {|bicycle|
#       prepare_bicycle(bicycle)
#     }
#   end

#   def prepare_bicycle(bicycle)
#     # ...
#   end
# end

# class TripCoodinator
#   def prepare_trip(trip)
#     buy_food(trip.customers)
#   end
# end

# class Drive
#   def prepare_trip(trip)
#     vehicle = trip.vehicle
#     gas_up(vehicle)
#     fill_water_tank(vehicle)
#   end

#   def gas_up(vehicle)
#   end

#   def fill_water_tank(vehicle)
#   end
# end


# class Bicycle
#   attr_reader :size, :tape_color

#   def initialize(args)
#     @size = args[:size]
#     @tape_color = args[:tape_color]
#   end

#   # すべての自転車はデフォルト値として同じタイヤサイズとチェーンサイズを持つ

#   def spares
#     {
#       chain: '10-speed',
#       tire_size: '23',
#       tape_color: tape_color
#     }
#   end

#   # 他にもメソッドがたくさん
# end

# bike = Bicycle.new(
#   size: 'M',
#   tape_color: 'red')

# p bike.size
# p bike.spares
module Schedulable
  attr_writer :schedule

  def schedule
    @schedule ||= ::Schedule.new
  end

  def schedulable?(start_date, end_date)
    p lead_days
    p self.class
    !scheduled?(start_date - lead_days, end_date)
  end

  def scheduled?(start_date, end_date)
    schedule.scheduled?(self, start_date, end_date)
  end

  def lead_days
    0
  end
end

class Schedule
  def scheduled?(schedulable, start_date, end_date)
    puts "This #{schedulable.class}" +
      "is not scheduled\n" +
      " between #{start_date} and #{end_date}"
    false
  end
end

class Bicycle
  include Schedulable

  attr_reader :schedule, :size, :chain, :tire_size # <- RoadBickから昇格した

  def initialize(args={})
    @schedule = args[:schedule] || Schedule.new
    @size = args[:size] # <- RoadBickから昇格した
    @chain = args[:chain] || default_chain
    @tire_size = args[:tire_size] || default_tire_size

    post_initialize(args)
  end

  def lead_days
    1
  end

  def post_initialize(args)
    nil
  end

  def spares
    {
      tire_size: tire_size,
      chain: chain
    }.merge(local_spares)
  end

  def local_spares
    {}
  end

  def default_chain
    '10-speed'
  end

  def default_tire_size
    raise NotImplementedError
  end
end

class Vehicle
  include Schedulable

  def lead_days
    3
  end
end

class Mechanic
  include Schedulable

  def lead_days
    4
  end
end

class RoadBike < Bicycle
  attr_reader :tape_color

  def post_initialize(args)
    @tape_color = args[:tape_color]
  end

  def local_spares
    { tape_color: tape_color }
  end

  def default_tire_size
    '23'
  end
end

class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  def post_initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
  end

  def local_spares
    { rear_shock: rear_shock }
  end

  def default_tire_size
    '2.1'
  end
end

class RecumbentBike < Bicycle
  attr_reader :flag

  def post_initialize(args)
    @flag = args[:flag]
  end

  def local_spares
    {flag: flag}
  end

  def default_chain
    '9-speed'
  end

  def default_tire_size
    '28'
  end
end

require 'date'
starting = Date.parse("2017/02/04")
ending = Date.parse("2017/02/10")

b = Bicycle.new(tire_size: 24)
b.schedulable?(starting, ending)

v = Vehicle.new()
v.schedulable?(starting, ending)

m = Mechanic.new()
m.schedulable?(starting, ending)
# bent = RecumbentBike.new(flag: 'tall and orange')

# p bent.spares
# Bicycleは一般的な自転車の振る舞いとRoadBikeに固有の振る舞いをもっている

# 継承が効果を発揮する条件
# 1. モデル化しているオブジェクトが一般-特殊の関係をしっかりと持っていること
# 2. 正しいコーディングテクニックを使っていること

# リファクタリング
# すべてをサブクラスに下げて、その中からいくつかをあげる
# 継承の難しさは抽象と具象を厳密に分けることに失敗することによって生じる


# road_bike = RoadBike.new(
#   size: 'M',
#   tape_color: 'red'
#   )

# p road_bike.tire_size
# p road_bike.chain

# mountain_bike = MountainBike.new(
#   size: 'S',
#   front_shock: 'Manitou',
#   rear_shock: 'Fox'
#   )

# p mountain_bike.tire_size
# p mountain_bike.chain




