require_relative 'modules/deal_cards'

class User
  include DealCards

  attr_accessor :balance
  attr_reader :name, :cards, :points

  def initialize(name)
    @name = name
    @balance = 100
    @cards = []
  end

end
