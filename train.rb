class Train
  attr_reader :speed, :wagon_count, :number, :type, :route, :all_wagon, :station_index

  def initialize(number, type)
    @number = number
    @type = type
    @all_wagon = []
    @wagon_count = 0
    @speed = 0
    @route = nil
    @station_index = nil
  end

  # Может тормозить (сбрасывать скорость до нуля)
  def stop
    @speed = 0
  end

  # Может прицеплять вагоны
  def add_wagon(wagon)
    if speed.zero?
      @wagon_count += 1
      all_wagon.push(wagon)
      puts "К поезду № #{number} прицепили вагон. Теперь их #{wagon_count}."
    else
      puts 'На ходу нельзя прицеплять вагоны!'
    end
  end

  # Может отцеплять вагоны
  def remove_wagon
    if wagon_count.zero?
      puts 'Вагонов уже не осталось.'
    elsif speed.zero?
      @wagon_count -= 1
      puts "От поезда №#{number} отцепили вагон. Теперь их #{wagon_count}."
    else
      puts 'На ходу нельзя отцеплять вагоны!'
    end
  end

  # Может принимать маршрут следования (объект класса Route).
  def take_route(route)
    @route = route
    @station_index = 0
    current_station.get_train(self)
    puts "Поезду № #{number} задан маршрут #{route.stations.first.name} - #{route.stations.last.name}"
  end

  # Текущая станция
  def current_station
    @route.stations[@station_index]
  end

  # Следующая станция
  def next_station
    @route.stations[@station_index + 1]
  end

  # Предедущая станция
  def prev_station
    @route.stations[@station_index - 1]
  end

  # Вперед
  def move_to_next_station
    current_station.send_train(self)
    @station_index += 1
    current_station.get_train(self)
  end

  # Назад
  def move_to_prev_station
    current_station.send_train(self)
    @station_index -= 1
    current_station.get_train(self)
  end
end
