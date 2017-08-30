sfx.play(sfx.siren);
scriptools.wait(7,function()
	sfx.fade(sfx.fireAlarm,nil,5);
end);
scriptools.wait(9,function() 
	sfx.fadeInNewBGM(2,sfx.mainthemeIntro);
end);
scriptools.wait(11,function()
	local logo = ImageThing(150,180,101,"images/fakelogo.png");
	game.room.registerThing(logo,"logo",true);
	logo.color = {r=255,g=255,b=255,a=0};
	scriptools.doOverTime(6,function(percent)
		logo.color.a = math.floor(255*percent);
	end,function()
		scriptools.wait(4,function() 
			scriptools.doOverTime(1.1,function(percent)
				logo.color.a = 255 - math.floor(255*percent);
			end,function()
				scriptools.wait(3,function()
					game.room.eliminateThingByName("logo",true);
					--sfx.fadeBGM();
					game.player.x = 220;
					game.player.y = 300;
					game.room.camera.y = -30;
					game.player.color = {r=0,g=0,b=0,a=255};
					scriptools.doOverTime(2,function(percent)
						love.graphics.pushCanvas(game.room.overlaycanvas);
						love.graphics.clear();
						love.graphics.setColor(0,0,0,255 - math.floor(percent*255));
						love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
						love.graphics.popCanvas();
					end,function()
						love.graphics.pushCanvas(game.room.overlaycanvas);
						love.graphics.clear();
						love.graphics.popCanvas();
						local door = game.room.thingLookup["door"];
						door.playAnimation("opening");
						sfx.play(sfx.doorOpen);
						scriptools.doOverTime(0.4,function(percent)
							door.color.a = 127 + math.floor(percent*128);
						end,function()
							door.color.a = 255;	
						end);
						scriptools.wait(1.2,function()
							scriptools.movePlayerOverTime(0,-40,1);
							scriptools.moveCameraOverTime(0,-40,1,function()
								--sfx.fadeInNewBGM(2,sfx.bgmDemo);
								door.playAnimation("closing");
								scriptools.wait(0.4,function()
									sfx.play(sfx.doorClose);
									game.player.isColliding = true;
									local leo = game.room.thingLookup["leo"];
									emotes.exclaim(leo,{x=0,y=5},function()
										leo.setAnimation("s_move");
										scriptools.moveThingOverTime(leo,0,20,0.7,function()
											leo.setAnimation("s");
											game.convo = Convo("cutscene/intro01");
											sfx.play(sfx.evidenceOpen);
											game.player.state = "TEXTBOX";
											game.convo.start();
										end);
										scriptools.moveCameraOverTime(0,20,0.7);
									end);
									leo.setAnimation("s");
								end);
								scriptools.doOverTime(0.8,function(percent)
									door.color.a = 255 - math.floor(percent*255);
								end,function()
									game.room.eliminateThingByName("door",false);
								end);
							end);
							scriptools.doOverTime(1,function(percent) --unshadow the player
								local lightness = math.floor(percent * 255);
								game.player.color = {r=lightness,g=lightness,b=lightness,a=255};
							end,function()
								game.player.color = {r=255,g=255,b=255,a=255};
							end);
						end);
					end);
				end);
			end);
			
		end);
	end);
end);
