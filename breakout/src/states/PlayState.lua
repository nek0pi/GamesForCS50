--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    * Author: Colton Ogden
    cogden@cs50.harvard.edu

    * Remaker: Nek0pi
    github.com/nek0pi

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores

    self.level = params.level
    -- Bug with recoverpoints Fixed
    self.recoverPoints = params.recoverPoints

    -- Size of the paddle 
    self.paddle.size = params.paddlesize

    self.hasfoundakey = params.key

    --
    -- !Balls Related stuff
    --
    -- table containing all balls
    self.balltable = {}
    -- Putting there the first ball
    table.insert(self.balltable, params.ball)

    -- give first ball random starting velocity
    self.balltable[1].dx = math.random(-200, 200)
    self.balltable[1].dy = math.random(-60, -80)

    -- counter for balls to keep track
    self.ballcounter = 1
    --
    --

    --
    -- !PowerUp Related stuff
    --
    --table containing all balls
    self.powers = {}
    -- counter of how many times did ball hit a brick  
    self.counterhits = 0

    -- variable to show if locked brick was created (to spawn keypowerup) 
    self.lockedcreated = lockedcreated
    --
    

end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)

    --!Balls update
    for b, ball in pairs(self.balltable) do
         
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end

        ball:update(dt)
    end

    -- ! Temporary debug commands to help test the game
    --
    -- Add 2 more balls
    if love.keyboard.wasPressed('b') then 
        for i=1,2 do
            table.insert(self.balltable, Ball(math.random(7)))
            self.ballcounter = self.ballcounter + 1
            self.balltable[self.ballcounter].x = self.paddle.x + (self.paddle.width / 2) - 4
            self.balltable[self.ballcounter].y = self.paddle.y - 8
            -- give ball random starting velocity
            self.balltable[self.ballcounter].dx = math.random(-200, 200)
            self.balltable[self.ballcounter].dy = math.random(-60, -80)
        end
    end
    --
    --
    --


    --
    -- !Powerup mechanics after colliding with paddle
    -- 
    for k, power in pairs(self.powers) do
        power:update(dt)

        if power:collides(self.paddle) then
            power:consumes()

            if power.skin == 3 then
                print("You got hearts!")
                -- can't go above 3 health
                self.health = math.min(3, self.health + 1)
            end

            if power.skin == 4 then
                print("You got 3 balls!")
                
                --add 2 more balls
                for i=1,2 do
                    table.insert(self.balltable, Ball(math.random(7)))
                    self.ballcounter = self.ballcounter + 1
                    self.balltable[self.ballcounter].x = self.paddle.x + (self.paddle.width / 2) - 4
                    self.balltable[self.ballcounter].y = self.paddle.y - 8
                    -- give ball random starting velocity
                    self.balltable[self.ballcounter].dx = math.random(-200, 200)
                    self.balltable[self.ballcounter].dy = math.random(-60, -80)
                end
            end

            if power.skin == 9 then
                print("You got 1 more ball!")
                table.insert(self.balltable, Ball(math.random(7)))
                self.ballcounter = self.ballcounter + 1
                self.balltable[self.ballcounter].x = self.paddle.x + (self.paddle.width / 2) - 4
                self.balltable[self.ballcounter].y = self.paddle.y - 8
                -- give ball random starting velocity
                self.balltable[self.ballcounter].dx = math.random(-200, 200)
                self.balltable[self.ballcounter].dy = math.random(-60, -80)
            end

            -- key powerup
            if power.skin == 10 then
                print("You got a key!")

                self.hasfoundakey = true

                --Unlocking a locked brick
                for k, brick in pairs(self.bricks) do
                    if brick.locked then
                        brick.locked = false
                        brick.unlocked = true
                        -- emit particle effects to make player notice that he unlocked it
                        brick.psystem:emit(128)
                    end
                end
            end
            table.remove(self.powers, k)
        end
    end
    --
    --
    --

    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        for b, ball in pairs(self.balltable) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                --* Update counter for how many hits were done (For powerups)
                self.counterhits = self.counterhits + 1

                --
                --! Conditions to spawn powerups
                --
                -- 3 balls powerup
                if self.counterhits >= 26 and math.random(1,4) == 2 then
                    table.insert( self.powers, Powerup(4, brick.x, brick.y, 30) )
                    self.counterhits = 0
                end

                -- hearts powerup
                if self.counterhits >= 26 and math.random(1,4) == 2 then
                    table.insert( self.powers, Powerup(3, brick.x, brick.y, 30))
                    self.counterhits = self.counterhits/2
                end

                -- key for unlocking the brick
                if math.random(20) == 15 and not self.hasfoundakey and self.lockedcreated then
                    table.insert( self.powers, Powerup(10, brick.x, brick.y, 30))
                end
                --
                -- 1 more ball powerup
                if self.counterhits >= 24 and math.random(1,8) == 4 then
                    table.insert( self.powers, Powerup(9, brick.x, brick.y, 30))
                    self.counterhits = self.counterhits/2
                end                
                --
                --

                -- add to score for all bricks except for locked and give more points for unlocked
                if not brick.locked then
                    if not brick.unlocked then
                        self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    else
                        self.score = self.score + 15000
                    end
                end
                -- trigger the brick's hit function, which removes it from play
                brick:hit()

                -- * if we have enough points, recover a point of health and grow
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)
                    -- can't go above 4 sizes
                    self.paddle.size = math.min(4, self.paddle.size + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = math.min(1000000, self.recoverPoints * 2)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        recoverPoints = self.recoverPoints,
                        paddlesize = self.paddle.size
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end
                
                -- * Scaling the veloicty throughout the game
                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end
    end

    -- *if ball goes below bounds, revert to serve state and decrease health
    for b, ball in pairs(self.balltable) do
        if ball.y >= VIRTUAL_HEIGHT then

            -- remove the ball from the table
            table.remove( self.balltable, b)

            -- decrease the counter of the balls
            self.ballcounter = self.ballcounter - 1

            -- only if there are no more balls
            if self.ballcounter == 0 then 
                self.health = self.health - 1
                -- shrinks a paddle in size not less then 2
                if self.paddle.size > 1 then
                    self.paddle.size = self.paddle.size - 1
                end
                gSounds['hurt']:play()

                if self.health == 0 then
                    gStateMachine:change('game-over', {
                        score = self.score,
                        highScores = self.highScores
                    })
                else
                    gStateMachine:change('serve', {
                        paddle = self.paddle,
                        bricks = self.bricks,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        level = self.level,
                        recoverPoints = self.recoverPoints,
                        paddlesize = self.paddle.size,
                        key = self.hasfoundakey
                    })
                end
            end
        end
    end
    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()

    -- ! Rendering the balls
    for b, ball in pairs(self.balltable) do
        ball:render()
    end

    -- ! Rendering powerups
    for k, power in pairs(self.powers) do
        power:render()
    end
    
    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end
