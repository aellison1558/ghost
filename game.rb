require_relative 'human_player'
class Game
  GHOST = "GHOST"
  MAX_LOSSES = 5
  attr_accessor :fragment, :players
  def initialize(*players)
    @players = players
    @fragment = ""
    @dictionary = File.readlines("dictionary.txt")
    @dictionary = @dictionary.map {|word| word.chomp}
    @start_player = {player: @players[0], pos: 0}
    @losses = {}
    @players.each do |player|
      @losses[player] = 0
    end

  end

  def next_player!
    @players.rotate!
  end

  # def switch_starter!
  #   gap = @players.index(@start_player[:player]) - @start_player[:pos]
  #   @players.rotate!(gap + 1)
  #   @start_player[:player] = @players.first
  #   if @start_player[:pos] < @players.length - 1
  #     @start_player[:pos] += 1
  #   else
  #     @start_player[:pos] = 0
  #   end
  # end

  def valid_play?(string)
    return false unless ("a".."z").include?(string)
    @dictionary.any? do |word|
      word.include?(@fragment + string)
    end
  end

  def take_turn(player)
    guess = player.guess(@fragment)
    while !valid_play?(guess)
      guess = player.alert_invalid_guess
    end
    @fragment += guess
  end

  def play_round
    while !won?
      if @losses[@players.first] < MAX_LOSSES
        take_turn(@players.first)
      end
      next_player!
    end
    @losses[@players.last] += 1
  end

  def lost
    if lost?(@players.last)
      puts "#{@players.last.name} has lost!"
      @players.pop
    end
  end

  def won?
    @dictionary.include?(@fragment)
  end

  def lost?(player)
    @losses[player] == MAX_LOSSES
  end

  def game_over?
    @players.length == 1
  end

  def play
    while !game_over?
      play_round
      @fragment = ""
      lost
      # switch_starter!
      display_status
    end
    puts "#{@players[0].name} won!"
  end

  def record(player)
    if @losses[player] == 0
    else
      GHOST[0..(@losses[player] - 1)]
    end
  end

  def display_status
    return false if @losses.all? {|key, value| value == 0}
    @players.each do |player|
      if @losses[player] > 0
        puts "#{player.name} has #{record(player)}"
      end
    end
    puts "#{@start_player[:player].name} starting"
  end


end

dictionary = File.readlines("dictionary.txt")
dictionary = dictionary.map {|word| word.chomp}
player1 = HumanPlayer.new("Player 1")
player2 = HumanPlayer.new("Player 2")
player3 = HumanPlayer.new("Player 3")
player4 = HumanPlayer.new("Player 4")
game = Game.new(player1, player2, player3, player4)
game.play
