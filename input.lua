input = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
pressedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
releasedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
objectiveArrows = {up=false,down=false,left=false,right=false};
objectiveArrowsPressed = {up=false,down=false,left=false,right=false};
input.update = function()
	pressedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
	releasedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
	objectiveArrowsPressed = {up=false,down=false,left=false,right=false};
	if love.keyboard.isDown("up") then
		if not input.up then
			pressedThisFrame.up = true;
			input.up = true;
		end
		if not objectiveArrows.up then
			objectiveArrowsPressed.up = true;
			objectiveArrows.up = true;
		end
	else
		if input.up then
			releasedThisFrame.up = true;
			input.up = false;
		end
		if objectiveArrows.up then
			objectiveArrows.up = false;
		end
	end
	
	if love.keyboard.isDown("down") then
		if not input.down then
			pressedThisFrame.down = true;
			input.down = true;
		end
		if not objectiveArrows.down then
			objectiveArrowsPressed.down = true;
			objectiveArrows.down = true;
		end
	else
		if input.down then
			releasedThisFrame.down = true;
			input.down = false;
		end
		if objectiveArrows.down then
			objectiveArrows.down = false;
		end
	end
	
	if love.keyboard.isDown("left") then
		if not input.left then
			pressedThisFrame.left = true;
			input.left = true;
		end
		if not objectiveArrows.left then
			objectiveArrowsPressed.left = true;
			objectiveArrows.left = true;
		end
	else
		if input.left then
			releasedThisFrame.left= true;
			input.left = false;
		end
		if objectiveArrows.left then
			objectiveArrows.left = false;
		end
	end
	
	if love.keyboard.isDown("right") then
		if not input.right then
			pressedThisFrame.right = true;
			input.right = true;
		end
		if not objectiveArrows.right then
			objectiveArrowsPressed.right = true;
			objectiveArrows.right = true;
		end
	else
		if input.right then
			releasedThisFrame.right = true;
			input.right = false;
		end
		if objectiveArrows.right then
			objectiveArrows.right = false;
		end
	end
	
	if love.keyboard.isDown("space") or love.keyboard.isDown("c") then
		if not input.action then
			pressedThisFrame.action = true;
			input.action = true;
		end
	else
		if input.action then
			releasedThisFrame.action = true;
			input.action = false;
		end
	end
	
	if love.keyboard.isDown("x") then
		if not input.cancel then
			pressedThisFrame.cancel = true;
			input.cancel = true;
		end
	else
		if input.cancel then
			releasedThisFrame.cancel = true;
			input.cancel = false;
		end
	end
	
	if love.keyboard.isDown("return") or love.keyboard.isDown("escape") or love.keyboard.isDown("tab") then
		if not input.menu then
			pressedThisFrame.menu = true;
			input.menu = true;
		end
	else
		if input.menu then
			releasedThisFrame.menu = true;
			input.menu = false;
		end
	end
	
	if love.keyboard.isDown("a") then
		if not input.leftTab then
			pressedThisFrame.leftTab = true;
			input.leftTab = true;
		end
	else
		if input.leftTab then
			releasedThisFrame.leftTab = true;
			input.leftTab = false;
		end
	end
	if love.keyboard.isDown("d") then
		if not input.rightTab then
			pressedThisFrame.rightTab = true;
			input.rightTab = true;
		end
	else
		if input.rightTab then
			releasedThisFrame.rightTab = true;
			input.rightTab = false;
		end
	end
	
end
love.textinput = function(text)
	if game.pronounsMode then
		if game.pronounsScreen.mode == "TEXT" then
			game.pronounsScreen.acceptInput(text);
		end
	end
end
love.keypressed = function(key)
	if game.pronounsMode then
		if (game.pronounsScreen.mode == "TEXT") and (key == "backspace") then
			game.pronounsScreen.acceptInput(key);
		end
	end
end