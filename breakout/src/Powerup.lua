--[[
    GD50
    Breakout Remake

    -- Powerup Class --

    Author: Nek0pi
    github.com/nek0pi

    Represents different powerups that will spawn at random/specific conditions
    and give the player different bonuses/perks.
]]
Powerup = Class{}

function Powerup:init(skin, x, y, dy)
    -- simple positional and dimensional variables
    self.width = 16
    self.height = 16
    self.x = x
    self.y = y

    -- these variable is for keeping track of our velocity on Y axis, 
    -- since the powerup can only move in one dimension
    self.dy = dy

    -- used to determine whether this Powerup should be rendered
    self.inPlay = true

    -- this will effectively be the skin of our powerup, and we will index
    -- our table of Quads relating to the global block texture using this
    self.skin = skin
end

--[[
    Expects an argument with a paddle,
    and returns true if the paddle and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:consumes()
    if self.inPlay then
        self.inPlay = false
        -- todo remove debug
        print("You got a powerup!")
        gSounds['powerup']:stop()
        gSounds['powerup']:play()
    end
    
    
end

function Powerup:update(dt)
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    if self.inPlay then
    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
        love.graphics.draw(gTextures['main'], gFrames['powerup'][self.skin],
            self.x, self.y)
    end
end