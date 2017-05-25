class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    nav = UINavigationController.new
    nav.navigationBar.hidden = true

    tictac = TicTacToeController.new
    nav.addChildViewController(tictac)

    @window.rootViewController = nav
    @window.makeKeyAndVisible
    true
  end
end

class FullScreenUIViewController < UIViewController
  attr_accessor :delegate

  def viewWillAppear(animated)
    self.navigationController.setNavigationBarHidden(true, animated:animated)
    becomeFirstResponder

    super
  end

  def viewDidDisappear(animated)
    self.navigationController.setNavigationBarHidden(false, animated:animated)
    resignFirstResponder
    super
  end
end
