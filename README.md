# Chess
A cli implementation of the chess game.

Chess is a simple player versus player game.

Created for personal learning purposes.

So far this has been the biggest project I've made so far. The creation process was made possible by minor appliance of OOP concepts, testing and especially planning. My negligence for planning has taught me a big lesson in how important it is for big projects such as this. Testing has made the development process much easier than it could have been, the ability to spot issues early on and being very useful for refactoring some of the code made this project doable. Regarding the OOP concepts, I've gotten a chance to refresh my knowledge on concepts like inheritance and SOLID although I've still got much to learn.

## Running the application
  ### Prerequisites
  - Ruby 3.0.X
  - rspec gem if you wish to run tests.
  ###
  * Clone the repository `git clone git@github.com:Asmenys/Chess.git`
  * `cd` into the `lib` folder of the project.
  * run `irb` and then run `require_relative 'load_game.rb'
    * If you wish to play a standart chess starting layout
      * run `Load_game.new.game.game_loop`
    * If you wish to use a starting position of your own
      * You will need to load the game using a fen string
        * `Load_game.new("your_fen_string").game.game_loop`
        
