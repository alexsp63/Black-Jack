# frozen_string_literal: true

require_relative 'imports'

class Game
  def initialize(user, dealer)
    @interface = Interface.new
    @user = user
    @dealer = dealer
    @desk = Desk.new
    @payment = 10
  end

  def play
    @bank = 0
    @interface.say_hello(@user.name)
    @players = [@user, @dealer]
    @players.each do |player|
      player.pay_money(@payment)
      @bank += @payment
      @desk.give_cards(player.hand)
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
    hand = @user.hand
    case @interface.user_input(hand.cards.size == 2).to_i
    # when 1
    #   при скипе ничего не происходит
    when 2
      return true
    when 3
      @desk.give_cards(hand)
    end
    hand.cards.size == 3 && @dealer.hand.cards.size == 3
  end

  def dealers_move
    hand = @dealer.hand
    if hand.points < 17
      @desk.give_cards(hand) # если менее 17 очков, добавляет карту
      @interface.dealer_progress('DEALER ADDED A CARD')
    else
      @interface.dealer_progress('DEALER SKIPPED')
    end
    @user.hand.cards.size == 3 && hand.cards.size == 3
  end

  def show_game_end
    user_hand = @user.hand
    dealer_hand = @dealer.hand
    @interface.show_the_board(true, @bank, @dealer, @user)
    if dealer_hand.points == user_hand.points
      @interface.game_result('DROW')
      @players.each { |player| player.balance += (@bank / 2) }
    elsif (user_hand.points > dealer_hand.points && user_hand.points <= 21) || (user_hand.points < dealer_hand.points && dealer_hand.points > 21)
      @interface.game_result("#{@user.name.capitalize} WON")
      @user.balance += @bank
    elsif (user_hand.points > dealer_hand.points && user_hand.points > 21) || (user_hand.points < dealer_hand.points && dealer_hand.points <= 21)
      @interface.game_result('DEALER WON')
      @dealer.balance += @bank
    end
    @desk.reset_cards(user_hand)
    @desk.reset_cards(dealer_hand)
  end
end
