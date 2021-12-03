# frozen_string_literal: true

require_relative 'imports'

class Game
  VALUES = %w[2 3 4 5 6 7 8 9 J Q K A].freeze
  SUITS = ["\u2660", "\u2665", "\u2666", "\u2663"].freeze

  def initialize(user, dealer)
    interface = Interface.new
    @user = user
    @dealer = dealer
    VALUES.each { |value| SUITS.each { |suit| Card.new(value, suit) } }
    @payment = 10
  end

  def play
    @bank = 0
    print_sep
    puts "\n#{@user.name.capitalize}, game is started!"
    print_sep
    @players = [@user, @dealer]
    @players.each do |player|
      player.pay_money(@payment)
      @bank += @payment
      player.give_cards
    end
    step = 0
    loop do
      show_the_board(false)
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

  def print_sep
    puts "=" * 20
  end

  def show_the_board(show_dealers_points)
    print_sep
    puts "\tBANK: #{@bank}"
    puts "Dealer's balance: #{@dealer.balance}"
    puts "Dealer's total: #{@dealer.points}" if show_dealers_points
    puts "Dealer's cards"
    @dealer.show_no_cards unless show_dealers_points
    @dealer.show_cards if show_dealers_points
    puts ""
    print_sep
    puts "Your balance: #{@user.balance}"
    puts "Your total: #{@user.points}"
    puts 'Your cards'
    @user.cards.each(&:show)
    puts ""
  end

  def users_move
    valid_option = false
    until valid_option
      puts "\nChoose what you want to do: "
      aviable_options = {
        1 => 'Skip',
        2 => 'Open cards'
      }
      aviable_options[3] = 'Add a card' if @user.cards.size == 2
      aviable_options.each { |key_value| puts "Type #{key_value[0]} to #{key_value[1]}" }
      print '-> '
      inp = gets.chomp
      valid_option = !aviable_options[inp.to_i].nil? if inp.to_i.between?(1, aviable_options.size)
    end
    case inp.to_i
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
      puts "\nDEALER ADDED A CARD\n"
    else
      puts "\nDEALER SKIPPED\n"
    end
    @user.cards.size == 3 && @dealer.cards.size == 3
  end

  def show_game_end
    show_the_board(true)
    print_sep
    if @user.points == @dealer.points
      puts 'DROW'
      @players.each { |player| player.balance += (@bank / 2) }
    elsif (@user.points > @dealer.points && @user.points <= 21) || (@user.points < @dealer.points && @dealer.points > 21)
      puts "#{@user.name.capitalize} WON"
      @user.balance += @bank
    elsif (@user.points > @dealer.points && @user.points > 21) || (@user.points < @dealer.points && @dealer.points <= 21)
      puts 'DEALER WON'
      @dealer.balance += @bank
    end
    @user.reset_cards
    @dealer.reset_cards
    print_sep
  end
end
