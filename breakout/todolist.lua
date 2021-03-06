--[[
Welcome to your third assignment! By now, we’ve gotten our feet wet with states, randomization, and much more; this time, 
we’ll be diving in a little bit more and adding some new features entirely!

? Need to have BetterComments plugin to make comments look a bit more bright
! Your goals this assignment:


// Add a Powerup class to the game that spawns a powerup with a chance
(images located at the bottom of the sprite sheet in the distribution code). 
* This Powerup should spawn randomly, be it on a timer or when the Ball hits a Block enough times, and 
gradually descend toward the player. Once collided with the Paddle, two more Balls should spawn and behave 
identically to the original, including all collision and scoring points for the player. Once the player wins and 
proceeds to the VictoryState for their current level, the Balls should reset so that there is only one active again.

// make powerup to be gone after it's collision with paddle
// create a separate class for powerups
//todo add a table containing ball objects
//todo change all self.ball occurences to use objects from table
?todo when balls collide they should behave like colliding a brick 
?todo I could do number of balls limitation?
//todo spawn 2 more balls from the paddle (less problems with this approach)
//todo change mechanic of loose (add a counter to count number of balls)

//todo make powerup object spawn at a block y and x
//todo add a sound when it collides with the player
// make it decent toward the player (dy = value)
// add a quad for powerups (add it to gFrames and gTexture)

// / Grow and shrink the Paddle such that it’s no longer just one fixed size forever. 
In particular, the Paddle should shrink if the player loses a heart (but no smaller of course than the smallest paddle size) 
and should grow if the player exceeds a certain amount of score (but no larger than the largest Paddle). This may not make the game 
completely balanced once the Paddle is sufficiently large, but it will be a great way to get comfortable interacting with 
Quads and all of the tables we have allocated for them in main.lua!


//TODO / Add a locked Brick (located in the sprite sheet) to the level spawning, as well as a key powerup 
(also in the sprite sheet). The locked Brick should not be breakable by the ball normally, unless they of course 
have the key Powerup! The key Powerup should spawn randomly just like the Ball Powerup and descend toward the bottom 
of the screen just the same, where the Paddle has the chance to collide with it and pick it up. You’ll need to take 
a closer look at the LevelMaker class to see how we could implement the locked Brick into the level generation. 
Not every level needs to have locked Bricks; just include them occasionally! Perhaps make them worth a lot more 
points as well in order to compel their design. Note that this feature will require changes to several parts of 
the code, including even splitting up the sprite sheet into Bricks!

//todo add a special sound of destroing an unlocked block
//todo add more points for destroying unlocked block
//todo remove key powerup from spawning if the map doesn't have any locked bricks
//todo add a particle effects after unlocking a locked block w/ key
//todo add a sound when hitting blocked block

//Add different backgrounds
? Game Could feature AI
//Adding debug keys to activate powerups 

// BUG TO FIX: after reaching 5000 score you will always get extra heart
// Just attach recoverPoints to the state after lose

* Objectives
* Read and understand all of the Breakout source code from Lecture 1.
* Add a powerup to the game that spawns two extra Balls.
* Finished Grow and shrink the Paddle when the player gains enough points or loses a life.
* Add a locked Brick that will only open when the player collects a second new powerup, a key, 
  which should only spawn when such a Brick exists and randomly as per the Ball powerup.

]]