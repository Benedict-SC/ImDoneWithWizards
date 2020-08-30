game.player.state = "NOCONTROL";
scriptools.doOverTime(0.8,function(percent)
    love.graphics.pushCanvas(game.room.overlaycanvas);
    love.graphics.clear();
    love.graphics.setColor(0,0,0,percent);
    love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
    love.graphics.popCanvas();
end,function()
    local leo = game.room.thingLookup["leo"];
    local opal = game.room.thingLookup["opal"];
    savedLeo = {x=leo.x,y=leo.y};
    savedOpal = {x=opal.x,y=opal.y};
    savedStar = {x=game.player.x,y=game.player.y};
    leo.x = 215;
    leo.y = 195;
    opal.x = 155;
    opal.y = 195;
    game.player.x = 175;
    game.player.y = 230;
    leo.setAnimation("sw");
    game.player.setAnimation("ne");
    scriptools.recenterCamera(0.1,{x=0,y=40});
    scriptools.doOverTime(0.8,function(percent)
        love.graphics.pushCanvas(game.room.overlaycanvas);
        love.graphics.clear();
        love.graphics.setColor(0,0,0,1-percent);
        love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
        love.graphics.popCanvas();
    end,function()
        scriptools.wait(0.4,function()
            game.convo = Convo("cutscene/phase3end");
            sound.play("evidenceOpen");
            game.player.state = "TEXTBOX";
            game.convo.start();
        end);
    end);
end);