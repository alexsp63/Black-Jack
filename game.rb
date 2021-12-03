# frozen_string_literal: true

require_relative 'imports'

class Game
  VALUES = %w[2 3 4 5 6 7 8 9 J Q K A].freeze
  SUITS = ["\u2660", "\u2665", "\u2666", "\u2663"].freeze

  def initialize(user, dealer)
    @interface = Interface.new
    @user = user
    @dealer = dealer
    VALUES.each { |value| SUITS.each { |suit| Card.new(value, suit) } }
    @payment = 10
  end

  def play
    @bank = 0
    @interface.say_hello(@user.name)
    @players = [@user, @dealer]
    @players.each do |player|
      player.pay_money(@payment)
      @bank += @payment
      player.give_cards
    end
    step = 0
    loop do
      @interface.show_the_board(false, @bank, @dealer, @user)
      if step.even?
        # ход игрока
        break if users_move
      elsif dealers_move
        # ход дилера
        break
      end
      step += 1
    end
    show_game_end
  end

  private

  def users_move
    case @interface.user_input(@user.cards.size == 2).to_i
    when 1
      @user.cards.size == 3 && @dealer.cards.size == 3
    when 2
      true
    when 3
      @user.give_cards
      @user.cards.size == 3 && @dealer.cards.size == 3
    end
  end

  def dealers_move
    if @dealer.points < 17
      @dealer.give_cards # если менее 17 очков, добавляет карту
      @interface.dealer_progress('DEALER ADDED A CARD')
    else
      @interface.dealer_progress('DEALER SKIPPED')
    end
    @user.cards.size == 3 && @dealer.cards.size == 3
  end

  def show_game_end
    @interface.show_the_board(true, @bank, @dealer, @user)
    if @user.points == @dealer.points
      @interface.game_result('DROW')
      @players.each { |player| player.balance += (@bank / 2) }
    elsif (@user.points > @dealer.points && @user.points <= 21) || (@user.points < @dealer.points && @dealer.points > 21)
      @interface.game_result("#{@user.name.capitalize} WON")
      @user.balance += @bank
    elsif (@user.points > @dealer.points && @user.points > 21) || (@user.points < @dealer.points && @dealer.points <= 21)
      @interface.game_result('DEALER WON')
      @dealer.balance += @bank
    end
    @user.reset_cards
    @dealer.reset_cards
  end
end
