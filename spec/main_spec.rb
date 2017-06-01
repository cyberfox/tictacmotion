describe "Application 'tictac'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it 'has two windows window' do
    @app.windows.size.should == 2
  end

  it 'Does not show a nav bar' do
    @app.windows.first.rootViewController.navigationBar.isHidden.should == true
  end

  it 'should have a TicTacToeController' do
    @app.windows.first.rootViewController.topViewController.class.should == TicTacToeController
  end
end
