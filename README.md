# Chess

A simple CLI implementation of the notorious board game Chess in ruby.

 ## How to play
 1. Clone the repository.
 2. Execute script.rb for further instructions or simply execute it with the `-p` flag i.e `ruby script.rb -p`.
 3. Enjoy.

### Features
## Core
 - Chess checks: Prevents any moves that would leave the king under a check as such moves are illegal.
 - Captures: Removes pieces if they are attacked by an enemy.
 - Resign: Resign/Exit the game.
 - Draw: Propose a draw, upon both parties agreeing to the draw ends the game.
 
 **SPECIAL**
 - Option parser: parse arguments sent from the terminal.
 - The board: The board is flipped upside down, this is a feature, not a mistake.
 - Pawn Jumps: Pawn pieces may jump two cells if possible.
 - Promotions: Pawns may promote to other pieces if conditions are right.
 - Castling: Kings may castle with either left or right rook if conditions are right.
 - En Passant: Pawns may be captured after a double jump.

 

