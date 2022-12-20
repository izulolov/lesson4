require_relative 'train'

class TrainPassenger < Train

  def initialize(number)
    super(number, type = 'Passenger')
  end

  def add_wagon(wagon)
    if wagon.type == type
      super(wagon)
    else
      puts 'Ты дурак что-ли?! К пассажирскому поезду можно прикреплять только пассажирские вагоны!'
    end
  end
end
