require 'JSON'

class Simulator
  attr_accessor :name
  attr_accessor :udid
  attr_accessor :booted
  attr_accessor :available

  def initialize(name, udid, booted, available)
    @name = name
    @udid = udid
    @booted = booted == 'Booted'
    @available = available == '(available)'
  end
end
