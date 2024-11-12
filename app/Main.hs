module Main where

import Game
import Graphics.Gloss
import Logic
import Rendering

window :: Display
window = InWindow "Functional" (screenWidth, screenHeight) (screenPosX, screenPosY)

backgroundColor :: Color
backgroundColor = makeColorI 0 0 0 255

main :: IO ()
main = play window backgroundColor 30 initialGame gameAsPicture transformGame (const id)
