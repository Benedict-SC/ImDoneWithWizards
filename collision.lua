collision = {};
Collider = function(xoff,yoff,w,h)
	local coll = {};
	coll.xOffset = xoff;
	coll.yOffset = yoff;
	coll.width = w;
	coll.height = h;
	coll.rect = function()
		return Rect(coll.owner.x+coll.xOffset,coll.owner.y+coll.yOffset,coll.width,coll.height);	
	end
	coll.collidesWith = function(collider)
		local cr2 = Rect(collider.owner.x+collider.xOffset,collider.owner.y+collider.yOffset,collider.width,collider.height);
		return coll.rect().intersectsRect(cr2);
	end
	coll.almostCollidesWith = function(collider)
		local cr2 = Rect(collider.owner.x+collider.xOffset-1,collider.owner.y+collider.yOffset-1,collider.width+2,collider.height+2);
		return coll.rect().intersectsRect(cr2);
	end
	coll.collisionZone = function(collider)
		local cr2 = Rect(collider.owner.x+collider.xOffset,collider.owner.y+collider.yOffset,collider.width,collider.height);
		return coll.rect().rectIntersection(cr2);
	end
	coll.drawRect = function()
		love.graphics.setColor(255,255,255);
		love.graphics.rectangle("line",coll.owner.x+coll.xOffset,coll.owner.y+coll.yOffset,coll.width,coll.height);
	end
	coll.offsetGeneratedSpriteCollider = function(xoff,yoff,w,h)
		if xoff then coll.xOffset = coll.xOffset + xoff end
		if yoff then coll.yOffset = coll.yOffset + yoff end
		if w then coll.width = w end
		if h then coll.height = h end
	end
	return coll;
end
collision.giveColliderBasedOnSprite = function(thing)
	collision.giveColliderWithNameBasedOnSprite("collider",thing);
end
collision.giveColliderWithNameBasedOnSprite = function(name,thing)
	local w = thing.img and thing.img:getWidth() or thing.canvas:getWidth();
	local h = thing.img and thing.img:getHeight() or thing.canvas:getHeight();
	thing[name] = Collider(-w/2,-h,w,h);
	thing[name].owner = thing;
end
collision.giveExplicitCollider = function(thing,xoff,yoff,w,h)
	thing.collider = Collider(xoff,yoff,w,h);
	thing.collider.owner = thing;
	--[[thing.collider.oldDraw = thing.collider.drawRect;
	thing.collider.drawRect = function() 
		love.graphics.setColor(0,255,128);
		love.graphics.rectangle("line",coll.owner.x+coll.xOffset,this.collider.owner.y+coll.yOffset,coll.width,coll.height);	
	end]]--s
end