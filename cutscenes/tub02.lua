local savedPosTub = {x=game.player.x,y=game.player.y,anim=game.player.currentAnim};
local backupDistTub = 10;
game.player.setAnimation(game.player.currentAnim .. "_move");
scriptools.doOverTime(0.6,function(percent)
	if savedPosTub.anim == "e" then
		game.player.x = savedPosTub.x - (backupDistTub * percent);
	elseif savedPosTub.anim == "n" then
		game.player.y = savedPosTub.y + (backupDistTub * percent);		
	else
		error("impossible player orientation: " .. savedPosTub.anim);
	end
end,function()
	game.player.setAnimation("se");
	game.convo = Convo("cutscene/tub03");
	game.player.state = "TEXTBOX";
	game.convo.start();
	scriptools.recenterCamera(1,{x=20,y=50});
end);