class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    nav = UINavigationController.new
    nav.navigationBar.hidden = true

    tictac = TicTacToeController.new

    @window.rootViewController = nav
    @window.rootViewController.addChildViewController(tictac)
    @window.makeKeyAndVisible
    true
  end
end
