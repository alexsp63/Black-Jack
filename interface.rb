require_relative 'card'
require_relative 'user'

class Interface
  VALUES = %w[2 3 4 5 6 7 8 9 J Q K A]
  SUITS = ["\u2660", "\u2665", "\u2666", "\u2663"]

  def initialize(user, dealer)
    @user = user
    @dealer = dealer
    VALUES.each { |value| SUITS.each { |suit| Card.new(value, suit) } }
    game
  end

  private

  def print_sep
    puts 20 * '='
  end

  def show_the_board(show_dealers_points)
    puts "Dealer" 
    puts "#{@dealer.show_no_cards}" unless show_dealers_points
    puts "#{@dealer.show_cards}\t Dealer's total: #{@dealer.points}" if show_dealers_points
    print_sep
    puts 5 * "\n"
    @user.cards.each { |card| card.show }
    puts "#{@user.name}\t Your total: #{@user.points}"
  end

  def users_move
    valid_option = false
    until valid_option
      puts "Choose what you want to do: "
      aviable_options = {
        1 => "Skip",
        2 => "Open cards"
      }
      aviable_options[3] = "Add a card" if @user.cards.size == 2
      aviable_options.each { |key_value| puts "Type #{key_value[0]} to #{key_value[1]}" }
      print "-> "
      inp = gets.chomp
      valid_option = aviable_options[inp.to_i].nil? if inp.to_i.between?(1, aviable_options.size)
    end
    case inp.to_i
    when 1:
      return @user.cards.size == 3 && @dealer.cards.size == 3
    when 2:
      return true
    when 3:
      @user.give_cards
      return @user.cards.size == 3 && @dealer.cards.size == 3
  end

  def dealers_move
    @dealer.give_cards unless @dealer.points >= 17   # если менее 17 очков, добавляет карту
    return @user.cards.size == 3 && @dealer.cards.size == 3
  end

  def play
    step = 0
    game_end = false
    loop do
      show_the_board(open_cards)
      if step.even?
        # ход игрока
        break if users_move
      else
        # ход дилера
        break if dealers_move
      end
      step += 1
    end
  end

  def game
    print 'Input your name -> '
    name = gets.chomp
    @user = User.new(name)
    print_sep
    puts "\n#{name.capitalize}, game is started!"
    print_sep
    @user.give_cards
    @dealer = Dealer.new
    @dealer.give_cards
    
  end
end
