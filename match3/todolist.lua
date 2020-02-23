--[[
Welcome to your fourth assignment! 
There was a lot to learn with timers, tweens, and more in this lecture, but unfortunately, 
our game is still lacking in a few areas. By extending its functionality, 
we’ll have something even closer to famous titles such as Bejeweled and Candy Crush Saga!

! Use a better comments to see this todolist correctly 
Your goals this assignment:

//Implement time addition on matches, such that scoring a match extends the timer by 1 second per 
tile in a match. This one will probably be the easiest! Currently, there’s code that calculates the 
amount of points you’ll want to award the player when it calculates any matches in PlayState:calculateMatches, so start there!

* Level 1 = blocks w/o figures, 4 colors
* Level 2 = blocks w/ figures 5 colors
* Level 3 = additional figures 6 colors etc... till 8

? Only draw tiles that are odd numbers on a main tile png to make colors look more distant

//Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), 
with later levels generating the blocks with patterns on them (like the triangle, cross, etc.). 
These should be worth more points, at your discretion. This one will be a little trickier than the last 
step (but only slightly); right now, random colors and varieties are chosen in Board:initializeTiles, 
but perhaps we could pass in the level variable from the PlayState when a Board is created (specifically in PlayState:enter), 
and then let that influence what variety is chosen?

    //todo change the variety of skins depending on a level +
    //todo change the scores you get when matching these block +
    //todo make it possible to easily trace the skin of the block - working with matches +


//Create random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row. 
This one will require a little more work! We’ll need to modify the Tile class most likely to hold some 
kind of flag to let us know whether it’s shiny and then test for its presence in Board:calculateMatches!

    //todo draw a bomb on a special tile
    //todo make a different sound when you match with a special tile
    //todo make the whole row be added to match when this speacial tile is matched
    todo add a particle effects when the whole row is going out. 
    ?Make it a laser? Make it a dissapear? use the timer to make it dissapear w/ cool particle effects?
    //todo make it spawn only with a rare possibility


//Only allow swapping when it results in a match. If there are no matches available to perform, reset the board. 
There are multiple ways to try and tackle this problem; choose whatever way you think is best! The simplest is 
probably just to try and test for Board:calculateMatches after a swap and just revert back if there is no match! 


todo ------>
The harder part is ensuring that potential matches exist;  
for this, the simplest way is most likely to pretend swap everything left, 
right, up, and down, using essentially the same reverting code as just above! 
However, be mindful that the current implementation uses all of the blocks in the sprite sheet, 
which mathematically makes it highly unlikely we’ll get a board with any viable matches in the 
first place; in order to fix this, be sure to instead only choose a subset of tile colors to spawn 
in the Board (8 seems like a good number, though tweak to taste!) before implementing this algorithm!

    //shrink down used colors
    //make tiles revert if they are no matches made by the move

    todo Make calculations about whether there are potential matches.

    // Make levels gradually more difficult (include more colors, start with 3 and then add 1 more each level) + 



*(Optional) Implement matching using the mouse. (Hint: you’ll need push:toGame(x,y); 
see the push library’s documentation here for details! This one’s fairly self-explanatory; 
feel free to implement click-based, drag-based, or both for your application! 
This one’s only if you’re feeling up for a bonus challenge :) Have fun!


//Add some more backgrounds - let them change when going to the next level
// Add Nekopi Edition in main menu


*Objectives
//Read and understand all of the Match-3 source code from Lecture 3.
//Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match.
//Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), with later levels generating the blocks 
//with patterns on them (like the triangle, cross, etc.). These should be worth more points, at your discretion.
//Creat random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row.
Only allow swapping when it results in a match. If there are no matches available to perform, reset the board.
(Optional) Implement matching using the mouse. (Hint: you’ll need push:toGame(x,y); 
see the push library’s documentation here for details!

]]