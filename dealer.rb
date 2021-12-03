class Dealer
  attr_reader :cards

  def initialize
    @balance = 90
  end

  def show_no_cards
    @cards.each { |card| print "* "}
  end
end
