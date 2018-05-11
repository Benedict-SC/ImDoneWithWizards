--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp3");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local gobody = game.room.thingLookup["gocorpse"];
local gwiz = AnimatedThing(gobody.x,gobody.y,gobody.z,"gowiz");
game.room.things.push(gwiz);
game.room.thingLookup["gwiz"] = gwiz;
game.room.eliminateThingByName("gocorpse");
scriptools.panToThing(gwiz,0.6,{x=-10,y=20},function() 
    gwiz.setAnimation("twitch");
    scriptools.wait(1.2,function() 
        game.convo = Convo("cutscene/ending4");
        sound.play("evidenceOpen");
        game.player.state = "TEXTBOX";
        game.convo.start();
    end);
end);