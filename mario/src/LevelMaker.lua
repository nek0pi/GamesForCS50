--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    --  * keys and locked blocks vars
    hasbblock = false
    haskeyspawned = false
    -- Color of a locked block and a key
    lockcolor = math.random(1, 4)
    keypicked = false
    polehasspawned = false
    
    won = false

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness 2 blocks away from start
        -- * 12 blocks away from the end for FLAG
        if math.random(7) == 1 and x > 2 and x < width - 12 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 and x < width - 12 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block 
            -- * DON't SPAWN BLOCKS NEAR THE FLAG LOCATION (width - 12)
            if math.random(8) == 1 and x < width - 12 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(3) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                                player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)

                                -- ! Spawn a key for locked block
                                -- do it after a half of a map to make key search a little more interesting
                                elseif (not haskeyspawned) and (x >= width / 2) then
                                    haskeyspawned = true
                                    -- maintain reference so we can set it to nil
                                    local key = GameObject {
                                        texture = 'locksandkeys',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        -- Till 4th thing in a picture (key color)
                                        frame = lockcolor,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                            keypicked = true
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [key] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, key)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
                --! Chance to spawn locked block
            elseif math.random(10) == 1 and not hasbblock then
                -- Flag that identifies that block has spawned
                hasbblock = true

                table.insert(objects,

                -- Blocked key
                GameObject {
                    texture = 'locksandkeys',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,

                    -- make it a random variant of color
                    frame = lockcolor + 4,
                    collidable = true,
                    hit = false,
                    solid = true,

                    -- collision function takes itself
                    onCollide = function(obj)
                        -- If player has a key and collided with the locked block

                        if keypicked then
                            -- remove all locked blocks
                            for k, obj in pairs(objects) do
                                if obj.texture ==
                                 'locksandkeys' then
                                    table.remove( objects, k )
                                end
                            -- remove the key from player 
                            keypicked = false
                            gSounds['unlock']:play()
                            --
                            --
                            if not polehasspawned then
                                -- Spawn a poll with a flag.

                                -- x cordinate for spawning the flag (change depending on situation)
                                local xcord = width - 10
                                -- * Debug for how pole area looks like 
                                for y = 1, height do 
                                    for b = width - 15, width - 5 do
                                        if tiles[y][b].id == 5 then
                                            if b == xcord + 1 then
                                                if y > 6 then 
                                                    -- flag will spawn under the gap. 
                                                    io.write("@")
                                                else
                                                    io.write("&")
                                                end
                                            else
                                                io.write("|")
                                            end
                                        else
                                            if y < 7 and b == xcord + 1 then
                                                -- flag will spawn inside ground. 
                                                io.write("@")
                                            else
                                                io.write("#")
                                            end
                                        end
                                    end
                                    print(y)
                                end

                                print('the poll has spawned')
                                polehasspawned = true
                                local polcol = math.random(6)
                                table.insert(objects,spawnGOPole('flags', xcord * TILE_SIZE, 
                                3 * TILE_SIZE, 
                                polcol, nil))
                                table.insert(objects,spawnGOPole('flags', xcord * TILE_SIZE, 
                                4 * TILE_SIZE, 
                                polcol + 9, nil))
                                table.insert(objects,spawnGOPole('flags', xcord * TILE_SIZE, 
                                5 * TILE_SIZE, 
                                polcol + 9 * 2, nil))

                                -- Spawn the flag
                                flagcol = math.random(3)

                                table.insert(objects,
                                spawnGOPole('flags', (xcord + 0.5) * TILE_SIZE,
                                3 * TILE_SIZE,
                                7 + 9 *flagcol, Animation {
                                    frames = {7 + 9 *flagcol +1 , 7 + 9 *flagcol},
                                    interval = 0.3,
                                }))
                                
                        end
                            --
                            --

                            end

                        end
                        gSounds['empty-block']:play()
                    end
                }
            )

            end
  
            
        end
    end
    -- Function for spawning the pole parts
    function spawnGOPole(textr, xc, yc, fr, ani)
            obj = GameObject {
                texture = textr,
                x = xc,
                y = yc,
                width = 16,
                height = 16,
                -- make it a random variant of color
                frame = fr,
                collidable = true,
                hit = false,
                animation = ani,
                consumable = true,
                -- collision function takes itself
                onConsume = function(player, obj)
                    won = true
                end 

            }
        
        return obj
    end


    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end