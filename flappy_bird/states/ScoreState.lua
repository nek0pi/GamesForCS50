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
function ScoreState:enter(params)
    self.score = params.score
    self.goldimg = love.graphics.newImage('images/gold.png')
    self.silverimg = love.graphics.newImage('images/silver.png')
    self.bronzeimg = love.graphics.newImage('images/bronze.png')
    self.gold = 0
    self.silver = 0
    self.bronze = 0
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
    if self.score >= 2 then
        self.bronze = 1
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 140, VIRTUAL_WIDTH, 'center')
    
    love.graphics.printf('Your prizes:', 0, 180, VIRTUAL_WIDTH, 'center')
    if self.bronze == 1 then
        love.graphics.draw(self.bronzeimg, 150 , 200 )
        love.graphics.setFont(smallFont)
        love.graphics.printf('You got 5 points!',-85, 250, VIRTUAL_WIDTH, 'center')
    end

end
