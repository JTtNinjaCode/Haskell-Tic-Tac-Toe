module Logic where

import Data.Array
import Game
import Graphics.Gloss.Interface.Pure.Game

mousePosToRelativePos :: (Fractional a) => (a, a) -> (a, a)
mousePosToRelativePos (x, y) = (x + fromIntegral screenWidth * 0.5, y + fromIntegral screenHeight * 0.5)

mousePosToCellIndex :: (Float, Float) -> (Int, Int)
mousePosToCellIndex (x, y) = (row, column)
  where
    (relativeX, relativeY) = mousePosToRelativePos (x, y)
    column = floor $ relativeX / cellWidth
    row = floor $ relativeY / cellHeight

switchPlayer :: Player -> Player
switchPlayer PlayerX = PlayerO
switchPlayer PlayerO = PlayerX

isCellEmpty :: (Int, Int) -> Game -> Bool
isCellEmpty cellIndex game = (gameBoard game ! cellIndex) == Empty

updateBoard :: (Int, Int) -> Game -> Board
updateBoard cellIndex game = gameBoard game // [(cellIndex, Full $ gamePlayer game)]

checkGameOver :: Board -> Player -> State
checkGameOver board player
  | any (all (== Full player)) rows = GameOver (Just player) -- if any row is full of the same player, then game over
  | any (all (== Full player)) columns = GameOver (Just player) -- if any column is full of the same player, then game over
  | all (\i -> board ! (i, i) == Full player) [0 .. n - 1] = GameOver (Just player) -- if the diagonal from top-left to bottom-right is full of the same player, then game over
  | all (\i -> board ! (i, n - 1 - i) == Full player) [0 .. n - 1] = GameOver (Just player) -- if the diagonal from top-right to bottom-left is full of the same player, then game over
  | all (\cell -> cell /= Empty) $ map snd (assocs board) = GameOver Nothing -- if all cells are filled, then game over with a tie
  | otherwise = Running
  where
    rows = [[board ! (i, j) | j <- [0 .. n - 1]] | i <- [0 .. n - 1]]
    columns = [[board ! (j, i) | j <- [0 .. n - 1]] | i <- [0 .. n - 1]]

playerTurn :: Game -> (Int, Int) -> Game
playerTurn game cellIndex
  | gameState game /= Running = game
  | not $ isCellEmpty cellIndex game = game
  | otherwise = Game {gameBoard = newBoard, gamePlayer = newPlayer, gameState = newState}
  where
    newBoard = updateBoard cellIndex game
    newState = checkGameOver newBoard $ gamePlayer game
    newPlayer = switchPlayer $ gamePlayer game

-- depend on the input event(mouse click), transform the game state to new state
transformGame :: Event -> Game -> Game
transformGame (EventKey (MouseButton LeftButton) Up _ mousePos) game =
  case gameState game of
    Running -> playerTurn game $ mousePosToCellIndex mousePos
    GameOver _ -> initialGame
transformGame _ game = game
