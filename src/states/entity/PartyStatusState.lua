--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Alejandro Mujica
    alejandro.j.mujic4@gmail.com

    This file contains the class PartyIdleState.
]]
PartyStatusState = Class{__includes = PartyBaseState}

function PartyStatusState:enter(params)
    self.currentSelection = 1
end

function PartyStatusState:canAct(i)
    for key, action in pairs(self.party.characters[i].actions) do
        if action.target_type == 'character' then
            return true
        end        
    end

    return false
end

function PartyStatusState:getActions(i)
    local ret = { items = {} }

    for key, action in pairs(self.party.characters[i].actions) do
        table.insert(ret.items, {
            text = action.name,
            onSelect = function ()
                if action.require_target then
                    stateStack:push(PartySelectActionTargetState(self.party, function (selected)
                        SOUNDS[action.sound_effect]:play()
                        action.func(self.party.characters[i], selected, action.strength)
                    end))
                else
                    SOUNDS[action.sound_effect]:play()
                    action.func(self.party.characters[i], self.party.characters, action.strength)
                    stateStack:pop()
                end
            end
        })
    end

    return ret
end

function PartyStatusState:update(dt)

    if love.keyboard.wasPressed('left') then
        if self.currentSelection == 1 then
            self.currentSelection = #self.party.characters
        else
            self.currentSelection = self.currentSelection - 1
        end
        
        SOUNDS['blip']:stop()
        SOUNDS['blip']:play()
    elseif love.keyboard.wasPressed('right') then
        if self.currentSelection == #self.party.characters then
            self.currentSelection = 1
        else
            self.currentSelection = self.currentSelection + 1
        end
        
        SOUNDS['blip']:stop()
        SOUNDS['blip']:play()
    elseif love.keyboard.wasPressed('return') and self:canAct(self.currentSelection) then
        local it = self:getActions(self.currentSelection)
        stateStack:push(PartySelectActionState(it))
        
        SOUNDS['blip']:stop()
        SOUNDS['blip']:play()
    end

    if love.keyboard.wasPressed('space') then
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

    love.graphics.setFont(FONTS['small'])

    local drawOffset = 16
    for k, c in pairs(self.party.characters) do
        if not c.dead then

            -- draw sprite
            love.graphics.draw(TEXTURES[c.texture],
                FRAMES[c.texture][8], x - width/2 + drawOffset + ENTITY_WIDTH/2, y - height/2 + 20)

            if k == self.currentSelection then
                love.graphics.draw(TEXTURES['cursor-right'],
                    x - width/2 + drawOffset - ENTITY_WIDTH/2, y - height/2 + 20)
            end

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
                if action.target_type == 'character' then
                        love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
                    else
                        love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 127))
                end
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