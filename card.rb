class Card
  attr_reader :value

  @@aviable_cards = []

  def self.aviable_cards
    @@aviable_cards
  end

  def initialize(value, suit)
    @value = value
    @suit = suit
    @@aviable_cards.push(self)
  end

  def show
    print "#{@value}#{@suit.encode('utf-8')}\t"
  end

  def owner=(user)
    @owner = user if @owner.nil?
    @@aviable_cards.delete(self)
  end
end
