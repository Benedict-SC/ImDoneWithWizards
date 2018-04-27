scriptools.wait(0.4,function()
	local leo = game.room.thingLookup["leo"];
	leo.setAnimation("nw");
	scriptools.wait(0.1,function()
		game.player.setAnimation("nw");
	end);
	scriptools.panToThing(game.room.thingLookup["bookshelf"],1.3,{x=50,y=60},function()
		scriptools.wait(0.4,function()	
			leo.setAnimation("e");	
			scriptools.wait(0.1,function()
				game.player.setAnimation("e");
			end);
		end);
		scriptools.wait(1,function()
			scriptools.panToThing(game.room.thingLookup["burnttable"],1.3,{x=-40,y=30},function()
				scriptools.wait(1,function()
					game.player.setAnimation("n");
					scriptools.panToThing(game.room.thingLookup["table"],1.1,{x=40,y=60},function()
						scriptools.wait(1,function()
							scriptools.recenterCamera(1.3,{x=0,y=20},function()
								game.convo = Convo("cutscene/intro03");
								sound.play("evidenceOpen");
								game.player.state = "TEXTBOX";
								game.convo.start();
							end);
							scriptools.wait(1,function()
								game.player.setAnimation("n");
								leo.setAnimation("s");
							end);
						end);
					end);
				end);
			end);
		end);
	end);
end);