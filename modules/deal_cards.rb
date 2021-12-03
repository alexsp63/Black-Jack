# frozen_string_literal: true

module DealCards
  attr_reader :cards
  attr_accessor :balance

  def give_cards
    @cards ||= []
    if @cards.size == 2 || @cards.size.zero?
      case @cards.size
      when 2
        n = 1
      when 0
        n = 2
      end
      new_cards = Card.aviable_cards.sample(n)
      new_cards.each do |card|
        @cards.push(card)
        card.owner = self
      end
    end
  end

  def pay_money(payment)
    @balance ||= 100
    @balance -= payment
  end

  def points
    count_points
  end

  def count_points
    points = 0
    aces = @cards.select { |card| card.value == 'A' }
    # чтобы получить максимальную сумму очков и не проиграть при этом, нужно сначала посчитать другие карты,
    # а потом подумать, как считать тузы, если они есть
    @cards.each do |card|
      point = card.value
      points += point.to_i if point.to_i.between?(2, 9)
      points += 10 if %w[J Q K].include?(point)
    end
    unless aces.empty?
      # если есть хотя бы один туз, нужно проверить, может ли дать он 11 очков и не привести к проигрышу,
      if points <= (21 - 11 - (aces.size - 1))
        # если это возможно, тогда он даст 11 очков, а остальные тузы по одному очку
        points += 11
        points += aces.size - 1
      else
        # если нет, то все тузы дают по минимуму - по одному очку
        points += aces.size
      end
    end
    points
  end

  def reset_cards
    @cards.each do |card|
      Card.aviable_cards.push(card)
    end
    @cards = []
  end

  def show_cards
    @cards.each(&:show)
  end
end
