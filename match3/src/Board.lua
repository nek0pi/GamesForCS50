--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}
    self.level = level

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            -- !calculate random worth of tile
            self.worth = math.min(6, math.random(1, self.level))
            -- create a new tile at X,Y with a random color not more than a worth and variety,
            self.bombprob = false
            if math.random() > 0.98 then
                self.bombprob = true
            end
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(math.min(8, self.level + 3)), self.worth, self.bombprob))
        end

    end

    while self:calculateMatches() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end

        
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end
--[[
    Calculates potential matches so the board always
    has matches and is possible to be passed. 
    For now it's looking to have >20 matches when starting the board
    to ensure that the game is possible to pass  
]]
function Board:calculatePotential(minnum)
    -- counter for potential matches
    potmatchnum = 0
    for y = 1, 8 do
        print("Number of potential matches is: " .. potmatchnum)
        -- if there are more than minnum matches, we are good
        if potmatchnum < minnum then
            for x = 1, 8 do
                -- can we go left?
                if not (x == 1) then
                    -- ! not using 3 tiles model (TempT) to make it more visual and easier to tweak
                    rightTile = self.tiles[y][x]
                    leftTile = self.tiles[y][x - 1]

                    -- putting the right tile in a left tile
                    self.tiles[y][x - 1] = rightTile
                    --putting the left tile in a right tile
                    self.tiles[y][x] = leftTile
                    
                    if self:calculateMatches() then
                        potmatchnum = potmatchnum + #self.matches
                    end
                    --putting things back to normal
                    self.tiles[y][x - 1] = leftTile
                    self.tiles[y][x] = rightTile
                end
                -- can we go right?
                if not (x == 8) then

                    rightTile = self.tiles[y][x + 1]
                    leftTile = self.tiles[y][x]

                    -- putting the left tile in a right tile
                    self.tiles[y][x + 1] = leftTile
                    --putting the right tile in a left tile
                    self.tiles[y][x] = rightTile
                    
                    if self:calculateMatches() then
                        potmatchnum = potmatchnum + #self.matches
                    end
                    --putting things back to normal
                    self.tiles[y][x + 1] = rightTile
                    self.tiles[y][x] = leftTile
                end
                -- can we go up?
                if not (y == 1) then
                    
                    upperTile = self.tiles[y - 1][x]
                    bottomTile = self.tiles[y][x]

                    -- putting the bottom to an upper
                    self.tiles[y - 1][x] = bottomTile
                    --putting the upper to a bottom
                    self.tiles[y][x] = upperTile
                    
                    if self:calculateMatches() then
                        potmatchnum = potmatchnum + #self.matches
                    end
                    -- putting things back to normal
                    self.tiles[y - 1][x] = upperTile
                    self.tiles[y][x] = bottomTile
                end
                -- can we go down?
                if not (y == 8) then

                    upperTile = self.tiles[y][x]
                    bottomTile = self.tiles[y + 1][x]

                    -- putting the bottom to an upper
                    self.tiles[y][x] = bottomTile
                    --putting the upper to a bottom
                    self.tiles[y + 1][x] = upperTile
                    
                    if self:calculateMatches() then
                        potmatchnum = potmatchnum + #self.matches
                    end
                    -- putting things back to normal
                    self.tiles[y][x] = upperTile
                    self.tiles[y + 1][x] = bottomTile

                end
            end
        else
            break
        end
    end
    
    -- if after all there are no more than minnum potential matches reinitialize Tiles
    if potmatchnum < minnum then
        print("not enough matches were found, reinitializing")
        self:initializeTiles()
        self:calculatePotential(20)
    end
end


--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Checks if the match is horizontal or vertical and destroys
    the needed raw / column
]]
function Board:removerow()
    horiz,vert = false
    for k, match in pairs(self.matches) do
        -- chose number that is definetly not a cordinates
        previoustileY = -100
        for k, tile in pairs(match) do
            currenttileY = tile.gridY
            currenttileX = tile.gridX
            -- if this tile's Y is same as previous one it's horizontal.
            -- if it was already determined as horizontal - stop checking
            if currenttileY == previoustileY and not horiz then
                horiz = true
                break
            end
            previoustileY = tile.gridY
        end
    end

    if horiz then
        print("Destroying horizontal row")
        -- delete all tiles from a row
        for x = 1, 8 do
            self.tiles[currenttileY][x] = nil
        end
        self.matches = nil
    else
        print("VERTICAL ROW DEAD")
        -- delete all tiles from a column
        for y = 1, 8 do
            self.tiles[y][currenttileX] = nil
        end
        self.matches = nil
    end
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- * new tile with random color and variety and 2% chance of bomb dropping
                self.bombprob = false
                if math.random() > 0.98 then
                    self.bombprob = true
                end
                local tile = Tile(x, y, math.random(math.min(8, self.level + 3)), self.worth, self.bombprob)
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end