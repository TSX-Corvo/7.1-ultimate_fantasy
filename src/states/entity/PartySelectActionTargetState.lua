--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by: Alejandro Mujica (alejandro.j.mujic4@gmail.com)

    This class contains the class PartySelectActionTargetState.
]]
PartySelectActionTargetState = Class{__includes = BaseState}

function PartySelectActionTargetState:init(party, onSelected)
    self.onSelected = onSelected or function () end

    local items = {}

    for key, chara in pairs(party.characters) do
        table.insert(items, {
            text = chara.name,
            onSelect = function ()
                onSelected(chara)
                stateStack:pop()
                stateStack:pop()
            end
        })
    end

    self.menu = Menu {
        x = VIRTUAL_WIDTH / 2 - 32,
        y = VIRTUAL_HEIGHT / 2 - 32,
        width = 64,
        height = 64,
        font = FONTS['small'],
        items = items
    }
end

function PartySelectActionTargetState:update(dt)
    self.menu:update(dt)

    if love.keyboard.wasPressed('space') then
        stateStack:pop()
    end
end

function PartySelectActionTargetState:render()
    self.menu:render()
end