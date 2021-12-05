# frozen_string_literal: true

class Card
  attr_reader :value

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def show
    "#{@value}#{@suit.encode('utf-8')}"
  end
end
