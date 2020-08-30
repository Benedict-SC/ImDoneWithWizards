--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp12");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local leo = game.room.thingLookup["leo"];
scriptools.recenterCamera(3,{x=0,y=40});
sound.fadeInBGM();
scriptools.doOverTime(3,function(percent)
    love.graphics.pushCanvas(game.room.overlaycanvas);
    love.graphics.clear();
    pushColor();
    love.graphics.setColor(0,0,0,percent);
    love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
    popColor();
    love.graphics.popCanvas();
end,function()
    if DEBUG_SKIP then
        leo.setAnimation("w");
        leo.x = 118;
        leo.y = 202;
        game.player.x = 45;
        game.player.y = 187;
        game.player.setAnimation("fallen");
    end
    scriptools.recenterCamera(0.1,{x=10,y=50});
    local opal = game.room.thingLookup["opal"];
    opal.x = 209;
    opal.y = 195;
    leo.y = leo.y - 7;
    opal.setAnimation("w");
    if not DEBUG_SKIP then
        game.room.eliminateThingByName("gwiz");
        game.room.eliminateThingByName("hole");
    end
end);
leo.setAnimation("w_move");
scriptools.moveThingOverTime(leo,-10,-3,0.3,function()
    leo.setAnimation("w");
    scriptools.wait(4,function()
        sound.fadeInBGM("bgmDemo");
        scriptools.doOverTime(0.8,function(percent)
            love.graphics.pushCanvas(game.room.overlaycanvas);
            love.graphics.clear();
            pushColor();
            love.graphics.setColor(0,0,0,1-percent);
            love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
            popColor();
            love.graphics.popCanvas();
        end,function()
            game.convo = Convo("cutscene/ending13");
            sound.play("evidenceOpen");
            game.player.state = "TEXTBOX";
            game.convo.start();
        end);
    end);
end);