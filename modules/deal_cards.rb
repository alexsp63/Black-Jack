module DealCards
  
  def give_cards
    @cards ||= []
    if @cards.size == 2 || @cards.size == 0
      case @cards.size
      when 2
        n = 1
      when 0
        n = 2
      new_cards = Card.aviable_cards.sample(n)
      new_cards.each do |card| 
        @cards.push(card) 
        card.owner = self
      end
      end
    end
  end

  def points
    self.count_points
  end

  def count_points
    points = 0
    aces = self.card.select { |card| if card.value == "A"}
    # чтобы получить максимальную сумму очков и не проиграть при этом, нужно сначала посчитать другие карты,
    # а потом подумать, как считать тузы, если они есть
    self.cards.each do |card| 
      point = card.value
      points += point.to_i if point.to_i.between?(2, 9)
      points += 10 if ["J", "Q", "K"].include?(point)
    end
    unless aces.empty?
      # если есть хотя бы один туз, нужно проверить, может ли дать он 11 очков и не привести к проигрышу,
      if points <= (21 - 11 - (aces.size-1))
        # если это возможно, тогда он даст 11 очков, а остальные тузы по одному очку
        points += 11
        points += aces.size - 1
      else
        # если нет, то все тузы дают по минимуму - по одному очку
        points += aces.size 
      end
    end
    return points
  end

  def reset_cards
    self.cards.each do |card|
      self.cards.delete(card)
      Card.aviable_cards.push(card)
    end
  end

  def show_cards
    @cards.each { |card| card.show}
  end
    
end