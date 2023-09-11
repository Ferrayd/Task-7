# frozen_string_literal: true

class Station
  attr_reader :name
  include Counter
  include Validation

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    self.class.all << self
  end

  def self.all
    @@all ||= []
  end

  def get_train(train)
    @trains << train
    puts "На станцию #{name} прибыл поезд №#{train.number}"
  end

  def send_train(train)
    @trains.delete(train)
    train.station = nil
    puts "Со станции #{name} отправился поезд №#{train.number}"
  end

  def show_trains(type = nil)
    if type
      puts "Поезда на станции #{name} типа #{type}: "
      @trains.each { |train| puts train.number if train.type == type }
    else
      puts "Поезда на станции #{name}: "
      @trains.each { |train| puts train.number }
    end
  end

  protected
  
  def validate!
    raise "Ошибка валидации: название должно быть текстовым" if @name.class != String
    raise "Ошибка валидации: Не указано название станции!" if @name.empty?
  end  

end
