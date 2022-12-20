require_relative 'train'
require_relative 'train_passenger'
require_relative 'train_cargo'
require_relative 'route'
require_relative 'station'
require_relative 'wagon'
require_relative 'wagon_passenger'
require_relative 'wagon_cargo'

stations = []
trains = []
routes = []
trains_in_station = []
WAGON_TYPES = {'Cargo' => WagonCargo, 'Passenger' => WagonPassenger}

puts 'Выберите команду:'
puts %(
0. Выход
1. Создать станцию
2. Создать поезд
3. Создать маршрут
4. Добавлять или удалять станцию
5. Назначать маршрут поезду
6. Добавлять вагоны к поезду
7. Отцеплять вагоны от поезда
8. Перемещать поезд по маршруту вперед и назад
9. Просматривать список станций
10. Cписок поездов на станции
  )

loop do
  print 'Введите номер команды: '
  select = gets.chomp.to_i
  case select
    # Выход
    when 0
      puts 'До новых встреч!'
      break
    # Создать станцию
    when 1
      puts 'Введите название станции'
      name = gets.chomp
      stations << Station.new(name)
      puts "Создана станция #{name}"
    # Создать поезд
    when 2
      puts 'С каким номер создать поезд?'
      number = gets.chomp
      puts '1 - пассажирский, 2 - грузовой'
      select = gets.chomp.to_i
      case select
        when 1
          trains << TrainPassenger.new(number)
          puts "Создан пассажирский поезд с номером: #{number}"
        when 2
          trains << TrainCargo.new(number)
          puts "Создан грузовой поезд с номером: #{number}"
        else
          puts 'Поезд не создан! Введите 1 чтобы создать пассажирский, 2 для грузогого'
      end
    # Создать маршрут
    when 3
      if stations.length < 2
        puts 'Чтобы создать маршрут нужно создать хотябы две станции'
      else
        puts %(Какой маршрут создать?
        Начальную и конечную станцию в маршруте можете выбрать из списка ниже.
        Для этого введите индекс станции:)
        stations.each_with_index { |station, index| puts "#{index + 1} -> #{station.name}" }
        routes << Route.new(stations[gets.chomp.to_i - 1], stations[gets.chomp.to_i - 1])
        puts "Создан маршрут #{(routes[-1]).from.name} - #{(routes[-1]).to.name}"
      end
    # Добавить или удалить станцию из маршрута
    when 4
      if !routes.empty?
        puts 'Выберите маршрут из списка ниже куда ходите добавить или удалять станцию:'
        routes.each_with_index { |route, index| puts "#{index + 1} -> #{route}" }
        rt = gets.chomp.to_i
        puts "Вы выбрали маршрут #{routes[rt - 1].from.name} - #{routes[rt - 1].to.name}"
        puts 'Введите 1 чтобы добавить станцию, 2 - удалить'
        select = gets.chomp.to_i
        case select
          when 1
            puts 'Доступны следующие станции для добавления'
            stations.each_with_index { |station, index| puts "#{index + 1} -> #{station.name}" }
            st = gets.chomp.to_i
            routes[rt - 1].add_station(stations[st - 1])
            puts "Добавлена станция: #{stations[st - 1].name}"
          when 2
            puts 'Какую станцию удалить? Выберите из списка ниже:'
            routes[rt - 1].show_stations
            st = gets.chomp.to_i
            routes[rt - 1].delete_station(stations[st - 1])
          else
            puts 'Маршрут остался без изменения! Введите 1 или 2'
        end
      else
        puts 'Сначала надо создать маршрут!'
      end
    # Назначить маршрут поезду
    when 5
      if trains.empty?
        puts 'Сначала надо создать поезд'
      elsif routes.empty?
        puts 'Сначала надо создать маршрут'
      else
        puts 'Выберите в какой маршрут хотите назначить поезд(введите индекс):'
        routes.each_with_index { |route, index| puts "#{index + 1} - #{route}" }
        rt = gets.chomp.to_i - 1
        puts "Выберите какой поезд назначить на маршрут: #{routes[rt].from.name} - #{routes[rt].to.name} (введите индекс):"
        trains.each_with_index { |train, index| puts "#{index + 1} - #{train.number}" }
        tr = gets.chomp.to_i - 1
        trains[tr].take_route(routes[rt])
        trains_in_station << trains[tr]
      end
    # Добавить вагон
    when 6
      if trains.empty?
        puts 'Сначала необходимо создать поезд'
      else
        puts 'К какому поезду добваить вагон? (введите номер)'
        number = gets.chomp
        train = trains.detect { |train| train.number == number }
        if train.nil?
          puts 'Поезда с таким номером нет'
        else
          train.add_wagon(WAGON_TYPES[train.type].new)
        end
      end
    # Удалить вагон
    when 7
      if trains.empty?
        puts 'Сначала необходимо создать поезд'
      else
        puts 'От какого поезда оцепить вагон? (введите номер)'
        number = gets.chomp
        train = trains.detect { |train| train.number == number }
        if train.nil?
          puts 'Поезда с таким номером нет'
        elsif train.all_wagon.empty?
          puts 'У этого поезда и так нет вагонов'
        else
          train.remove_wagon
        end
      end
    # Перемещать поезд по маршруту вперед или назад
    when 8
      puts 'Какими поездами вы можете двигать(то есть каким поездам назначено станция):'
      trains_in_station.each { |train| puts "#{train.number} на станции #{(stations[train.station_index]).name}" }
      puts 'Какой поезд хотите двигать? (введите номер)'
      number = gets.chomp
      train = trains.detect { |train| train.number == number }
      if train.nil?
        puts 'Поезда с таким номером нет'
      else
        puts 'Выбрите 1 для впред, 2 для назад'
        move = gets.chomp.to_i
        case move
          when 1 # Вперед
            train.move_to_next_station
          when 2 # Назад
            train.move_to_prev_station
          else
            puts 'Надо было выбрать 1 или 2'
        end
      end
    # Список станции
    when 9
      if stations.empty?
        puts 'Сначала надо создать станцию!'
      else
        puts 'Все станции:'
        stations.each { |station| puts station.name }
      end
    # Список поездов на станции
    when 10
      if stations.empty?
        puts 'Сначала надо создать станцию!'
      else
        puts 'На какой станции?:'
        name = gets.chomp
        station = stations.detect { |st| st.name == name }
        if station.nil?
          puts 'Такой станции нет'
        else
          station.trains_in_station
        end
      end
    else
      puts 'Надо выбрать один из предложенных вариантов!'
  end
end
