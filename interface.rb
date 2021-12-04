# frozen_string_literal: true

require_relative 'imports'

class Interface
  def print_sep
    puts '=' * 20
  end

  def say_hello(user_name)
    print_sep
    puts "\n#{user_name.capitalize}, game is started!"
    print_sep
  end

  def show_the_board(show_dealers_points, bank, dealer, user)
    print_sep
    puts "\tBANK: #{bank}"
    puts "Dealer's balance: #{dealer.balance}"
    puts "Dealer's total: #{dealer.hand.points}" if show_dealers_points
    puts "Dealer's cards"
    dealer.hand.cards.each { |_card| print "*\t" } unless show_dealers_points
    dealer.hand.show_cards.each { |card| print "#{card}\t" } if show_dealers_points
    puts ''
    print_sep
    puts "Your balance: #{user.balance}"
    puts "Your total: #{user.hand.points}"
    puts 'Your cards'
    user.hand.show_cards.each { |card| print "#{card}\t" }
    puts ''
  end

  def user_input(third_option)
    valid_option = false
    until valid_option
      puts "\nChoose what you want to do: "
      aviable_options = {
        1 => 'Skip',
        2 => 'Open cards'
      }
      aviable_options[3] = 'Add a card' if third_option
      aviable_options.each { |key_value| puts "Type #{key_value[0]} to #{key_value[1]}" }
      print '-> '
      inp = gets.chomp
      valid_option = !aviable_options[inp.to_i].nil? if inp.to_i.between?(1, aviable_options.size)
    end
    inp
  end

  def dealer_progress(move)
    puts "\n#{move}\n"
  end

  def game_result(res)
    print_sep
    puts res
    print_sep
  end
end
