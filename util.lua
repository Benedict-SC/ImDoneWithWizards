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
	if preserveEnds and tokens[1] then 
		if str:sub(1,1) == " " then
			tokens[1] = " " .. tokens[1];
		end
		if str:sub(#str,#str) == " " and #tokens > 0 then
			tokens[#tokens] = tokens[#tokens].." ";
		end
	end
	return tokens;
end
countWords = function(str)
	local num = 0;
	for token in string.gmatch(str, "%S+") do
		num = num + 1;
	end
	return num;
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
indexByVarName = function(tabl,name)
	for i=1,#tabl,1 do
		local obj = tabl[i];
		if obj[name] then
			tabl[obj[name]] = obj;
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
	arr.size = function()
		return #arr;
	end
	arr.push = function(el)
		arr[(#arr + 1)] = el;
	end
	arr.pop = function()
		local initsize = #arr;
		local val = table.remove(arr,#arr);
		if #arr >= initsize then error("failed to reduce size") end
		--local val = arr[arr.size];
		--arr[arr.size] = nil;
		return val;
	end
	arr.peek = function()
		if #arr < 1 then return nil; end
		return arr[#arr];
	end
	arr.insert = function(element,index)
		local i = #arr + 1;
		while i > index do
			arr[i] = arr[i-1];
			i = i - 1;
		end
		arr[index] = element;
	end
	arr.contains = function (element)
		for i=1,#arr,1 do 
			if arr[i] == element then return true; end
		end
		return false;
	end
	arr.indexOf = function(element)
		for i=1,#arr,1 do 
			if arr[i] == element then return i end
		end
		return -1;
	end
	arr.remove = function(index)
		local element = table.remove(arr,index);
		return element;
	end
	arr.removeElement = function(element)
		local idx = arr.indexOf(element);
		if idx == -1 then
			return nil;
		end
		return arr.remove(idx);
	end
	arr.forEach = function(func) --function takes one argument- the array element
		for i=1,#arr,1 do
			func(arr[i]);
		end
	end
	return arr;
end
ArrayFromRawArray = function(array)
	local arr = Array();
	if not array then
		return arr;
	end
	for i=1,#(array),1 do
		arr.push(array[i]);
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
printInColor = function(str,x,y,r,g,b,a)
	pushColor();
	love.graphics.setColor(r or 255,g or 255,b or 255,a or 255);
	love.graphics.setShader(textColorShader);
	love.graphics.print(str,x,y);
	love.graphics.setShader();
	popColor();
end