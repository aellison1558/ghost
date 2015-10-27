require_relative 'human_player'
class Game
  GHOST = "GHOST"
  attr_accessor :fragment, :player1
  def initialize(player1, player2, dictionary)
    @player1 = player1
    @player2 = player2
    @fragment = ""
    @dictionary = File.readlines("dictionary.txt")
    @dictionary = @dictionary.map {|word| word.chomp}
    @current_player = @player1
    @previous_player = @player2
    @losses = {
      @player1 => 0,
      @player2 => 0
    }
  end

  def next_player!
    if @current_player == @player1
      @current_player = @player2
      @previous_player = @player1
    elsif @current_player == @player2
      @current_player = @player1
      @previous_player = @player2
    end
  end

  def valid_play?(string)
    return false unless ("a".."z").include?(string)
    @dictionary.any? do |word|
      word[0...(@fragment + string).length] == (@fragment + string)
    end
  end

  def take_turn(player)
    guess = player.guess
    while !valid_play?(guess)
      guess = player.alert_invalid_guess
    end
    @fragment += guess
  end

  def play_round
    while !won?
      take_turn(@current_player)
      next_player!
    end
    @losses[@previous_player] += 1
    string = record(@previous_player)
    puts "#{@previous_player.name} has #{string}"
  end

  def won?
    @dictionary.include?(@fragment)
  end

  def game_over?
    record(@player1) == GHOST || record(@player2) == GHOST
  end

  def play
    while !game_over?
      play_round
      @fragment = ""
    end
  end

  def record(player)
    if @losses[player] == 0
    else
      GHOST[0..(@losses[player] - 1)]
    end
  end


end

dictionary = File.readlines("dictionary.txt")
dictionary = dictionary.map {|word| word.chomp}
player1 = HumanPlayer.new("Player 1")
player2 = HumanPlayer.new("Player 2")
game = Game.new(player1, player2, dictionary)
game.play
