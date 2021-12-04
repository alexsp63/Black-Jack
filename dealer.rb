# frozen_string_literal: true

class Dealer
  attr_reader :hand
  attr_accessor :balance

  def initialize(hand)
    @hand = hand
  end

  def pay_money(payment)
    @balance ||= 100
    @balance -= payment
  end
end
