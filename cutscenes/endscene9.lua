--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp9");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
game.room.thingLookup["sud"].setAnimation("spark");
game.room.thingLookup["sud_o"].setAnimation("spark_overlay");
game.room.thingLookup["tabley"].setAnimation("spark");
local wibbly = AnimatedThing(200,258,1.2,"circlewibblies");
game.room.things.push(wibbly);
game.room.thingLookup["wibbly"] = wibbly; 
wibbly.setAnimation("wibbling");
sound.play("sparky");
scriptools.wait(1.2,function()
    game.convo = Convo("cutscene/ending10");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end);