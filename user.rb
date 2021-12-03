# frozen_string_literal: true

require_relative 'modules/deal_cards'

class User
  include DealCards

  attr_reader :name, :balance

  def initialize(name)
    @name = name
  end
end
