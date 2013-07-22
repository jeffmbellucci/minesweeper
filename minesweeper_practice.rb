class MinesweeperBoard
  attr_accessor :board

  def initialize(size)
    @size = size
    build_board

  end

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

   def adj_mine_count
     adj_tiles.map do |x|
       x.has_mine?
     end.count(true)
   end

   def display_tile
     return "*" unless @revealed
     return "M" if @mined
     return adj_mine_count.to_s unless adj_mine_count == 0
     return " " if adj_mine_count == 0
     return "F" if @flagged

   end

end


joe = MinesweeperBoard.new([9,9])
#joe.board.each {|key, val| val.reveal}
#joe.board[[1,2]].set_mine
joe.board[[1,2]].reveal
 joe.display_board
