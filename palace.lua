palace = {};
palace.setup = function()
	for i=1,#(game.evidenceData),1 do
		local id = game.evidenceData[i].id;
		palace.registerEmptyStand(id);
	end
end
palace.registerEmptyStand = function(id)
	local data = game.evidenceData[id];
	local display = CompositeThing(data.x+50,data.y+50,1,100,100);
	local stand = ImageThing(0,0,1,"images/stand.png");
	display.add(stand);
	collision.giveExplicitCollider(display,math.floor(-(stand.width()/2)+0.5),-9,stand.width(),9);
	game.darkroom.registerThing(display,id .. "_empty");
end
palace.registerEvidence = function(evidence)
	game.darkroom.eliminateThingByName(evidence.id .. "_empty");
	local data = game.evidenceData[evidence.id];
	local display = CompositeThing(data.x+50,data.y+50,1,100,100);
	display.evidence = evidence;
	local stand = ImageThing(0,0,1,"images/stand.png");
		
	local thingy = ImageThing(0,-9,1.1,"images/evidence/" .. data.icon);
	display.backlight = AnimatedThing(0,-6,1.05,"standlights");
	display.backlight.setAnimation("back");
	display.frontlight = AnimatedThing(0,-4,1.15,"standlights");
	display.add(stand);
	display.add(display.backlight);
	display.add(thingy);
	display.add(display.frontlight);
	display.toggleLights = function()
		if display.evidence.active then
			display.backlight.disableDraw();
			display.frontlight.disableDraw();
			display.evidence.active = false;
		else
			display.backlight.enableDraw();
			display.frontlight.enableDraw();	
			display.evidence.active = true;
		end
	end
	collision.giveExplicitCollider(display,math.floor(-(stand.width()/2)+0.5),-9,stand.width(),9);collision.giveColliderWithNameBasedOnExistingCollider("actionCollider",display);
		display.atype = "convo";
		if data.palaceConvo then
			display.actionConvo = Convo("palace/" .. data.palaceConvo);
		else
			display.actionConvo = Convo("palace/evidenceDefault");		
		end
		display.actionConvo.ownerName = evidence.id;
		display.action = function()
			game.convo = display.actionConvo;
			sfx.play(sfx.evidenceOpen);
			game.player.updateSprite(0,0);
			game.player.state = "TEXTBOX";
			display.actionConvo.start();
		end
		display.cancelButtonAction = function()
			display.toggleLights();
		end
		if evidence.id == "Uncertainty" then
			display.cancelButtonAction = function()
				sfx.play(sfx.invalid);
			end
		end
	game.darkroom.registerThing(display,evidence.id);
	
end