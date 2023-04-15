--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the class PartyIdleState.
]]
PartyStatusState = Class{__includes = PartyBaseState}

function PartyStatusState:enter(params)
    -- print("IN")
    -- print(sdump(self.party.characters[1]))
end

function PartyStatusState:update(dt)
    
    if love.keyboard.wasPressed('return') then
        self.party:changeState('idle')
    end
end

function PartyStatusState:render()
    for k, c in pairs(self.party.characters) do
        if not c.dead then
            c:render()
        end
    end

    local x = VIRTUAL_WIDTH / 2
    local y = VIRTUAL_HEIGHT / 2
    local width = VIRTUAL_WIDTH / 1.2
    local height = VIRTUAL_HEIGHT / 1.2

    love.graphics.setColor(love.math.colorFromBytes(0, 0, 0, 255))
    love.graphics.rectangle("fill", x - width / 2, y - height / 2, width, height)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))

    local drawOffset = 16
    for k, c in pairs(self.party.characters) do
        if not c.dead then

            -- draw sprite
            love.graphics.draw(TEXTURES[c.texture],
                FRAMES[c.texture][8], x - width/2 + drawOffset + ENTITY_WIDTH/2, y - height/2 + 20)

            -- name
            love.graphics.printf(c.name, x - width/2 + drawOffset, y - height/2 + 60, 40)

            -- stats
            local stats = {
                [1] = {display = 'Level', stat='level'},
                [2] = {display = 'EXP', stat={'currentExp', 'expToLevel'}},
                [3] = {display = 'HP', stat={'currentHP', 'HP'}},
                [4] = {display = 'Attack', stat='attack'},
                [5] = {display = 'Defense', stat='defense'},
                [6] = {display = 'Magic', stat='magic'}
            }

            vOffset = 80
            for key, val in orderedPairs(stats) do
                local display, stat = val['display'], val['stat']

                if type(stat) == 'string' then
                    love.graphics.printf(
                        display .. ': ' .. c[stat],
                        x - width/2 + drawOffset,
                        y - height/2 + vOffset,
                        150
                    )
                else
                    local curr, total = c[stat[1]], c[stat[2]]
                    love.graphics.printf(
                        display .. ': ' .. curr .. ' / ' .. total,
                        x - width/2 + drawOffset,
                        y - height/2 + vOffset,
                        150
                    )
                end

                vOffset = vOffset + 10
            end

            -- actions

            vOffset = vOffset + 10

            for key, action in pairs(c.actions) do
                love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 127))
                love.graphics.printf(
                    action.name,
                    x - width/2 + drawOffset,
                    y - height/2 + vOffset,
                    150
                )
                love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))

                vOffset = vOffset + 10
            end

            
                
            drawOffset = drawOffset + width/#self.party.characters
        end
    end

    -- love.graphics.printf(sdump(self.party.characters[1]), 0, 0, 500)
    -- print(sdump(self.party.characters[1]))
end