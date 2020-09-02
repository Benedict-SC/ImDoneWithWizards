sound.play("siren");
local city = ImageThing(150,180,100.5,"images/city.png");
city.color = {r=0,g=0,b=0,a=1};
game.room.registerThing(city,"city",true);
scriptools.doOverTime(9,function(percent) 
	city.color = {r=percent,g=percent,b=percent,1};
end,function() end);
scriptools.moveThingOverTime(city,0,240,22,function() end);
scriptools.wait(7,function()
	sound.fade("fireAlarm",5);
end);
scriptools.wait(9,function() 
	sound.fadeInBGM("mainthemeIntro");
end);
scriptools.wait(11,function()
	local logo = ImageThing(150,180,101,"images/biglogo.png");
	game.room.registerThing(logo,"logo",true);
	logo.color = {r=1,g=1,b=1,a=0};
	scriptools.doOverTime(6,function(percent)
		logo.color.a = percent;
	end,function()
		scriptools.wait(4,function() 
			scriptools.doOverTime(1.1,function(percent)
				logo.color.a = 1 - percent;
				city.color.a = 1 - percent;
			end,function()
				scriptools.wait(3,function()
					game.room.eliminateThingByName("logo",true);
					game.room.eliminateThingByName("city",true);
					game.player.x = 220;
					game.player.y = 300;
					game.room.camera.y = -30;
					game.player.color = {r=0,g=0,b=0,a=1};
					sound.fadeInBGM();
					scriptools.doOverTime(2,function(percent)
						love.graphics.pushCanvas(game.room.overlaycanvas);
						love.graphics.clear();
						love.graphics.setColor(0,0,0,1 - percent);
						love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
						love.graphics.popCanvas();
					end,function()
						love.graphics.pushCanvas(game.room.overlaycanvas);
						love.graphics.clear();
						love.graphics.popCanvas();
						local door = game.room.thingLookup["door"];
						door.playAnimation("opening");
						sound.play("doorOpen");
						scriptools.doOverTime(0.4,function(percent)
							door.color.a = 0.5 + 0.5*percent;
						end,function()
							door.color.a = 1;	
						end);
						scriptools.wait(1.2,function()
							scriptools.movePlayerOverTime(0,-40,1);
							scriptools.moveCameraOverTime(0,-40,1,function()
								door.playAnimation("closing");
                                door.dynamicTransparency = true;
								scriptools.wait(0.4,function()
									sound.play("doorClose");
									game.player.isColliding = true;
									local leo = game.room.thingLookup["leo"];
									emotes.exclaim(leo,{x=0,y=5},function()
										leo.setAnimation("s_move");
										scriptools.moveThingOverTime(leo,0,20,0.7,function()
											leo.setAnimation("s");
											game.convo = Convo("cutscene/intro01");
											sound.play("evidenceOpen");
											game.player.state = "TEXTBOX";
											game.convo.start();
										end);
										scriptools.moveCameraOverTime(0,20,0.7);
									end);
									leo.setAnimation("s");
								end);
								scriptools.doOverTime(0.8,function(percent)
									door.color.a = 1 - percent;
								end,function()
									game.room.eliminateThingByName("door",false);
								end);
							end);
							scriptools.doOverTime(1,function(percent) --unshadow the player
								game.player.color = {r=percent,g=percent,b=percent,a=1};
							end,function()
								game.player.color = {r=1,g=1,b=1,a=1};
							end);
						end);
					end);
				end);
			end);
			
		end);
	end);
end);

