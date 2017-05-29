class TicTacToeController < FullScreenUIViewController
  def viewDidLoad
    each_width = (view.frame.size.width-50)/3
    @board = Board.new(self)
    @moves = []
    squares = squaresView(each_width)
    @boardLayer = squares.layer

    view.addSubview settingsButton
    view.addSubview newGameButton
    view.addSubview boardView
    view.addSubview humanModeSelectors
    view.addSubview squares

    @alert = makeGameOverAlert
    @x_image = UIImage.imageNamed 'x2.png'
    @o_image = UIImage.imageNamed 'o2.png'
    super
  end

  def x_image=(image)
    @x_image = image
    @board.find('x') {|idx| @moves[idx].layer.contents = image.CGImage}
  end

  def o_image=(image)
    @o_image = image
    @board.find('o') {|idx| @moves[idx].layer.contents = image.CGImage}
  end

  def squaresView(each_width)
    UIView.alloc.initWithFrame([[0, 0], [each_width * 3 + 15, each_width * 3 + 15]]).tap do |board_view|
      board_view.center = view.center
      [0, 1, 2].each do |row|
        [0, 1, 2].each do |column|
          nextSquare = square(column, each_width, row)
          @moves << nextSquare
          board_view.addSubview nextSquare
        end
      end
    end
  end

  def square(column, each_width, row)
    square = UIView.alloc.initWithFrame([[0, 0], [each_width, each_width]])
    square.center = [5 + row * (each_width + 2.5) + (each_width / 2), 5 + column * (each_width + 2.5) + (each_width / 2)]
    square.backgroundColor = UIColor.clearColor
    square.userInteractionEnabled = true
    square
  end

  def humanModeSelectors
    UISegmentedControl.alloc.initWithItems(["x", "o", "both"]).tap do |segment|
      segment.addTarget(self, action: :'human:', forControlEvents: UIControlEventValueChanged)
      segment.selectedSegmentIndex = 2
      segment.frame = CGRectMake(80.0, 475.0, 160.0, 40.0)
    end
  end

  def boardView
    UIImageView.new.tap do |imageView|
      side = [view.frame.size.width, view.frame.size.height].min
      imageView.frame = CGRectMake(0, 0, side, side)
      imageView.center = view.center
      imageView.image = UIImage.imageNamed 'board2.png'
    end
  end

  def newGameButton
    UIButton.buttonWithType(UIButtonTypeCustom).tap do |button|
      button.addTarget(self, action: :'new_game:', forControlEvents: UIControlEventTouchUpInside)
      button.setTitle('New Game', forState: UIControlStateNormal)
      button.frame = CGRectMake(80.0, 20.0, 160.0, 40.0)
    end
  end

  def settingsButton
    UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |settingsButton|
      settingsButton.addTarget(self, action: :'config:', forControlEvents: UIControlEventTouchUpInside)
      settingsButton.setImage(UIImage.imageNamed("19-gear.png"), forState: UIControlStateNormal)
      settingsButton.frame = CGRectMake(view.frame.size.width-48.0, 20.0, 52.0, 52.0)
    end
  end

  def makeGameOverAlert
    UIAlertController.alertControllerWithTitle(nil, message: nil, preferredStyle: UIAlertControllerStyleAlert).tap do |alert|
      newGame = UIAlertAction.actionWithTitle('New Game', style: UIAlertActionStyleDefault, handler: method(:new_game))
      showBoard = UIAlertAction.actionWithTitle('Show Board', style: UIAlertActionStyleDefault, handler: nil)

      alert.addAction(newGame)
      alert.addAction(showBoard)
    end
  end

  def config(sender)
    @tableview ||= ImageSelectionController.new
    self.navigationController.pushViewController(@tableview, animated:true)
  end

  def human(sender)
    @board.ai = ['o', 'x'][sender.selectedSegmentIndex]
  end

  def new_game(event)
    @alert.dismissViewControllerAnimated(true, completion: nil)
    @moves.each { |square| square.backgroundColor = UIColor.clearColor; square.layer.contents = nil }
    @winLineLayer.removeFromSuperlayer if @winLineLayer
    @winLineLayer = nil

    @board = Board.new(self, @board.ai)
  end

  def show_board(event)
    @alert.dismissViewControllerAnimated(true, completion: nil)
  end

  def shapeLayer(path)
    (@shapeLayer ||= CAShapeLayer.layer.tap do |shapeLayer|
      shapeLayer.lineCap = KCALineCapRound
      shapeLayer.strokeColor = UIColor.blueColor.CGColor
      shapeLayer.lineWidth = 3.0
      shapeLayer.fillColor = UIColor.clearColor.CGColor
    end).tap do |sl|
      sl.path = path.CGPath
    end
  end

  def draw_line(squares)
    path = UIBezierPath.bezierPath

    path.moveToPoint [@moves[squares.first].center.x, @moves[squares.first].center.y]
    path.addLineToPoint [@moves[squares.last].center.x, @moves[squares.last].center.y]

    @winLineLayer.removeFromSuperlayer if @winLineLayer
    @winLineLayer = shapeLayer(path)
    @boardLayer.addSublayer(@winLineLayer)
  end

  def gameOverAlert(title)
    @alert.title = title
    self.presentViewController(@alert, animated:true, completion: nil)
  end

  def notify_winner(winner)
    draw_line(winner.last)
    gameOverAlert "#{winner.first} has won!"
  end

  def notify_draw
    gameOverAlert "It's a draw!"
  end

  def move(where, who)
    touched_view = @moves[where]
    touched_view.layer.contents = [@x_image.CGImage, @o_image.CGImage][who]
  end

  def touchesBegan(touches, withEvent:event)
    locationPoint = touches.anyObject.locationInView(self.view)
    touched_view = self.view.hitTest(locationPoint, withEvent:event)
    touched = @moves.index(touched_view)

    @board.move touched if touched
  end

  def motionEnded(motion, withEvent:event)
    new_game(event) if motion == UIEventSubtypeMotionShake
  end

  def canBecomeFirstResponder
    true
  end

  def shouldAutorotateToInterfaceOrientation
    false
  end

  def shouldAutorotate
    false
  end
end
