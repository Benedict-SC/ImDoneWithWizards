input = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
pressedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
releasedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
input.update = function()
	pressedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
	releasedThisFrame = {up=false,down=false,left=false,right=false,action=false,cancel=false,menu=false,leftTab=false,rightTab=false};
	if love.keyboard.isDown("up") then
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
	
	if love.keyboard.isDown("down") then
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
	
	if love.keyboard.isDown("left") then
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
	
	if love.keyboard.isDown("right") then
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
	
	if love.keyboard.isDown("return") or love.keyboard.isDown("z") then
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