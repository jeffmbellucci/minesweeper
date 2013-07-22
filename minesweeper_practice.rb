class MinesweeperBoard
  def initialize(size)
    @size = size
    build_board

  end

  def build_board
    @board = {}
    size[0].times do |x|
      size[1].times do |y|
        @board[[x + 1, y + 1]] = Tile.new(@board)
      end
    end
    @minecount = 1 if size = [3,3]
    @minecount = 10 if size == [9,9]
    @minecount = 40 if size == [16,16]
    @board.keys.sample(@minecount) { |mine_tile| @board[mine_tile].set_mine }
  end

  def display_board
    @board.each do |coord, tile|
      print Tile.to_s + "\n " if coord[0] == size[0]
      print  Tile.to_s if coord[0] != size[0]
    end
  end

end

class Tile
  def initialize(board)
    @board = board
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

  def reveal
  end

  def adj_tiles
  end

end

