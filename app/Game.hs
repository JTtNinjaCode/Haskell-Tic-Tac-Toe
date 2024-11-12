module Game where

import Data.Array

-- two-dimensional array of cells, keep track of the every cell's state
type Board = Array (Int, Int) Cell

data Player = PlayerX | PlayerO deriving (Eq, Show)

-- cell can be empty or filled with a player
data Cell = Empty | Full Player deriving (Eq, Show)

-- game state can be running or game over with a winner or tie
data State = Running | GameOver (Maybe Player) deriving (Eq, Show)

data Game = Game
  { gameBoard :: Board,
    gamePlayer :: Player,
    gameState :: State
  }
  deriving (Eq, Show)

n :: Int
n = 3

screenWidth, screenHeight :: Int
screenWidth = 640
screenHeight = 640

screenPosX, screenPosY :: Int
screenPosX = 100
screenPosY = 100

cellWidth, cellHeight :: Float
cellWidth = fromIntegral screenWidth / fromIntegral n
cellHeight = fromIntegral screenHeight / fromIntegral n

-- initial game state, it will be updated during the game and generate new game states
initialGame :: Game
initialGame =
  Game
    { gameBoard =
        (array indexRange $ zip (range indexRange) (cycle [Empty])),
      gamePlayer = PlayerX, -- start as PlayerX
      gameState = Running
    }
  where
    indexRange = ((0, 0), (n - 1, n - 1))
