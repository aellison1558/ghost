require_relative 'human_player'
class Game
  GHOST = "GHOST"
  attr_accessor :fragment, :player1
  def initialize(players)
    @players = players
    @fragment = ""
    @dictionary = File.readlines("dictionary.txt")
    @dictionary = @dictionary.map {|word| word.chomp}
    @current_player = 0
    @losses = {}
    @players.each do |player|
      @losses[player] = 0
    end

  end

  def next_player!
    if @current_player < @players.length - 1
      @current_player += 1
    else
      @current_player = 0
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
      next_player!
    end
    @losses[@players[(@current_player - 1)]] += 1
    string = record(@players[(@current_player - 1)])
    puts "#{@players[(@current_player - 1)].name} has #{string}"
    if lost?(@players[(@current_player - 1)])
      puts "#{@players[(@current_player - 1)].name} has lost!"
      @players.delete(@players[(@current_player - 1)])
      if @current_player > @players.length
        next_player!(@current_player)
      end
    end
  end

  def won?
    @dictionary.include?(@fragment)
  end

  def lost?(player)
    record(player) == GHOST
  end

  def game_over?
    @players.length == 1
  end

  def play
    while !game_over?
      play_round
      @fragment = ""
    end
    puts "#{@players[0].name} won!"
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
player3 = HumanPlayer.new("Player 3")
player4 = HumanPlayer.new("Player 4")
players = [player1, player2, player3, player4]
game = Game.new(players)
game.play
