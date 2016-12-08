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
		local val = arr[arr.size];
		arr.size = arr.size - 1;
		return val;
	end
	arr.peek = function()
		return arr[arr.size];
	end
	return arr;
end