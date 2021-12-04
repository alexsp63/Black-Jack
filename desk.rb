class Desk
  # теперь карты генерируются, хранятся, сдаются и тасуются тут

  def initialize
    @aviable_cards = []
    VALUES.each { |value| SUITS.each { |suit| @aviable_cards.push(Card.new(value, suit)) } }
  end

  def give_cards(hand)
    if hand.cards.size == 2 || hand.cards.size.zero?
      case hand.cards.size
      when 2
        n = 1
      when 0
        n = 2
      end
      new_cards = @aviable_cards.sample(n)
      new_cards.each do |card|
        hand.cards.push(card)
        @aviable_cards.delete(card)
      end
    end
  end

  def reset_cards(hand)
    hand.cards.each do |card|
      @aviable_cards.push(card)
    end
    hand.cards = []
  end

  private

  VALUES = %w[2 3 4 5 6 7 8 9 J Q K A].freeze
  SUITS = ["\u2660", "\u2665", "\u2666", "\u2663"].freeze
end
