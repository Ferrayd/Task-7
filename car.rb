# frozen_string_literal: true

class Car
  attr_reader :number, :type
  include Information
  include Validation

  def initialize(number)
    @number = number
    validate!
    self.class.all << self
  end

  def self.all
    @@all ||= []
  end

  protected

  def validate!
    raise "Ошибка валидации: номер вагона должен быть текстовым" if @number.class != String
    raise "Ошибка валидации: не указан номер вагона" if @number.empty?
  end

end
