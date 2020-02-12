--[[
Welcome to your third assignment! By now, we’ve gotten our feet wet with states, randomization, and much more; this time, 
we’ll be diving in a little bit more and adding some new features entirely!

! Your goals this assignment:


Todo Add a Powerup class to the game that spawns a powerup 
(images located at the bottom of the sprite sheet in the distribution code). 
* This Powerup should spawn randomly, be it on a timer or when the Ball hits a Block enough times, and 
gradually descend toward the player. Once collided with the Paddle, two more Balls should spawn and behave 
identically to the original, including all collision and scoring points for the player. Once the player wins and 
proceeds to the VictoryState for their current level, the Balls should reset so that there is only one active again.


todo Grow and shrink the Paddle such that it’s no longer just one fixed size forever. 
In particular, the Paddle should shrink if the player loses a heart (but no smaller of course than the smallest paddle size) 
and should grow if the player exceeds a certain amount of score (but no larger than the largest Paddle). This may not make the game 
completely balanced once the Paddle is sufficiently large, but it will be a great way to get comfortable interacting with 
Quads and all of the tables we have allocated for them in main.lua!


todo Add a locked Brick (located in the sprite sheet) to the level spawning, as well as a key powerup 
(also in the sprite sheet). The locked Brick should not be breakable by the ball normally, unless they of course 
have the key Powerup! The key Powerup should spawn randomly just like the Ball Powerup and descend toward the bottom 
of the screen just the same, where the Paddle has the chance to collide with it and pick it up. You’ll need to take 
a closer look at the LevelMaker class to see how we could implement the locked Brick into the level generation. 
Not every level needs to have locked Bricks; just include them occasionally! Perhaps make them worth a lot more 
points as well in order to compel their design. Note that this feature will require changes to several parts of 
the code, including even splitting up the sprite sheet into Bricks!

todo add a sound of unlocking a locked block
todo add a particle effects after unlocking a locked block w/ key
todo add more scores when destroying a locked block w/ key
todo add a sound when hitting blocked block

! BUG TO FIX: after reaching 5000 score you will always get extra heart
* Objectives
- Read and understand all of the Breakout source code from Lecture 1.
- Add a powerup to the game that spawns two extra Balls.
- Grow and shrink the Paddle when the player gains enough points or loses a life.
- Add a locked Brick that will only open when the player collects a second new powerup, a key, 
  which should only spawn when such a Brick exists and randomly as per the Ball powerup.

]]