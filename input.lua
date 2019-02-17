input = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
pressedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
releasedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
objectiveArrows = {up=false,down=false,left=false,right=false,c=false,x=false,space=false,enter=false};
objectiveArrowsPressed = {up=false,down=false,left=false,right=false,c=false,x=false,space=false,enter=false};

defaultKeyControls = {up={"up"},down={"down"},left={"left"},right={"right"},action={"space"},cancel={"x"},menu={"return"},leftTab={"a"},rightTab={"d"}};
keyControls = {up={"up"},down={"down"},left={"left"},right={"right"},action={"space"},cancel={"x"},menu={"return"},leftTab={"a"},rightTab={"d"}};
controllerControls = {up={"dpup"},down={"dpdown"},left={"dpleft"},right={"dpright"},action={"a"},cancel={"b"},menu={"start"},leftTab={"leftshoulder"},rightTab={"rightshoulder"}}
controlMode = "KEYBOARD";
activeJoystick = love.joystick.getJoysticks()[1];
input.replaceButtonPrompts = function(str)
	if controlMode == "KEYBOARD" then
		str = str:gsub("%%LBUTTON%%",input.capitalize(keyControls.leftTab[1]));
		str = str:gsub("%%ACTIONBUTTON%%",input.capitalize(keyControls.action[1]));
		str = str:gsub("%%CANCELBUTTON%%",input.capitalize(keyControls.cancel[1]));
		str = str:gsub("%%MENUBUTTON%%",input.capitalize(keyControls.menu[1]));
		str = str:gsub("%%RBUTTON%%",input.capitalize(keyControls.rightTab[1]));
	elseif controlMode == "CONTROLLER" then
		str = str:gsub("%%LBUTTON%%",input.capitalize(controllerControls.leftTab[1]));
		str = str:gsub("%%ACTIONBUTTON%%",input.capitalize(controllerControls.action[1]));
		str = str:gsub("%%CANCELBUTTON%%",input.capitalize(controllerControls.cancel[1]));
		str = str:gsub("%%MENUBUTTON%%",input.capitalize(controllerControls.menu[1]));
		str = str:gsub("%%RBUTTON%%",input.capitalize(controllerControls.rightTab[1]));
	end
	return str;
end
input.capitalize = function(str)
	if #str == 1 then 
		return str:upper(); 
	elseif (str == "leftshoulder") then
		return "L";
	elseif (str == "rightshoulder") then
		return "R";
	else
		return str; 
	end
end

input.checkIfAnyAreDown = function(keytype)
	if controlMode == "KEYBOARD" then
		local keyarray = keyControls[keytype];
		local found = false;
		for i=1,#keyarray,1 do
			if love.keyboard.isDown(keyarray[i]) then
				found = true;
			end
		end
		return found;
	elseif controlMode == "CONTROLLER" then
		if not activeJoystick then 
			return false;
		end
		local buttonarray = controllerControls[keytype];
		local found = false;
		for i=1,#buttonarray,1 do
			if activeJoystick:isGamepadDown(buttonarray[i]) then
				found = true;
			end
		end
		--controller axis stuff
		if keytype == "down" then
			if activeJoystick:getGamepadAxis("lefty") > 0.2 then
				found = true;
			end
		elseif keytype == "up" then
			if activeJoystick:getGamepadAxis("lefty") < -0.2 then
				found = true;
			end
		elseif keytype == "right" then
			if activeJoystick:getGamepadAxis("leftx") > 0.2 then
				found = true;
			end
		elseif keytype == "left" then
			if activeJoystick:getGamepadAxis("leftx") < -0.2 then
				found = true;
			end
		elseif keytype == "leftTab" then
			if activeJoystick:getGamepadAxis("triggerleft") > 0.5 then
				found = true;
			end
		elseif keytype == "rightTab" then
			if activeJoystick:getGamepadAxis("triggerright") > 0.5 then
				found = true;
			end
		end
		return found;
	end
	return false;
end
input.update = function()
	pressedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
	releasedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
	objectiveArrowsPressed = {up=false,down=false,left=false,right=false,c=false,x=false,space=false,enter=false};
	if input.checkIfAnyAreDown("up") then
		if not input.up then
			pressedThisFrame.up = true;
			input.up = true;
		end
	else
		if input.up then
			releasedThisFrame.up = true;
			input.up = false;
		end
	end
	
	if input.checkIfAnyAreDown("down") then
		if not input.down then
			pressedThisFrame.down = true;
			input.down = true;
		end
	else
		if input.down then
			releasedThisFrame.down = true;
			input.down = false;
		end
	end
	
	if input.checkIfAnyAreDown("left") then
		if not input.left then
			pressedThisFrame.left = true;
			input.left = true;
		end
	else
		if input.left then
			releasedThisFrame.left= true;
			input.left = false;
		end
	end
	
	if input.checkIfAnyAreDown("right") then
		if not input.right then
			pressedThisFrame.right = true;
			input.right = true;
		end
	else
		if input.right then
			releasedThisFrame.right = true;
			input.right = false;
		end
	end
	
	if input.checkIfAnyAreDown("action") then
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
	
	if input.checkIfAnyAreDown("cancel") then
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
	
	if input.checkIfAnyAreDown("menu") then
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
	
	if input.checkIfAnyAreDown("leftTab") then
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
	if input.checkIfAnyAreDown("rightTab") then
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

	if love.keyboard.isDown("up") then
		if not objectiveArrows.up then
			objectiveArrowsPressed.up = true;
			objectiveArrows.up = true;
		end
	else
		if objectiveArrows.up then
			objectiveArrows.up = false;
		end
	end
	if love.keyboard.isDown("down") then
		if not objectiveArrows.down then
			objectiveArrowsPressed.down = true;
			objectiveArrows.down = true;
		end
	else
		if objectiveArrows.down then
			objectiveArrows.down = false;
		end
	end
	if love.keyboard.isDown("left") then
		if not objectiveArrows.left then
			objectiveArrowsPressed.left = true;
			objectiveArrows.left = true;
		end
	else
		if objectiveArrows.left then
			objectiveArrows.left = false;
		end
	end
	if love.keyboard.isDown("right") then
		if not objectiveArrows.right then
			objectiveArrowsPressed.right = true;
			objectiveArrows.right = true;
		end
	else
		if objectiveArrows.right then
			objectiveArrows.right = false;
		end
	end
	if love.keyboard.isDown("c") then
		if not objectiveArrows.c then
			objectiveArrowsPressed.c = true;
			objectiveArrows.c = true;
		end
	else
		if objectiveArrows.c then
			objectiveArrows.c = false;
		end
	end
	if love.keyboard.isDown("x") then
		if not objectiveArrows.x then
			objectiveArrowsPressed.x = true;
			objectiveArrows.x = true;
		end
	else
		if objectiveArrows.x then
			objectiveArrows.x = false;
		end
	end
	if love.keyboard.isDown("return") then
		if not objectiveArrows.enter then
			objectiveArrowsPressed.enter = true;
			objectiveArrows.enter = true;
		end
	else
		if objectiveArrows.enter then
			objectiveArrows.enter = false;
		end
	end
	if love.keyboard.isDown("space") then
		if not objectiveArrows.space then
			objectiveArrowsPressed.space = true;
			objectiveArrows.space = true;
		end
	else
		if objectiveArrows.space then
			objectiveArrows.space = false;
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
	controlMode = "KEYBOARD";
	if game.pronounsMode then
		if (game.pronounsScreen.mode == "TEXT") and (key == "backspace") then
			game.pronounsScreen.acceptInput(key);
		end
	elseif game.controlsScreen.mode == "ENTRY" then
		game.controlsScreen.acceptInput(key);
	end
	local joysticks = love.joystick.getJoysticks()
	debug_console_string_2 = "";
	for i, joystick in ipairs(joysticks) do
		local gp = "false";
		if joystick:isGamepad() then
			gp = "true";
		end
        debug_console_string_2 = debug_console_string_2 .. joystick:getName() .. " is gamepad: " .. gp .. "\n";
    end
end
love.gamepadpressed = function(joystick,button)
	if controlMode ~= "CONTROLLER" then
		controlMode = "CONTROLLER";
		activeJoystick = love.joystick.getJoysticks()[1];
	end
	debug_console_string_3 = "controller: " .. button;
end
love.joystickpressed = function(joystick,button)
	if controlMode ~= "CONTROLLER" then
		controlMode = "CONTROLLER";
		activeJoystick = love.joystick.getJoysticks()[1];
	end
	debug_console_string_3 = "controller: " .. button;
end
love.joystickaxis = function(joystick,axis,value)
	if controlMode ~= "CONTROLLER" then
		controlMode = "CONTROLLER";
		activeJoystick = love.joystick.getJoysticks()[1];
	end
end
love.joystickadded = function(joystick)
	--detect if it's a PS4 controller, then set PS4 keybindings
end