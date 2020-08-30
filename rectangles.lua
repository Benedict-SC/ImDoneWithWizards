Rect = function(x,y,w,h)
	local rect = {};
	rect.x = x;
	rect.y = y;
	rect.w = w;
	rect.h = h;
	rect.intersectsRect = function(r2)
		if (rect.x >= r2.x + r2.w) or (r2.x >= rect.x + rect.w) then 
			return false; 
		end
		if (rect.y >= r2.y + r2.h) or (r2.y >= rect.y + rect.h) then
			return false;
		end
		return true;
	end
	rect.almostIntersectsRect = function(r2,threshold)
		if (rect.x >= (r2.x-threshold) + (r2.w+2*threshold)) or (r2.x >= (rect.x-threshold) + (rect.w+2*threshold)) then 
			return false; 
		end
		if (rect.y >= (r2.y-threshold) + (r2.h+2*threshold)) or (r2.y >= (rect.y-threshold) + (rect.h+2*threshold)) then
			return false;
		end
		return true;
	end
	--these two functions assume top edge and left edge respectively- or more specifically, that the two aren't intersecting
	rect.isBelow = function(r2)
		return rect.y > r2.y;
	end
	rect.isRightOf = function(r2)
		return rect.x > r2.x;
	end
	rect.rectIntersection = function(r2)
		local intersects = rect.intersectsRect(r2);
		if not intersects then 
			return nil;
		end
		--we know it does intersect- let's get the rectangle that defines said intersection
		local topedge    = rect.y > r2.y and rect.y or r2.y;
		local leftedge   = rect.x > r2.x and rect.x or r2.x;
		local rightedge  = rect.x + rect.w < r2.x + r2.w and rect.x + rect.w or r2.x + r2.w;
		local bottomedge = rect.y + rect.h < r2.y + r2.h and rect.y + rect.h or r2.y + r2.h;
		local result = Rect(leftedge,topedge,rightedge-leftedge,bottomedge-topedge);
		return result;
	end
	rect.draw = function()
		love.graphics.setColor(1,1,1);
		love.graphics.rectangle("line",rect.x,rect.y,rect.w,rect.h);
	end
	return rect;
end