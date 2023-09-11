# frozen_string_literal: true

class TrainApp

  def initialize
    @routes = []
    @stations = []
  end

  def action
    loop do
      show_actions
      choice = gets.chomp.to_i

      case choice
      when 0
        break
      when 1
        create_station
      when 2
        create_train
      when 3
        create_car
      when 4
        add_wagon_to_train
      when 5
        remove_wagon_from_train
      when 6
        move_train_to_station
      when 7
        list_stations
      when 8
        list_trains_on_station
      when 9
        list_all_trains
      else
        show_actions_prompt
      end
    end
  end

  private

  MENU = ['Выход', 'Создать станцию', 'Создать поезд', 'Создать вагон', 'Прицепить вагон к поезду', 'Отцепить вагон от поезда', 'Поместить поезд на станцию', 'Просмотреть список станций', 'Просмотреть список поездов находящихся на станции', 'Список всех поездов']

  def show_actions
    MENU.each_with_index { |item, index| puts "#{index}. #{item}" }
  end

  def ask(question)
    puts question
    gets.chomp
  end

  def create_station
    name = ask('Введите название станции')
    @stations << Station.new(name)
    puts "Построена станция #{name}"
  end

  def create_route
    list_stations
    first_station_name = ask('Введите начальную станцию:')
    first_station = @stations.find { |station| station.name = first_station_name }
    last_station_name = ask('Введите конечную станцию:')
    last_station = @stations.find { |station| station.name = last_station_name }
    @routes << Route.new(first_station, last_station)
  end

  def add_station; end

  def create_train
    number = ask('C каким номером?')
    choice = ask('1 - пассажирский, 2 - грузовой').to_i
    case choice
    when 1
      PassengerTrain.new(number)
      puts "Создан пассажирский поезд №#{number}"
    when 2
      CargoTrain.new(number)
      puts "Создан грузовой поезд №#{number}"
    else
      puts 'Поезд не создан. Введите 1 или 2'
    end
  end

  def create_car
    number = ask('Введите номер вагона:')

    choice = ask('Выберите тип вагона: 1 - пассажирский, 2 - грузовой').to_i
    case choice
    when 1
      PassengerCar.new(number)
    when 2
      CargoCar.new(number)
    else
      puts 'Вагон не создан. Введите 1 или 2'
      return
    end

    puts("Создан новый вагон <#{Car.all.last.number}>")
  end

  def add_wagon_to_train
    list_all_trains
    train = Train.all[ask('Добавляем вагон поезду. Выберите поезд:').to_i]

    print_cars
    train.add_car(Car.all[ask('Выберите вагон:').to_i])

    puts("Изменен состав поезда <#{train.number}>")
  end

  def remove_wagon_from_train
    train = Train.all[ask('Отцепляем вагон от поезда. Выберите поезд:').to_i]
    train.remove_car(train.cars[ask('Выберите вагон:').to_i])

    puts("Изменен состав поезда <#{train.number}>")
  end

  def move_train_to_station
    if !Train.all
      puts 'Сначала Сначала создайте поезд'
    elsif @stations.empty?
      puts 'Сначала создайте станцию'
    else
      train = Train.all[ask('Какой поезд?').to_i]
      if train.nil?
        puts 'Поезда с таким номером нет'
      else
        name = ask('На какую станцию? (название)')
        station = @stations.detect { |station| station.name == name }
        if station.nil?
          puts 'Такой станции нет'
        else
          station.get_train(train)
        end
      end
    end
  end

  def list_stations
    puts 'Список станций:'
    @stations.each { |station| puts station.name }
  end

  def list_trains_on_station
    if @stations.empty?
      puts 'Сначала создайте станцию'
    else
      name = ask('На какой? (название)')
      station = @stations.detect { |station| station.name == name }
      if station.nil?
        puts 'Такой станции нет'
      else
        station.show_trains
      end
    end
  end

  def list_all_trains
    Train.all.each_with_index { |v, i| puts "#{i}. #{v.number}, #{v.type}" }
  end
  def print_cars
    Car.all.each_with_index { |v, i| puts "#{i}. #{v.number}, #{v.type}" }
  end

  def show_actions_prompt
    puts 'Необходимо выбрать один из предложенных вариантов'
  end
end
