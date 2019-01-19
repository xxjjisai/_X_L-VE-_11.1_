_G.Class = {};

function Class:DeriveClass(sClassName)
    local obj={};
	obj.sClassName = sClassName;
	obj.tbListenerList = {};
	obj.nUniqueID = Origin:SetUniqueID();
	setmetatable(obj,{__index = self});
	return obj;
end  

function Class:GetClassName()
	return self.sClassName;
end

function Class:Trace(nType,...)
	local sType = "[Log] ";
	if nType == 1 then 
		sType = "[Log] " 
	elseif nType == 2 then 
		sType = "[Warn] " 
	elseif nType == 3 then 
		sType = "[Error] " 
	else 
		sType = "[Log] "
	end  

    local args = {...};
	if type(args[1]) == "table" then 
		print("[~~~~~~~~~~~~~~~~"..self.sClassName.."~~~~~~~~~~~~~~~~] start >> ",sType);
		print_lua_table(args[1]);
		print("[~~~~~~~~~~~~~~~~"..self.sClassName.."~~~~~~~~~~~~~~~~] end << ",sType);
		return 
	end  
    local str = "["..self.sClassName.." "..os.date("%c").."] "..sType;
	for i,v in ipairs(args) do 
		str = str..tostring(v).." ";
	end

	print(str.."");

	if Option.bLog then 
		local file = io.open('gc.log', 'a')
		if file ~= nil then 
			file:write(str.."\n");
			file:close();
		end
	end
end

function Class:Error(nCode,...)
	local args = {...};
	local str = "["..self.sClassName.."=>"..os.date("%c").."] ";
	for i,v in ipairs(args) do 
		str = str..v.." ";
	end
	error(str.."nErrorCode:"..nCode);
	
	if Option.bLog then 
		local file = io.open('gc.log', 'a')
		if file ~= nil then 
			file:write(str.."nErrorCode:"..nCode.."\n");
			file:close();
		end
	end
end