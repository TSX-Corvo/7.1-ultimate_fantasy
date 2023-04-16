--[[
    ISPPJ1 2023
    Study Case: Ultimate Fantasy (RPG)

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by: Alejandro Mujica (alejandro.j.mujic4@gmail.com)

    This class contains the class PartySelectActionState.
]]
PartySelectActionState = Class{__includes = BaseState}

function PartySelectActionState:init(def)
    
    self.menu = Menu {
        x = VIRTUAL_WIDTH / 2 - 32,
        y = VIRTUAL_HEIGHT / 2 - 32,
        width = 64,
        height = 64,
        font = FONTS['small'],
        items = def.items
    }
end

function PartySelectActionState:update(dt)
    self.menu:update(dt)

    if love.keyboard.wasPressed('space') then
        stateStack:pop()
    end
end

function PartySelectActionState:render()
    self.menu:render()
end