class HumanPlayer
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def guess(fragment)
    puts "The Fragment is #{fragment}"
    puts "Take a guess"
    answer = gets.chomp
    answer
  end

  def alert_invalid_guess
    puts "Invalid guess"
    guess
  end
end
