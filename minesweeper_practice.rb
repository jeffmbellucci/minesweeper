class MinesweeperBoard
  attr_accessor :board

  def build_board
    @board = {}
    @size[1].times do |y|
      @size[0].times do |x|
        @board[[x + 1, y + 1]] = Tile.new(self, [x + 1, y + 1])
      end
    end
  #  p @board
    @minecount = 1 if @size == [3,3]
    @minecount = 10 if @size == [9,9]
    @minecount = 40 if @size == [16,16]
    @board.keys.sample(@minecount).each { |mine_tile| @board[mine_tile].set_mine }
  end

  def display_board
    print "\n "
    @board.each do |coord, tile|
      print tile.display_tile + " | \n" + "_" * (@size[0] * 4) +"\n " if coord[0] == @size[0]
      print  tile.display_tile + " | " if coord[0] != @size[0]
    end
  end

  def size_selector
    puts "Please select a board size \n (L)arge (M)edium or (S)mall."
    size_selector = gets.chomp.upcase
    size_selector = case size_selector
    when "L"
      [16,16]
    when "M"
      [9,9]
    when "S"
      [3,3]
    end
  end

  def game_over?
    game_won? || game_lost?
  end

  def game_won?
    num_of_tiles = @size[0] * @size[1]
    num_of_mines = @board.map { |coord, tile| tile.has_mine? }.count(true)
    num_of_revealed = @board.map { |coord, tile| tile.is_revealed? }.count(true)
    return true if num_of_mines + num_of_revealed == num_of_tiles
    false
  end

  def game_lost?
    @board.each { |coord, tile| return true if tile.has_mine? && tile.is_revealed? }
    false
  end


  def play_move(move)
    move = move.split
    @board[[move[1].to_i,move[2].to_i]].reveal  if move.first == "r"
    @board[[move[1].to_i,move[2].to_i]].toggle_flag  if move.first == "f"
  end


  def play_game
    @size = size_selector
    build_board
    puts "Let's begin"
    until game_over?
      display_board
      puts "Choose to reveal using format r x y. \n Choose to flag using format f x y \n (S)ave or (L)oad"
      move = gets.chomp.downcase
      play_move(move)
    end
    display_board
    display_game_end_message
  end

  def display_game_end_message
    puts "\n I'm sorry, you LOST!!" if game_lost?
    puts "\n YOU WIN!!!!!" if game_won?
  end

end





class Tile
  attr_accessor :coord
  def initialize(gameboard, coordinates)
    @coord = coordinates
    @gameboard = gameboard
    @mined = false
    @flagged = false
    @revealed = false
  end

  def set_mine
    @mined = true
  end

  def toggle_flag
    @flagged = @flagged ? false : true
  end

  def reveal(visited = [])
    visited << self
    if adj_mine_count == 0
      adj_tiles.each do |tile|
        #p tile.class
        tile.reveal(visited) unless visited.include?(tile)
      end
    end
    @revealed = true
  end

  def adj_tiles
    output = []
    (-1..1).each do |x_offset|
      #p x_offset
      (-1..1).each do |y_offset|
         if @gameboard.board.include?([@coord[0] + x_offset, @coord[1] + y_offset]) && !(x_offset == 0 && y_offset == 0)
           #puts "Object:#{@gameboard.board[[@coord[0] + x_offset, @coord[1] + y_offset]]}\n coords: #{@gameboard.board[[@coord[0] + x_offset, @coord[1] + y_offset]].coord} "
           output << @gameboard.board[[@coord[0] + x_offset, @coord[1] + y_offset]]
         end
       end
     end
     #p output
     output
   end

   def has_mine?
     @mined
   end

   def is_revealed?
     @revealed
   end


   def adj_mine_count
     adj_tiles.map do |x|
       x.has_mine?
     end.count(true)
   end

   def display_tile
     return "F" if @flagged
     return "*" unless @revealed
     return "M" if @mined
     return adj_mine_count.to_s unless adj_mine_count == 0
     return " " if adj_mine_count == 0


   end

end


john = MinesweeperBoard.new
john.play_game

