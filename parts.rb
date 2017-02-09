class Bicycle
  attr_reader :size, :parts

  def initialize(args={})
    @size = args[:size]
    @parts = args[:parts]
  end

  def spares
    parts.spares
    p parts.size
  end
end

require 'forwardable'
class Parts
  extend Forwardable
  def_delegator :@parts, :size, :each
  include Enumerable

  def initialize(parts)
    @parts = parts
  end

  def spares
    @parts.select {|part|
      part.needs_spare}
  end
end

require 'ostruct'
module PartsFactory
  def self.build(config, parts_class = Parts)
    parts_class.new(
      config.collect {|part_config|
        create_part(part_config)
      }
    )
  end

  def self.create_part(part_config)
    OpenStruct.new(
      name: part_config[0],
      deescription: part_config[1],
      needs_spare: part_config.fetch(2, true)
    )
  end
end

road_config =
  [
    ['chain', '10-speed'],
    ['tire_size', '2.1'],
    ['tape_color', 'red']
  ]

moutain_config =
  [
    ['chain', '10-speed'],
    ['tire_size', '2.1'],
    ['front_shock', 'Manitou', false],
    ['rear_shock', 'Fox']
  ]


road_bike = Bicycle.new(
  size: 'L',
  parts: PartsFactory.build(road_config)
)

p road_bike.spares

moutain_bike = Bicycle.new(
  size: 'L',
  parts: PartsFactory.build(moutain_config)
)

p moutain_bike.spares
p moutain_bike.spares.size


