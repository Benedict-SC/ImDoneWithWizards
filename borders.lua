BorderedThing = function(x,y,z,imgfilename,w,h,bw,bh)
	if bw * 2 > w then w = bw*2 end; --make sure there's room for the borders
	if bh * 2 > h then h = bh*2 end;
	local base = CanvasThing(x,y,z,love.graphics.newCanvas(w,h));
	base.w = w;
	base.h = h;
	base.bw = bw;
	base.bh = bh;
	base.img = love.graphics.newImage(imgfilename);
	base.iw = base.img:getWidth();
	base.ih = base.img:getHeight();
	base.setDimensions = function(wid,hi)
		base.w = wid;
		base.h = hi;
		base.canvas = love.graphics.newCanvas(wid,hi);
		base.updateScaleFactors();
		base.updateCanvas();
	end
	base.setImage = function(imgfilename,nbh,nbw)
		base.img = love.graphics.newImage(imgfilename);
		if nbh then base.bh = nbh end;
		if nbw then base.bw = nbw end;
		base.iw = base.img:getWidth();
		base.ih = base.img:getHeight();
		base.updateScaleFactors();
		base.updateCanvas();	
	end
	base.updateScaleFactors = function()
		base.xScale = (base.w-(base.bw*2))/(base.iw-(base.bw*2));
		base.yScale = (base.h-(base.bh*2))/(base.ih-(base.bh*2));
	end
	base.updateCanvas = function()
		base.iw = base.img:getWidth();
		base.ih = base.img:getHeight();
		love.graphics.pushCanvas(base.canvas);
		local topLeftCorner = love.graphics.newQuad(0,0,base.bw,base.bh,base.iw,base.ih);
		local topBar = love.graphics.newQuad(base.bw,0,base.iw-(base.bw*2),base.bh,base.iw,base.ih);
		local topRightCorner = love.graphics.newQuad(base.iw-base.bw,0,base.bw,base.bh,base.iw,base.ih);
		local leftBar = love.graphics.newQuad(0,base.bh,base.bw,base.ih-(base.bh*2),base.iw,base.ih);
		local center = love.graphics.newQuad(base.bw,base.bh,base.iw-(base.bw*2),base.ih-(base.bh*2),base.iw,base.ih);
		local rightBar = love.graphics.newQuad(base.iw-base.bw,base.bh,base.bw,base.ih-(base.bh*2),base.iw,base.ih);
		local bottomLeftCorner = love.graphics.newQuad(0,base.ih-base.bh,base.bw,base.bh,base.iw,base.ih);
		local bottomBar = love.graphics.newQuad(base.bw,base.ih-base.bh,base.iw-(base.bw*2),base.bh,base.iw,base.ih);
		local bottomRightCorner = love.graphics.newQuad(base.iw-base.bw,base.ih-base.bh,base.bw,base.bh,base.iw,base.ih);
		--[[love.graphics.draw(base.img,topLeftCorner,0,0);
		love.graphics.draw(base.img,topBar,0,0);
		love.graphics.draw(base.img,topRightCorner,0,0);
		love.graphics.draw(base.img,leftBar,0,0);
		love.graphics.draw(base.img,center,0,0);
		love.graphics.draw(base.img,rightBar,0,0);
		love.graphics.draw(base.img,bottomLeftCorner,0,0);
		love.graphics.draw(base.img,bottomBar,0,0);
		love.graphics.draw(base.img,bottomRightCorner,0,0);]]--
		--draw them
		love.graphics.draw(base.img,topLeftCorner,0,0,0,1,1);
		love.graphics.draw(base.img,topBar,base.bw,0,0,base.xScale,1);
		love.graphics.draw(base.img,topRightCorner,(base.w-base.bw),0,0,1,1);
		love.graphics.draw(base.img,leftBar,0,base.bh,0,1,base.yScale);
		love.graphics.draw(base.img,center,base.bw,base.bh,0,base.xScale,base.yScale);
		love.graphics.draw(base.img,rightBar,(base.w-base.bw),base.bh,0,1,base.yScale);
		love.graphics.draw(base.img,bottomLeftCorner,0,(base.h-base.bh),0,1,1);
		love.graphics.draw(base.img,bottomBar,base.bw,(base.h-base.bh),0,base.xScale,1);
		love.graphics.draw(base.img,bottomRightCorner,(base.w-base.bw),(base.h-base.bh),0,1,1);
		love.graphics.popCanvas();
	end
	base.updateScaleFactors();
	base.updateCanvas();
	return base;
end