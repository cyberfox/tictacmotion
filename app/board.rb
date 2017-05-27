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
  attr_accessor :ai

  def initialize(delegate, ai=nil)
    @board = " "*9
    @player = 0
    @delegate = delegate
    @ai = ai
    ai_move
  end

  def winner?
    WIN_STATES.each do |stack|
      check_value = @board[stack[0]]+@board[stack[1]]+@board[stack[2]]
      return check_value[0].upcase, stack if check_value == 'xxx' || check_value == 'ooo'
    end
    nil
  end

  def find(piece)
    [].tap do |ary|
      @board.each_char.with_index do |ch, idx|
        ary << idx if ch == piece
      end
    end
  end

  def available?(location)
    @board[location] == ' '
  end

  def draw?
    !(@board.include? ' ') && !winner?
  end

  def done?
    winner? || !@board.include?(' ')
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

  def move(location)
    if available?(location) && !done?
      @board[location] = PLAYERS[@player]
      @delegate.move(location, @player)
      @player = 1-@player
      ai_move &:move
    end
    winner = winner?
    @delegate.notify_winner winner if winner
    @delegate.notify_draw if draw? && !winner
  end

  def ai=(piece)
    @ai = piece
    ai_move
  end

  def ai_move
    move (best_move(@ai)) if @ai == ['x', 'o'][player] && !done?
  end
end
