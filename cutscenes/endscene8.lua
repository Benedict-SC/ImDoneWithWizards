--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp8");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local holething = Thing(72,165,0.55);
holething.prog = 0;
holething.width = function()
    return 28;
end
holething.height = function()
    return 15;
end
holething.draw = function()
    pushColor();
    love.graphics.setColor(0,0,0);
    love.graphics.ellipse("fill",holething.x,holething.y,holething.prog*holething.width(),holething.prog*holething.height());
    popColor();
end
game.room.registerThing(holething,"hole");
sound.play("hole");
scriptools.doOverTime(0.5,function(percent) 
    holething.prog = percent;
end,function() 
    holething.prog = 1; 
    scriptools.wait(0.7,function()
        sound.play("fall");
        local swiz = game.room.thingLookup["stopwiz"];
        swiz.olddraw = swiz.draw;
        swiz.initspot = {x=math.floor((swiz.x-(swiz.canvas:getWidth()/2)) + 0.5),y=math.floor((swiz.y - swiz.canvas:getHeight())+0.5)};
        swiz.inity = swiz.y;
        swiz.draw = function()
            love.graphics.setScissor(swiz.initspot.x, swiz.initspot.y, swiz.width(),swiz.height());
            swiz.olddraw();
            love.graphics.setScissor();
        end
        scriptools.doOverTime(0.7,function(percent) 
            swiz.y = swiz.inity + (90*percent);
        end,function()
            game.convo = Convo("cutscene/ending9");
            sound.play("evidenceOpen");
            game.player.state = "TEXTBOX";
            game.convo.start();
        end);
    end);
end);
