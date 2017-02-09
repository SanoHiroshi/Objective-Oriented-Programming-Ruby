class Bicycle
  attr_reader :size, :parts

  def initialize(args={})
    @size = args[:size]
    @parts = args[:parts]
  end

  def spares
    parts.spares
  end
end

require 'ostruct'
module PartsFactory
  def self.build(config, parts_class = Parts)
    parts_class.new(
      config.collect {|part_config|
        create_part(part_config)})
  end

  def self.create_part(part_config)
    OpenStruct.new(
      name: part_config[0],
      description: part_config[1],
      need_spares: part_config.fetch(2, true)
    )
  end
end

require 'forwardable'
class Parts
  extend Forwardable
  def_delegators :@parts, :size, :each
  include Enumerable

  def initialize(parts)
    @parts = parts
  end

  def spares
    select { |part| part.need_spares }
  end
end

class RoadBikeParts < Parts
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

class MountainBikeParts < Parts
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

# chain =
#   Part.new(name: 'chain', description: '10-speed')

# road_tire =
#   Part.new(name: 'tire_tire', description: '23')

# tape =
#   Part.new(name: 'tape_color', description: 'red')

# mountain_tire =
#   Part.new(name: 'tire_size', description: '2.1')

# rear_shock =
#   Part.new(name: 'rear_shock', description: 'Fox')

# front_shock =
#   Part.new(
#     name: 'front_shock',
#     description: 'Manitou',
#     need_spares: false
#   )

# road_bike_parts =
#   Parts.new([chain, road_tire, tape])

# road_bike =
#   Bicycle.new(
#     size: 'L',
#     parts: road_bike_parts
#   )

# road_bike.size
# road_bike.spares

# mountain_bike =
#   Bicycle.new(
#     size: 'L',
#     parts: Parts.new([chain, mountain_tire, front_shock, rear_shock])
#   )

# # p mountain_bike.size
# mountain_bike.spares

road_config =
  [
    ['chain', '10-speed'],
    ['tire_size', '23'],
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
p road_bike.spares.size
p road_bike.parts
p road_bike.parts.size

moutain_parts = PartsFactory.build(moutain_config)

p moutain_parts






