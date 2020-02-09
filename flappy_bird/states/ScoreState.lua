--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
-- progress trackings
gold = 0
silver = 0
bronze = 0
highest = 0
function ScoreState:enter(params)
    self.score = params.score
    self.goldimg = love.graphics.newImage('images/gold.png')
    self.silverimg = love.graphics.newImage('images/silver.png')
    self.bronzeimg = love.graphics.newImage('images/bronze.png')
    if highest < params.score then
        highest = params.score
    end
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
    if self.score >= 5 then
        bronze = 1
    end
    if self.score >=10 then
        silver = 1
    end
    if self.score >= 20 then
        gold = 1
    end
    
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.setColor(255, 187, 0, 255)
    love.graphics.printf('Highest score: ' .. tostring(highest), 0, 120, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.printf('Press Enter to Play Again!', 0, 150, VIRTUAL_WIDTH, 'center')
    
    love.graphics.printf('Your prizes:', 0, 180, VIRTUAL_WIDTH, 'center')
    if bronze == 1 then
        love.graphics.draw(self.bronzeimg, 150 , 200 )
        love.graphics.setFont(smallFont)
        love.graphics.setColor(250, 130, 2, 255)
        love.graphics.printf('Scored 5 points!',-85, 250, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
    end
    if silver == 1 then
        love.graphics.draw(self.silverimg, 235 , 200 )
        love.graphics.setFont(smallFont)
        love.graphics.printf('Scored 10 points!',0, 250, VIRTUAL_WIDTH, 'center')
    end
    if gold == 1 then
        love.graphics.draw(self.goldimg, 320 , 200 )
        love.graphics.setFont(smallFont)
        love.graphics.setColor(255, 187, 0, 255)
        love.graphics.printf('Scored 20 points!',85, 250, VIRTUAL_WIDTH, 'center')
    end
end
