--parse formatted text (<c=hex>, <f=implicitly-tff>, <s=pixels>, <i> and <b> tags) into a series of strings with associated formatting data
--using that string collection, draw formatted text into a rectangle

TextDrawer = function (rect,fstrings,chars)
	local td = {};
	td.rect = rect;
	td.fstrings = fstrings and fstrings or nil;
	td.charsDrawn = chars and chars or 0;
	
	td.setLocation = function(x,y)
		td.rect.x = x;
		td.rect.y = y;
	end

	td.draw = function()
		local fullchars = math.floor(td.charsDrawn);
		--local canv = love.graphics.newCanvas(rect.w,rect.h);
		--love.graphics.pushCanvas(canv);
		if DEBUG_TEXTRECT then
			love.graphics.setColor(255,255,255);
			love.graphics.rectangle("line",rect.x,rect.y,rect.w,rect.h);
		end
		--first count how many fstrings can be drawn in their entirety
		local charsleft = fullchars;
		local fulldraws = 0;
		for i = 1,#td.fstrings,1 do
			local text = td.fstrings[i].text;
			if charsleft >= #text then
				fulldraws = fulldraws + 1;
				charsleft = charsleft - #text;
			else
				break;
			end
		end
		--draw the full strings
		local lastX = 0; --track where our last string ended
		local lastY = 0;
		for i=1,fulldraws+1,1 do
			local isCut = false;
			if i == fulldraws+1 then
				--draw the incomplete string, if applicable
				if fulldraws < #td.fstrings and charsleft > 0 then
					isCut = true;
					--error("[" .. td.fstrings[i].text:sub(1,charsleft) .. "]");
				else 
					--error("chars left is " .. charsleft)
					break;
				end
			end
			local fstring = td.fstrings[i];
			local ftext = isCut and fstring.text:sub(1,charsleft) or fstring.text;
			local size = fstring.props.size and fstring.props.size or 12;
			local font = love.graphics.newFont(size);			
			if fstring.props.font then --actually get font from formatting data
				local jsonstring = love.filesystem.read("fonts/" .. fstring.props.font .. ".json");
				local fontdata = json.decode(jsonstring);
				local fontstring = fontdata.regular;
				if fstring.props.bold and fstring.props.italic then
					fontstring = fontdata.both;
				elseif fstring.props.bold then
					fontstring = fontdata.bold;
				elseif fstring.props.italic then
					fontstring = fontdata.italic;
				end
				font = love.graphics.newFont("fonts/"..fontstring,size);
			end
			love.graphics.setFont(font);
			
			if not fstring.props.color then
				love.graphics.setColor(0,0,0);
			else
				love.graphics.setColor(fstring.props.color.red,fstring.props.color.green,fstring.props.color.blue,fstring.props.color.alpha);
			end
			
			local width = font:getWidth(ftext);
			local height = font:getHeight(ftext);
			
			if width + lastX <= td.rect.w then
				love.graphics.print(ftext,rect.x+lastX,rect.y+lastY);
				lastX = lastX + width;
			else
				--local midcount = 0;
				while width + lastX > td.rect.w do
					--if midcount > 1000 then error ("trying to write [" .. ftext .. "], width+lastX is " .. width .. "+" ..lastX ); end
					--midcount = midcount + 1;
					local words = splitSpaces(ftext,true);
					--each step, join some number of things into a string and measure that
					local j = #words - 1;
					local drew = false;
					while j > 0 do
						local trytext = table.concat(subArray(words,1,j)," ");
						--if #words == 13 and j == 2 then error("lastx is " .. lastX) end
						width = font:getWidth(trytext);
						if width + lastX <= td.rect.w then --this string fits, so let's draw it and send the rest back through
							if lastX == 0 then trytext = trimLeadingSpaces(trytext); end
							love.graphics.print(trytext,rect.x+lastX,rect.y+lastY);
							drew = true;
							lastY = lastY + height;
							lastX = 0;
							ftext = table.concat(subArray(words,j+1,#words-j)," ");
							--if i == fulldraws+1 then error(trytext .. " written, remaining: [" .. ftext.."]" ) end
							width = font:getWidth(ftext);
							break;
						end
						j = j-1;
					end
					if not drew then
						width = font:getWidth(ftext);
						if lastX == 0 then 
							lastY = lastY+height;						
							love.graphics.print(ftext,rect.x+lastX,rect.y+lastY);
						end
						lastY = lastY+height;
						lastX = 0;
					end
				end
				if ftext:sub(1,1) == " " then --strip leading spaces on a new line
					ftext = ftext:sub(2);
				end
				love.graphics.print(ftext,rect.x+lastX,rect.y+lastY);
				width = font:getWidth(ftext);
				lastX = lastX + width;
			end
		end
		

		love.graphics.setColor(255,255,255);
		--love.graphics.popCanvas();
		--return canv;
	end
	return td;
end

love.font.formattedStringLength = function(fstrings)
	local charcount = 0;
	for i=1,#fstrings,1 do
		charcount = charcount + #(fstrings[i].text);
	end
	return charcount;
end
love.font.formattedStringWidth = function(fstrings)
	local oldFont = love.graphics.getFont();
	local width = 0;
	for i=1,#fstrings,1 do
		local fstring = fstrings[i];
		local ftext = fstring.text;
		local size = fstring.props.size and fstring.props.size or 12;
		local font = love.graphics.newFont(size);			
		if fstring.props.font then --actually get font from formatting data
			local jsonstring = love.filesystem.read("fonts/" .. fstring.props.font .. ".json");
			local fontdata = json.decode(jsonstring);
			local fontstring = fontdata.regular;
			if fstring.props.bold and fstring.props.italic then
				fontstring = fontdata.both;
			elseif fstring.props.bold then
				fontstring = fontdata.bold;
			elseif fstring.props.italic then
				fontstring = fontdata.italic;
			end
			font = love.graphics.newFont("fonts/"..fontstring,size);
		end
		love.graphics.setFont(font);
		local fragWidth = font:getWidth(ftext);
		width = width + fragWidth;
	end
	love.graphics.setFont(oldFont);
	return width;
end

love.font.getFormattedStrings = function(ftext)
	local state = "CONTENT";
	local tokenlist = Array();

	local contentString = "";
	local tagString = "";
	for i=1,#ftext,1 do
		local char = ftext:sub(i,i);
		if char == "<" then
			state = "TAG";
			tokenlist.push({tag=false,str=contentString});
			tagString = "";
		elseif char == ">" then
			state = "CONTENT";
			tokenlist.push({tag=true,str=tagString,terminate=(tagString:sub(1,1) == "/")});
			contentString = "";
		else
			if state == "TAG" then
				tagString = tagString .. char;
			else
				contentString = contentString .. char;
				if i == #ftext then
					tokenlist.push({tag=false,str=contentString});
				end
			end
		end
	end
	--we now have a list of tokens
	local tagstack = Array();
	local fstringlist = Array();
	for i=1,#tokenlist,1 do
		local token = tokenlist[i];
		if token.tag then
			if token.terminate then
				tagstack.pop();
			else
				if not token.str then error("tag has no string"); end
				tagstack.push(token.str);
			end
		else
			--create the string with the tag data
			local tagsCopy = table.shallowcopy(tagstack);
			local fstring = love.font.createFstring(tagsCopy,token.str);
			if #(fstring.text) > 0 then
				fstringlist.push(fstring);
			end
		end
	end
	return fstringlist;
end
love.font.createFstring = function(tstack,str)
	local props = {
		size = nil;
		font = nil;
		color = nil;
		bold = false;
		italic = false;
	}
	while #tstack > 0 do
		local tagstring = table.remove(tstack,#tstack);
		local kind = tagstring:sub(1,1);
		if kind == "c" then
			if not props.color then
				props.color = {red=0,green=0,blue=0,alpha=255}
				local hexstring = tagstring:sub(4);
				if #hexstring < 6 then error("bad hex code") end;
				props.color.red = tonumber(hexstring:sub(1,2),16);
				props.color.green = tonumber(hexstring:sub(3,4),16);
				props.color.blue = tonumber(hexstring:sub(5,6),16);
				if #hexstring == 8 then
					props.color.alpha = tonumber(hexstring:sub(7,8),16);
				end
			end
		elseif kind == "f" then
			if not props.font then
				props.font = tagstring:sub(3);
			end
		elseif kind == "s" then
			if not props.size then
				props.size = tonumber(tagstring:sub(3),10);
			end
		elseif kind == "b" then
			props.bold = true;
		elseif kind == "i" then
			props.italic = true;
		else
			error("bad tag");
		end
	end
	return {text=str,props=props};
end
