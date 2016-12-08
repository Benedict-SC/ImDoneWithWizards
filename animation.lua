AnimatedThing = function(xp,yp,zp,filename)
	local base = CanvasThing(xp,yp,zp,love.graphics.newCanvas(10,10));
	base.jsonstring = love.filesystem.read("json/animations/" .. filename .. ".json");
	base.data = json.decode(base.jsonstring);
	base.anims = {};
	base.currentAnim = base.data.default;
	--create individual animation frame canvases for each animation
	for k,v in pairs(base.data.animations) do
		local animdata = base.data.animations[k];
		local sheet = love.graphics.newImage(animdata.filepath);
		base.anims[k] = {};
		base.anims[k].fps = animdata.fps;
		base.anims[k].frames = Array();
		base.anims[k].framecount = animdata.frames;
		for i = 1, base.anims[k].framecount, 1 do
			local canv = love.graphics.newCanvas(animdata.width,animdata.height);
			--draw frame to canvas
			love.graphics.pushCanvas(canv);
			local code = i - 1;
			local cx = math.floor(code%base.anims[k].framecount);
			local cy = math.floor(code/base.anims[k].framecount);
			local quad = love.graphics.newQuad(cx*animdata.width,cy*animdata.height,animdata.width,animdata.height,sheet:getWidth(),sheet:getHeight());
			love.graphics.draw(sheet,quad,0,0);
			love.graphics.popCanvas();
			--save canvas in frames
			base.anims[k].frames.push(canv);
			if k == base.data.default then 
				base.canvas = canv; 
			end
		end
	end
	
	base.startTime = love.timer.getTime();
	base.startAnimation = function()
		base.startTime = love.timer.getTime();
	end
	base.setAnimation = function(animname)
		base.currentAnim = animname;
	end
	
	base.draw = function()
		local anim = base.anims[base.currentAnim];
		local framesElapsed = (love.timer.getTime() - base.startTime) * anim.fps;
		local framecount = anim.framecount;
		local frame = math.floor(framesElapsed % framecount) + 1; --+1 because ridiculous lua array indexing
		if game.fading then frame = 1; end --time is frozen during the fade
		base.canvas = anim.frames[frame];
		love.graphics.draw(base.canvas,math.floor((base.x- (base.canvas:getWidth()/2))+0.5),math.floor((base.y - base.canvas:getHeight())+0.5));
	end
	base.width = function()
		return base.anims[base.currentAnim].frames[1]:getWidth();
	end
	return base;
end