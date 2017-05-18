class Board
  PLAYERS = ['x', 'o']
  WIN_STATES = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
  ]

  attr_reader :player
  def initialize
    @board = " "*9
    @player = 0
  end

  def winner?
    WIN_STATES.each do |stack|
      check_value = @board[stack[0]]+@board[stack[1]]+@board[stack[2]]
      return check_value[0].upcase, stack if check_value == 'xxx' || check_value == 'ooo'
    end
    nil
  end

  def available?(location)
    @board[location] == ' '
  end

  def move(location)
    @board[location] = PLAYERS[@player]
    @player = 1-@player
  end

  def draw?
    !(@board.include? ' ') && !winner?
  end

  def best_move(piece)
    enemy = piece == 'x' ? 'o' : 'x'
    WIN_STATES.each do |stack|
      check_value = @board[stack[0]]+@board[stack[1]]+@board[stack[2]]
      return stack[0] if check_value == " #{piece}#{piece}"
      return stack[1] if check_value == "#{piece} #{piece}"
      return stack[2] if check_value == "#{piece}#{piece} "
    end

    WIN_STATES.each do |stack|
      check_value = @board[stack[0]]+@board[stack[1]]+@board[stack[2]]
      return stack[0] if check_value == " #{enemy}#{enemy}"
      return stack[1] if check_value == "#{enemy} #{enemy}"
      return stack[2] if check_value == "#{enemy}#{enemy} "
    end

    corners = [0, 2, 6, 8].select {|idx| @board[idx] == ' '}
    return corners.sample unless corners.empty?

    [1, 3, 4, 5, 7].select {|idx| @board[idx] == ' '}.sample
  end
end
