local opal = game.room.thingLookup["opal"];
local leo = game.room.thingLookup["leo"];
game.player.setAnimation("nw");
leo.setAnimation("w");
scriptools.panToThing(opal,0.8,{x=40,y=30},function()
	game.convo = Convo("cutscene/intro07");
	sfx.play(sfx.evidenceOpen);
	game.player.state = "TEXTBOX";
	game.convo.start();
end);