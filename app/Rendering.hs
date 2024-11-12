module Rendering where

import qualified Data.Array as Ary
import Game
import Graphics.Gloss

playerXColor, playerOColor, tieColor, gridColor :: Color
playerXColor = makeColorI 255 50 50 255
playerOColor = makeColorI 50 100 255 255
tieColor = makeColorI 255 255 255 255
gridColor = makeColorI 255 255 255 255

-- get the color depending on the winner (or tie)
outcomeColor :: Maybe Player -> Color
outcomeColor Nothing = tieColor
outcomeColor (Just PlayerX) = playerXColor
outcomeColor (Just PlayerO) = playerOColor

-- snap a picture to the big picture depending on the cell index
snapPictureToCell :: Picture -> (Int, Int) -> Picture
snapPictureToCell cellPicture (row, column) =
  translate x y cellPicture -- move the picture to the cell
  where
    x = fromIntegral column * cellWidth + cellWidth * 0.5
    y = fromIntegral row * cellHeight + cellHeight * 0.5

cellsOfBoard :: Board -> Cell -> Picture -> Picture
cellsOfBoard board cell cellPicture =
  pictures $ -- combine multiple pictures into one
    map (snapPictureToCell cellPicture . fst) $
      filter (\(_, e) -> e == cell) $ -- filter out the cells that equal to the expected cell
        Ary.assocs board -- transform the board into a list of cells

-- draw a cross at the origin
xCell :: Picture
xCell = pictures [rotate 45.0 $ rectangleSolid side 10.0, rotate (-45.0) $ rectangleSolid side 10.0]
  where
    side = min cellWidth cellHeight * 0.8

-- draw a circle at the origin
oCell :: Picture
oCell = thickCircle radius 10.0
  where
    radius = min cellWidth cellHeight * 0.4

-- draw cross to the picture
xCellOfBoard :: Board -> Picture
xCellOfBoard board = cellsOfBoard board (Full PlayerX) xCell

-- draw circles to the picture
oCellOfBoard :: Board -> Picture
oCellOfBoard board = cellsOfBoard board (Full PlayerO) oCell

-- draw grid lines to the picture
boardGrid :: Picture
boardGrid = pictures $ verticalLines ++ horizontalLines
  where
    verticalLines = map (\i -> line [(i * cellWidth, 0), (i * cellWidth, fromIntegral screenHeight)]) [0 .. fromIntegral n]
    horizontalLines = map (\i -> line [(0, i * cellHeight), (fromIntegral screenWidth, i * cellHeight)]) [0 .. fromIntegral n]

boardAsRunningPicture :: Board -> Picture
boardAsRunningPicture board = pictures [color playerXColor $ xCellOfBoard board, color playerOColor $ oCellOfBoard board, color gridColor $ boardGrid]

boardAsGameOverPicture :: Maybe Player -> Board -> Picture
boardAsGameOverPicture winner board = color (outcomeColor winner) (boardAsPicture board)

-- combine all the pictures (O, X and Grid) into one
boardAsPicture :: Board -> Picture
boardAsPicture board = pictures [xCellOfBoard board, oCellOfBoard board, boardGrid]

gameAsPicture :: Game -> Picture
gameAsPicture game = translate (fromIntegral screenWidth * (-0.5)) (fromIntegral screenHeight * (-0.5)) resultPicture
  where
    resultPicture = case gameState game of
      Running -> boardAsRunningPicture (gameBoard game)
      GameOver winner -> boardAsGameOverPicture winner (gameBoard game)
