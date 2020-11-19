local physics = require("physics")

local _W = display.contentWidth
local _H = display.contentHeight


local gr = display.newGroup()

physics.start()
physics.setGravity( 0, 9.8 )
physics.setDrawMode( "normal" )

local bg = display.newRect( gr, _W / 2, _H / 2, _W, _H)
bg.fill = {
    type = "image",
    filename = "background.png"
}


local leftSide = display.newRect( gr, 0, _H, 30, _H / 2 )
leftSide.anchorX = 1
physics.addBody( leftSide, "static" )
leftSide.fill = { 1 }

local centerPiece = display.newRect( gr, _W / 2, _H, _W, 30 )
centerPiece.anchorY = 0
physics.addBody( centerPiece, "static" )
centerPiece.fill = { 1 }

local rightSide = display.newRect( gr, _W, _H, 30, _H / 2  )
rightSide.anchorX = 0
physics.addBody( rightSide, "static" )
rightSide.fill = { 1 }

local groupp = display.newGroup()
gr:insert(groupp)

local gg
local snpashotListener

local function createGRoup(r, g, b, grav, a)
    gg = display.newGroup()
    groupp:insert(gg)

    local particleSystem = physics.newParticleSystem{
        filename = "liquidParticle.png",
        radius = 7,
        imageRadius = 10,
        gravityScale = grav,
        strictContactCheck = true,
        blendMode = { srcColor="one", srcAlpha="one", dstColor="one", dstAlpha="one" }

    }
    gg:insert(particleSystem)

    --[[TENSILE as flag param (lowercase)]]

    particleSystem:createGroup{
        --flags = { "water", "colorMixing" },
        x = _W / 2,
        y = _H / 2,
        --color = { 0.7, 0.1, 0.0, 1 },
        color = { r, g, b, 1 },
        halfWidth = _W / 2,
        halfHeight = _H / 2,
    }

    --[[ particleSystem:createGroup{
        flags = { "water", "colorMixing" },
        x = _W / 2,
        y = -_H/2,
        color = { 1, 1, 1, 1 },
        halfWidth = _W / 20,
        halfHeight = _H / 20
    }]]

    local snapshot = display.newSnapshot( _W * 2, _H * 2 )
    local snapshotGroup = snapshot.group
    snapshot.x = _W / 2
    snapshot.y = _H / 2
    snapshot.canvasMode = "discard"
    snapshot.alpha = a

    snapshotGroup.anchorChildren = false
    snapshotGroup:insert( particleSystem )
    snapshotGroup.x = -_W / 2
    snapshotGroup.y = -_H / 2

    function snpashotListener( event )
        snapshot:invalidate()
    end
    Runtime:addEventListener( "enterFrame", snpashotListener )

    snapshot.fill.effect = "filter.contrast"

    gg:insert(snapshot)
end

display.setStatusBar(display.HiddenStatusBar)

local boxx = display.newRect(gr, 0, 0, _W, _W / 10)
boxx.anchorX = 0
boxx.anchorY = 0
boxx:setFillColor(1,1,1,0.3)

local rText = display.newText(gr, "0", _W / 8, boxx.y + boxx.height / 2 )
rText:setFillColor(1,0,0)

local gText = display.newText(gr, "0", _W / 2 - _W / 8, boxx.y + boxx.height / 2 )
gText:setFillColor(0,1,0)

local bText = display.newText(gr, "0", _W / 2 + _W / 8, boxx.y + boxx.height / 2 )
bText:setFillColor(0,0,1)

local gravText = display.newText(gr, "1", _W - _W / 8, boxx.y + boxx.height / 2 )
gravText:setFillColor(0.2)


for i = 1, 4 do
    local plusButton = display.newRect(gr, (_W / 4) * (i - 1), boxx.y + boxx.height, _W / 8, _W / 10)
    plusButton.anchorY = 0
    plusButton.anchorX = 0
    plusButton:setFillColor(1,0,0,0.3)

    local plusText = display.newText(gr, "+", plusButton.x + plusButton.width / 2, plusButton.y + plusButton.height/2, nil, _H / 15)

    local minusButton = display.newRect(gr, _W / 8 + (_W / 4) * (i - 1), boxx.y + boxx.height, _W / 8, _W / 10)
    minusButton.anchorY = 0
    minusButton.anchorX = 0
    minusButton:setFillColor(0,0,1,0.3)

    local minusText = display.newText(gr, "-", minusButton.x + plusButton.width / 2, plusButton.y + plusButton.height/2, nil, _H / 15)

    plusButton:addEventListener( "touch", function(event) 
        if "ended" == event.phase then
            local t = i == 1 and rText or i == 2 and gText or i == 3 and bText or gravText

            if i ~= 4 then
                if tonumber(t.text) < 1 then
                    t.text = tonumber(t.text) + 0.1
                end
            else
                if tonumber(t.text) < 20 then
                    t.text = tonumber(t.text) + 1
                end
            end
        end
    end )

    minusButton:addEventListener( "touch", function(event) 
        if "ended" == event.phase then
            local t = i == 1 and rText or i == 2 and gText or i == 3 and bText or gravText

            if i ~= 4 then
                if tonumber(t.text) > 0 then
                    t.text = tonumber(t.text) - 0.1
                end
            else
                if tonumber(t.text) > 1 then
                    t.text = tonumber(t.text) - 1
                end
            end
        end
    end )
end

local stopButton = display.newRect(gr, 0, _W / 5, _W / 4, _W / 10)
stopButton.anchorX = 0
stopButton.anchorY = 0
stopButton:setFillColor(0,0,0,0.3)

local stopText = display.newText(gr, "STOP", stopButton.x + stopButton.width / 2, stopButton.y + stopButton.height/2)

local startButton = display.newRect(gr, _W, _W / 5, _W / 4, _W / 10)
startButton.anchorX = 1
startButton.anchorY = 0
startButton:setFillColor(0,0,0,0.3)

local startText = display.newText(gr, "START", startButton.x - startButton.width / 2, startButton.y + startButton.height/2)

stopButton:addEventListener( "touch", function(event)
    if "ended" == event.phase then
        gg:removeSelf()
        Runtime:removeEventListener( "enterFrame", snpashotListener )
    end
end)

startButton:addEventListener( "touch", function(event)
    if "ended" == event.phase then
        createGRoup(tonumber(rText.text), tonumber(gText.text), tonumber(bText.text), tonumber(gravText.text))
    end
end)

--createGRoup(tonumber(rText.text), tonumber(gText.text), tonumber(bText.text), tonumber(gravText.text))
--createGRoup(0.6, 0.1, 0, 2)
createGRoup(0.0, 0.1, 0.5, 2, 0.3)

local b1 = display.newRect(gr, _W / 2, 0, _W, _H * 0.75 )
b1.anchorY = 0
b1:setFillColor(0)

local b2 = display.newRect(gr, _W / 2, _H, _W, _H * 0.1 )
b2.anchorY = 1
b2:setFillColor(0)

local b3 = display.newRect(gr, 0, _H, _W * 0.2, _H)
b3.anchorX = 0
b3:setFillColor(0)

local b4 = display.newRect(gr, _W, _H, _W * 0.2, _H)
b4.anchorX = 1
b4:setFillColor(0)