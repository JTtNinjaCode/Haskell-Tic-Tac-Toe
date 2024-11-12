# Tic-Tac-Toe Game in Haskell

This is a simple Tic-Tac-Toe game implemented in Haskell, using Gloss for graphics. Players can click on cells to alternate between "X" and "O", creating an interactive experience directly through mouse clicks.

## Features

- **Alternating Turns**: Each click switches between "X" and "O" players.
- **Mouse Interaction**: Click on any cell to mark it with "X" or "O".
- **Winning Detection**: The game detects a win or tie automatically.
- **Grid Display**: A clean grid layout that visually separates each cell.

## Getting Started

### Prerequisites

- Haskell (GHC) installed on your system.
- [Gloss](http://hackage.haskell.org/package/gloss) library for graphics:

```bash
cabal update
cabal install gloss
```
### Steps to Run the Game
1. Clone the repository to your local machine using git:

```bash
git clone https://github.com/JTtNinjaCode/Haskell-Tic-Tac-Toe.git
cd Haskell-Tic-Tac-Toe
```

2. Build the project using cabal to compile the source code:

```bash
cabal build
```

3. Run the game using the following command:

```bash
cabal run
```

A window will open where you can start playing the Tic-Tac-Toe game by clicking on the cells.
### Code Overview
The code is divided into three main modules:

- Game: Contains data structures representing the game state.
- Logic: Manages game rules, turn-switching, and winning conditions.
- Rendering: Handles graphics and the visual representation of the game.

