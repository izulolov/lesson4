class Route
  attr_reader :stations, :from, :to

  def initialize(from, to)
    @from = from
    @to = to
    @stations = [@from, @to]
  end

  # Может добавлять промежуточную станцию в список
  def add_station(station)
    stations.insert(1, station)
  end

  # Может удалять промежуточную станцию из списка
  def delete_station(station)
    if stations[0] == station || stations[stations.length - 1] == station
      puts 'Первую и последную станцию нельзя удалять!'
    else
      puts "Удалена станция #{station.name}"
      stations.delete(station)
      puts "Все станции на маршруте #{stations.first.name} - #{stations.last.name}"
      stations.each { |st| puts st.name }
    end
  end

  # Может выводить список всех станций по-порядку от начальной до конечной
  def show_stations
    puts "В маршрут #{stations.first.name} - #{stations.last.name} входят станции: "
    stations.each_with_index { |station, index| puts "#{index + 1} -> #{station.name}" }
  end
end
