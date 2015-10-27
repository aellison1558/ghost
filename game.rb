require_relative 'human_player'
class Game
  GHOST = "GHOST"
  attr_accessor :fragment, :player1
  def initialize(players, dictionary)
    @players = players
    @fragment = ""
    @dictionary = File.readlines("dictionary.txt")
    @dictionary = @dictionary.map {|word| word.chomp}
    @current_player = 0
    @previous_player = -1
    @losses = {}
    @players.each do |player|
      @losses[player] = 0
    end

  end

  def next_player!(current_or_previous)
    if current_or_previous < @players.length
      current_or_previous += 1
    else
      current_or_previous = 0
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
      take_turn(@players[@current_player])
      next_player!(@current_player)
      next_player!(@previous_player)
    end
    @losses[@players[@previous_player]] += 1
    string = record(@players[@previous_player])
    puts "#{@players[@previous_player].name} has #{string}"
  end

  def won?
    @dictionary.include?(@fragment)
  end

  def game_over?
    @players.length == 1
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
