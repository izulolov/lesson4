require_relative 'train'

class TrainCargo < Train
  def initialize(number)
    super(number, type = 'Cargo')
  end

  def add_wagon(wagon)
    if wagon.type == type
      super(wagon)
    else
      puts 'Ты дурак что-ли?! К грузовому поезду можно прикреплять только грузовые вагоны!'
    end
  end
end
