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
    view.addSubview @board_view

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

  def alertView(alertView, didDismissWithButtonIndex:idx)
    reset_board
  end

  def reset_board
    @board = " "*9
    @moves.each { |square| square.backgroundColor = UIColor.blackColor; square.layer.contents = nil }
    @is_x = true
  end

  def notify(winner)
    won_dialog = UIAlertView.alloc.initWithTitle "#{winner} has won!",
                                                 message:nil, delegate:self, cancelButtonTitle:"New Game?", otherButtonTitles:nil
    won_dialog.show
    # UIAlertController.alert(self, 'This is happening, OK?', buttons: ['Cancel', 'Kill it!', 'Uh, what?']
    #   ) do |button|
    #   button is 'Cancel', 'Kill it!' or 'Uh, what?'
    # end
  end

  def notify_draw
    draw_dialog = UIAlertView.alloc.initWithTitle "It's a draw!", message:nil, delegate:self, cancelButtonTitle:"New Game?", otherButtonTitles:"Show Board", nil
    draw_dialog.show
  end

  def win_test
    WIN_STATES.each do |stack|
      check_value = @board[stack[0]]+@board[stack[1]]+@board[stack[2]]
      return check_value[0] if check_value == 'xxx' || check_value == 'ooo'
    end
    nil
  end

  def touchesBegan(touches, withEvent:event)
    locationPoint = touches.anyObject.locationInView(self.view)
    touched_view = self.view.hitTest(locationPoint, withEvent:event)
    touched = @moves.index(touched_view)
    if touched && @board[touched] == ' '
      # If someone'd already won, we don't allow more moves.
      return if win_test

      touched_view.layer.contents = @is_x ? @x_image.CGImage : @o_image.CGImage
      @board[touched] = @is_x ? 'x' : 'o'

      # Check to see if anyone won the game after this move.
      winner = win_test
      notify(winner.upcase) unless winner.nil?
      notify_draw unless @board.include? ' '
      @is_x = !@is_x
    end
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
