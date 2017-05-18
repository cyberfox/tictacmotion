class TicTacToeController < UIViewController
  def viewDidLoad
    each_width = (view.frame.size.width-20)/3

    button = UIButton.buttonWithType(UIButtonTypeCustom)
    button.addTarget(self, action: :'new_game:', forControlEvents: UIControlEventTouchUpInside)
    button.setTitle('New Game', forState: UIControlStateNormal)
    button.frame = CGRectMake(80.0, 20.0, 160.0, 40.0)
    view.addSubview(button)

    segment = UISegmentedControl.alloc.initWithItems(["x", "o", "both"])
    segment.addTarget(self, action: :'human:', forControlEvents:UIControlEventValueChanged)
    segment.selectedSegmentIndex = 2
    segment.frame = CGRectMake(80.0, 475.0, 160.0, 40.0)
    view.addSubview(segment)

    @board = Board.new
    @board_view = UIView.alloc.initWithFrame([[0, 0], [each_width * 3 + 15, each_width * 3 + 15]])
    @board_view.center = view.center
    @board_view.backgroundColor = UIColor.whiteColor

    @moves = []
    [0, 1, 2].each do |row|
      [0, 1, 2].each do |column|
        square = UIView.alloc.initWithFrame([[0, 0], [each_width, each_width]])
        square.center = [5 + row * (each_width + 2.5) + (each_width / 2), 5 + column * (each_width + 2.5) + (each_width / 2)]
        square.backgroundColor = UIColor.blackColor
        square.userInteractionEnabled = true
        @moves << square
        @board_view.addSubview square
      end
    end
    view.addSubview @board_view

    @x_image = UIImage.imageNamed 'x.png'
    @o_image = UIImage.imageNamed 'o.png'
    super
  end

  def viewWillAppear(animated)
    becomeFirstResponder
  end

  def viewDidDisappear(animated)
    super
    resignFirstResponder
  end

  def canBecomeFirstResponder
    true
  end

  def human(sender)
    @ai_piece = 'o' if sender.selectedSegmentIndex == 0
    @ai_piece = 'x' if sender.selectedSegmentIndex == 1
    @ai_piece = nil if sender.selectedSegmentIndex == 2

    make_ai_move if @ai_piece == ['x', 'o'][@board.player]
    check_winner
  end

  def alertView(alertView, didDismissWithButtonIndex:idx)
    reset_board if idx == 0
  end

  def new_game(event)
    reset_board
  end

  def reset_board
    @board = Board.new
    @winLineLayer.removeFromSuperlayer if @winLineLayer
    @winLineLayer = nil

    @moves.each { |square| square.backgroundColor = UIColor.blackColor; square.layer.contents = nil }
    make_ai_move if @ai_piece == 'x'
  end

  def draw_line(squares)
    path = UIBezierPath.bezierPath

    path.moveToPoint [@moves[squares.first].center.x, @moves[squares.first].center.y]
    path.addLineToPoint [@moves[squares.last].center.x, @moves[squares.last].center.y]

    shapeLayer = CAShapeLayer.layer
    shapeLayer.path = path.CGPath
    shapeLayer.lineCap = KCALineCapRound
    shapeLayer.strokeColor = UIColor.blueColor.CGColor
    shapeLayer.lineWidth = 3.0
    shapeLayer.fillColor = UIColor.clearColor.CGColor
    @winLineLayer.removeFromSuperlayer if @winLineLayer
    @winLineLayer = shapeLayer
    @board_view.layer.addSublayer(@winLineLayer)
  end

  def notify(winner)
    won_dialog = UIAlertView.alloc.initWithTitle "#{winner.first} has won!", message:nil, delegate:self, cancelButtonTitle:"New Game?", otherButtonTitles:"Show Board", nil
    draw_line(winner.last)
    won_dialog.show
  end

  def notify_draw
    draw_dialog = UIAlertView.alloc.initWithTitle "It's a draw!", message:nil, delegate:self, cancelButtonTitle:"New Game?", otherButtonTitles:"Show Board", nil
    draw_dialog.show
  end

  def touchesBegan(touches, withEvent:event)
    locationPoint = touches.anyObject.locationInView(self.view)
    touched_view = self.view.hitTest(locationPoint, withEvent:event)
    touched = @moves.index(touched_view)

    if touched
      if @board.available?(touched)
        # If someone'd already won, we don't allow more moves.
        unless @board.winner? || @board.draw?
          touched_view.layer.contents = [@x_image.CGImage, @o_image.CGImage][@board.player]
          @board.move(touched)
        end

        make_ai_move if single_player && !(@board.winner? || @board.draw?)
      end

      check_winner
    end
  end

  def make_ai_move
    move = @board.best_move(@ai_piece)
    touched_view = @moves[move]
    touched_view.layer.contents = [@x_image.CGImage, @o_image.CGImage][@board.player]
    @board.move(move)
  end

  def single_player
    !@ai_piece.nil?
  end

  def check_winner
    winner = @board.winner?
    notify winner if winner
    notify_draw if @board.draw? && !winner
  end

  def motionEnded(motion, withEvent:event)
    reset_board if motion == UIEventSubtypeMotionShake
  end

  def shouldAutorotateToInterfaceOrientation
    false
  end

  def shouldAutorotate
    false
  end
end
