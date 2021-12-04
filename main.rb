# frozen_string_literal: true

require_relative 'imports'

print 'Input your name -> '
name = gets.chomp
game = Game.new(User.new(name, Hand.new), Dealer.new(Hand.new))
loop do
  game.play
  puts "Do you want to play again? Type 'yes' to play again and something else to exit"
  print '-> '
  play_again = gets.chomp
  break unless play_again.downcase == 'yes'
end
puts 'Thank you for the game!'
