# frozen_string_literal: true

class User < Dealer   # это такой же игрок, как и дилер, но с именем, поэтому наследую методы дилера
  attr_reader :name

  def initialize(name, hand)
    @name = name
    @hand = hand
  end
end
