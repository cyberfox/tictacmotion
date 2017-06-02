describe 'Board' do
  before do
    @delegate = Object.new
    @board = Board.new(@delegate)
  end

  context 'A won game' do
    before do
      def @delegate.winner
        @winner
      end
      def @delegate.move(where, who)
      end
      def @delegate.notify_winner(who)
        @winner = who
      end
      @board.move 0
      @board.move 1
      @board.move 4
      @board.move 8
      @board.move 6
      @board.move 3
      @board.move 2
    end

    it 'should result in a known board' do
      @board.instance_variable_get(:@board).should == 'xoxox x o'
    end

    it 'should show X as winner' do
      @delegate.winner.first.should == 'X'
    end

    it 'should show 2, 4, 6 as the win line' do
      @delegate.winner.last.should == [2, 4, 6]
    end
  end
end
