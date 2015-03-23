class TicTacToeController < UIViewController
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

  def viewDidLoad
    each_width = (view.frame.size.width-20)/3

    @board = " "*9
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
#    @board_view.userInteractionEnabled = false
    view.addSubview @board_view
#    view.userInteractionEnabled = false

    @x_image = UIImage.imageNamed 'x.png'
    @o_image = UIImage.imageNamed 'o.png'
    @is_x = true
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

  def notify
    UIAlertController.alert(self, 'This is happening, OK?', buttons: ['Cancel', 'Kill it!', 'Uh, what?']
      ) do |button|
      # button is 'Cancel', 'Kill it!' or 'Uh, what?'
    end
  end

  def touchesBegan(touches, withEvent:event)
    NSLog "Got event: %@", event
    locationPoint = touches.anyObject.locationInView(self.view)
    NSLog "Got location: %@", locationPoint
    touched_view = self.view.hitTest(locationPoint, withEvent:event)
    touched = @moves.index(touched_view)
    if touched
#    touched_view.backgroundColor = UIColor.blueColor
      touched_view.layer.contents = @is_x ? @x_image.CGImage : @o_image.CGImage
      @board[touched] = @is_x ? 'x' : 'o'
      # Check to see if anyone won the game.
      # notify if @board[0..2] == 'xxx'
      @is_x = !@is_x
    end
  end

  def motionEnded(motion, withEvent:event)
    if motion == UIEventSubtypeMotionShake
      @board = " "*9
      @moves.each { |square| square.backgroundColor = UIColor.blackColor; square.layer.contents = nil }
      @is_x = true
    end
  end

  def shouldAutorotateToInterfaceOrientation
    false
  end

  def shouldAutorotate
    false
  end
end
