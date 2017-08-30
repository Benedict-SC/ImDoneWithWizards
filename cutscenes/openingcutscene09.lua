if true then
	local cards = Array();
	for i=1,6,1 do
		cards.push(game.room.thingLookup["card" .. i]);
	end
	--I'M SORRY
	scriptools.panToThing(cards[1],0.2,nil,function()
		scriptools.wait(0.45,function()
			scriptools.panToThing(cards[2],0.2,nil,function()
				scriptools.wait(0.45,function()
					scriptools.panToThing(cards[3],0.2,nil,function()
						scriptools.wait(0.45,function()
							scriptools.panToThing(cards[4],0.2,nil,function()
								scriptools.wait(0.45,function()
									scriptools.panToThing(cards[5],0.2,nil,function()
										scriptools.wait(0.45,function()
											scriptools.recenterCamera(0.2,nil,function()
												game.convo = Convo("cutscene/intro06");
												sfx.play(sfx.evidenceOpen);
												game.player.state = "TEXTBOX";
												game.convo.start();
											end);
										end);
									end);
								end);
							end);
						end);
					end);
				end);
			end);
		end);
	end);
end