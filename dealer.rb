# frozen_string_literal: true

require_relative 'modules/deal_cards'

class Dealer
  include DealCards

  def show_no_cards
    @cards.each { |_card| print "*\t" }
  end
end
