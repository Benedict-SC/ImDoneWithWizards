nilf = function()

end
signof = function(number)
	if number > 0 then return 1 elseif number < 0 then return -1 else return 0 end
end
splitSpaces = function(str,preserveEnds)
	local tokens = Array();
	for token in string.gmatch(str, "%S+") do
		tokens.push(token);
	end
	if preserveEnds then 
		if str:sub(1,1) == " " then
			tokens[1] = " "..tokens[1];
		end
		if str:sub(#str,#str) == " " then
			tokens[#tokens] = tokens[#tokens].." ";
		end
	end
	return tokens;
end
trimSpaces = function(str)
	str = trimLeadingSpaces(str);
	while str:sub(#str,#str) == " " do
		str = str:sub(1,#str-1);
	end
	return str;
end
trimLeadingSpaces = function(str)
	while str:sub(1,1) == " " do
		str = str:sub(2);
	end
	return str;
end
subArray = function(array,startIndex,length)
	startIndex = startIndex or 1;
	maxIndex = startIndex - 1 + length;
	local subarray = Array();
	if maxIndex > #array then maxIndex = #array; end
	for i=startIndex,maxIndex,1 do
		subarray.push(array[i]);
	end
	return subarray;
end
contains = function(array,value)
	for i=1,#array,1 do
		if array[i] == value then return true; end
	end
	return false;
end
indexNames = function(tabl)
	for i=1,#tabl,1 do
		local obj = tabl[i];
		if obj.name then
			tabl[obj.name] = obj;
		end
	end
end
Array = function(...)
	local arr = {};
	local argnum = select("#",...);
	if argnum > 0 then
		for i = 1, argnum do
			arr[i] = select(i,...);
		end
	end
	arr.size = arg.n or 0;
	arr.push = function(el)
		arr.size = arr.size + 1;
		arr[arr.size] = el;
	end
	arr.pop = function()
		local initsize = #arr;
		local val = table.remove(arr,arr.size);
		if #arr >= initsize then error("failed to reduce size") end
		--local val = arr[arr.size];
		--arr[arr.size] = nil;
		arr.size = arr.size - 1;
		return val;
	end
	arr.peek = function()
		return arr[arr.size];
	end
	arr.insert = function(element,index)
		local i = arr.size + 1;
		while i > index do
			arr[i] = arr[i-1];
			i = i - 1;
		end
		arr[index] = element;
		arr.size = arr.size + 1;
	end
	arr.contains = function (element)
		for i=1,arr.size,1 do 
			if arr[i] == element then return true; end
		end
		return false;
	end
	arr.indexOf = function(element)
		for i=1,arr.size,1 do 
			if arr[i] == element then return i end
		end
		return -1;
	end
	arr.remove = function(index)
		local element = table.remove(arr,index);
		arr.size = arr.size - 1;
		return element;
	end
	arr.removeElement = function(element)
		local idx = arr.indexOf(element);
		if idx == -1 then
			return nil;
		end
		return arr.remove(idx);
	end
	return arr;
end
colorStack = Array();
pushColor = function()
	local r,g,b,a = love.graphics.getColor();
	local col = {r=r,g=g,b=b,a=a};
	colorStack.push(col);
end
popColor = function()
	local col = colorStack.pop();
	love.graphics.setColor(col.r,col.g,col.b,col.a);
end