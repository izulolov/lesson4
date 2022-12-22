require_relative 'interface_method'

class Interface

  interface_method_object = InterfaceMethod.new

  interface_method_object.menus

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
      interface_method_object.create_stations

    # Создать поезд
    when 2
      interface_method_object.create_trains

    # Создать маршрут
    when 3
      interface_method_object.create_route

    # Добавить или удалить станцию из маршрута
    when 4
      interface_method_object.edit_route

    # Назначить маршрут поезду
    when 5
      interface_method_object.train_route

    # Добавить вагон
    when 6
      interface_method_object.add_wagon

    # Удалить вагон
    when 7
      interface_method_object.delet_wagon

    # Перемещать поезд по маршруту вперед или назад
    when 8
      interface_method_object.move_to_next_or_prev_station

    # Список станции
    when 9
      interface_method_object.list_station

    # Список поездов на станции
    when 10
      interface_method_object.trains_in_station

    else
      puts 'Надо выбрать один из предложенных вариантов!'
  end
end
end
