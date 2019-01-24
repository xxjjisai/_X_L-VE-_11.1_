-- 碰撞检测（原形）
function hitTestObject(obj1,obj2)
    if obj1 == nil or obj2 == nil then return false end 
	if obj1.x + obj1.w > obj2.x and obj1.x < obj2.x + obj2.w and
	   obj1.y + obj1.h > obj2.y and obj1.y < obj2.y + obj2.h then
	   return true
	end
	return false
end

function GetTime()
    -- return socket.gettime()
    -- return os.time();
    return os.clock();
end

-- 碰撞检测（原形）
function TestCollision(a,b)
    if a == nil or b == nil then return false end; 

    local ax = 0;
    local ay = 0;
    local aw = 0;
    local ah = 0;    
    local bx = 0;
    local by = 0;
    local bw = 0;
    local bh = 0;

    if a.GetiCompo then 
        ax = a:GetiCompo("Position").x;
        ay = a:GetiCompo("Position").y;   
        aw = a:GetiCompo("Size").w;
        ah = a:GetiCompo("Size").h;   
    else 
        ax = a.x;
        ay = a.y;   
        aw = a.w;
        ah = a.h;  
    end 

    if b.GetiCompo then
        bx = b:GetiCompo("Position").x;
        by = b:GetiCompo("Position").y;   
        bw = b:GetiCompo("Size").w;
        bh = b:GetiCompo("Size").h;   
    else 
        bx = b.x;
        by = b.y;   
        bw = b.w;
        bh = b.h;  
    end 

    if ax + aw > bx and ax < bx + bw and ay + ah > by and ay < by + bh then 
        return true;
    end

    return false;
end 

-- 分离轴定理检测基本矩形（非旋转）
function SatTestCollision(a,b)
    local tbA = {};
    tbA[1] = a.y;
    tbA[2] = a.x;
    tbA[3] = a.y + a.h;
    tbA[4] = a.x + a.w;

    local tbB = {};
    tbB[1] = b.y;
    tbB[2] = b.x;
    tbB[3] = b.y + b.h;
    tbB[4] = b.x + b.w;

    table.sort( tbA,function (a,b)
        return a < b;
    end)

    table.sort( tbB,function (a,b)
        return a < b;
    end)

    local min_a = tbA[1];
    local max_a = tbA[#tbA];

    local min_b = tbB[1];
    local max_b = tbB[#tbB];

    -- todo 没写完
end 

function MathRound(value)
    value = tonumber(value) or 0
    return math.floor(value + 0.5)
end

function string_split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end
 
    return sub_str_tab;
end

-- print++
function trace(data,cstring,deepIndex)  --第二个参数可以为空，第三个参数不要手动添加，它是用来进行打印深度控制的。
    if data == nil then   
        print("core.print data is nil");  
    end

    if deepIndex == nil then deepIndex = 1 end
    if cstring == nil then cstring = "" end

    local cs = cstring .. " ";  
    if(type(data)=="table") then  
        print(cstring .."{");  
        for k, v in pairs(data) do  
            if(type(v) == "table") then print(cs..tostring(k).." = ");
                else print("\t"..cs..tostring(k).." = "..tostring(v)..","); end

                if(type(v)=="table") then

                if (deepIndex + 1) < 5 then  --5就是控制的打印深度(你可以根据需要调整)，以防数据结构中存在循环饮用(别以为不可能，我就遇到过)
                    trace(v,cs,(deepIndex+1));
                else
                    print("\t"..cs.." {"..tostring(v).."}\n");
                end
            end  
        end  
        print(cstring .."}");  
    else  
        print(cs..tostring(data));  
    end  
 end

-- print#
 function print_lua_table (lua_table, indent,pfn)
  if pfn == nil then
    pfn = print
  end

  local indent = indent or 0
  if type(lua_table) ~= 'table'then
    pfn(debug.traceback("print_lua_table failed not a table ")) ;
    return
  end

  for kk, v in pairs(lua_table) do
    local k = kk;
    -- if type(k) == "string" then
    --  k = string.format("%q", k)
    -- end
    local szSuffix = ""
    local formatting = ""
    if type(v) == "table" then
      szSuffix = "{"
    end
    local szPrefix = string.rep("    ", indent)
    formatting = szPrefix.."['"..k.."']".." = "..szSuffix
    if type(v) == "table" then
      pfn(formatting)
      print_lua_table(v, indent + 1,pfn);
      pfn(szPrefix.."},")
    else
      local szValue = ""
      if type(v) == "string" then
        szValue = string.format("%q", v)
      else
        szValue = tostring(v)
      end
      pfn(formatting..szValue..",")
    end
  end
end

-- string ת table
-- ex: a = "a,b"
-- tmp_table = StringSplit_ToTable(a,",")

--��ӡtt�ĵ�Ԫ����
-- print(#self.letter)
--��ӡ�ָ�����Ԫ����
-- for _,v in pairs(self.letter) do
	-- print(v)
	-- local tmp_table = loadstring('return '..v)()
	-- for i = 1 , #tmp_table do
		-- print(tmp_table[i])
	-- end
-- end
function StringSplit_ToTable(str,split)
	local tab = {}
	local b=0
	while true do
		s,e= string.find(str,split,b)
		if s then
			local temp = string.sub(str,b,s-1)
			table.insert(tab,temp)
			b=s+string.len(split)
		else
			local temp = string.sub(str,b,-1)
			if temp ~= "" then
				table.insert(tab,temp)
			end
			break
		end
	end
	return tab
end

function Dist(ax,ay,bx,by)  
    local pax = (ax - bx) * (ax - bx);
    local pay = (ay - by) * (ay - by); 
    local result = math.sqrt((pax + pay)); 
    return result;
end

-- ����֮���ľ���
function pointdistance(p1,p2)
	local x = p1.x - p2.x
	local y = p1.y - p2.y
	local length = math.sqrt(math.pow(x,2)+math.pow(y,2))
	return length
end

-- ɾ�������е�Ԫ�أ���ͬ��Ŀ������Ҫ�����޸ģ�
--http:--www.tuicool.com/articles/mY7Rzi
-- for k, v in pairs( remove ) do
    -- removeItem(test, k)
-- end
function removeTableData(dataTabel,name)  
    -- body  
    if dataTabel ~= nil then  
        --todo  
        for i = #dataTabel, 1, -1 do  
            if dataTabel[i] ~= nil then  
                if dataTabel[i].name == name then
                	table.remove(dataTabel, i) 
                end 
            end  
        end  
    end  
end  

function deleteItem(list,id)
	local rmCount = 0
	for i = 1,#list do
		local obj = list[i - rmCount]
		if obj ~= nil then
			if obj.id == id then
				table.remove(list,i-rmCount)
			end
		end
	end
end

-- 随机从某个数组中获取元素
function getRandom(arr)
	return arr[math.floor(math.random(1,#arr))]
end

-- 随机排序
--http:--blog.csdn.net/zcl1804742527/article/details/52317399
function i3k_shuffle(tbl)
    local n = #tbl
    for i = 1, n do
        local j = math.random(i, n)
        if j > i then
            tbl[i], tbl[j] = tbl[j], tbl[i]
        end
    end
end

-- 获取最大值
function table_maxn(t)
    local mn = 0
    for k, v in pairs(t) do
        if mn < k then
            mn = k
        end
    end
    return mn
end

-- 二分法查找 返回true or false 有问题 只能查找第一个
-- t -- 有序数组
-- v -- t 中的某个值
function BinarySearch(tbArr,val)
	local count = #tbArr;
	local low = 1;
	local high = count - 1;
	while low <= high do 
		local mid = math.floor((low + high)/2);
		if tbArr[mid] == val then 
			return mid;
		elseif tbArr[mid] < val then 
			low = mid + 1;
		else 
			high = mid - 1;
		end
	end 
	return -1;
end

-- 打印一个table
function print_lua_table (lua_table, indent,pfn)
  if pfn == nil then
    pfn = print
  end

  local indent = indent or 0
  if type(lua_table) ~= 'table'then
    pfn(debug.traceback("print_lua_table failed not a table ")) ;
    return
  end

  for kk, v in pairs(lua_table) do
    local k = kk;
    -- if type(k) == "string" then
    --  k = string.format("%q", k)
    -- end
    local szSuffix = ""
    local formatting = ""
    if type(v) == "table" then
      szSuffix = "{"
    end
    local szPrefix = string.rep("    ", indent)
    formatting = szPrefix.."['"..k.."']".." = "..szSuffix
    if type(v) == "table" then
      pfn(formatting)
      print_lua_table(v, indent + 1,pfn);
      pfn(szPrefix.."},")
    else
      local szValue = ""
      if type(v) == "string" then
        szValue = string.format("%q", v)
      else
        szValue = tostring(v)
      end
      pfn(formatting..szValue..",")
    end
  end
end

-- 去除重复元素
-- http://blog.csdn.net/mobiledreamworks/article/details/47613953
function removeRepeatElementFromArray(list)
    local count = 0;
    local newArray = {};
    for i = 1,#list do 
        for j = i + 1,#list do 
            if list[i] == list[j] then 
                list[i] = "#";
                break;
            end 
        end 
    end 

    for index = 1,#list do 
        if "#" ~= list[index] then 
            count = count + 1;
            newArray[count] = list[index]
        end 
    end 

    return newArray;
end 

-- 二分法查找(有改动)
-- http://blog.csdn.net/mobiledreamworks/article/details/47613953
--[[
    用法：
    local heights = {180,100,1000,1021,102,103,302};
    table.sort(heights);
]]
function binarySearch(srcArray,des)
    local low = 1;
    local high = #srcArray;
    if srcArray[des] == des then return des end;
    while ((low <= high) and (low <= #srcArray) and (high <= #srcArray) ) do 
        local middle = low + ((high)%2);
        if des == srcArray[middle] then 
            return middle;
        elseif des < srcArray[middle] then 
            high = middle - 1;
        else 
            low = middle + 1;
        end 
        return -1;
    end 
end

-- 冒泡排序
-- http://blog.csdn.net/mobiledreamworks/article/details/47613953
-- local heights = {180,100,1000,1021,102,103,302};
function bubbleSort(array)
    local temp = 0;
    for i = 1,#array -1 do 
        for j = 1,#array - i do 
            if (array[j + 1] < array[j]) then 
                temp = array[j];
                array[j] = arrayp[j + 1];
                array[j + 1] = temp;
            end 
        end 
    end 
    return array;
end  
--[[
-- 深度克隆一个值
-- example:
-- 1. t2是t1应用,修改t2时，t1会跟着改变
    local t1 = { a = 1, b = 2, }
    local t2 = t1
    t2.b = 3    -- t1 = { a = 1, b = 3, } == t1.b跟着改变
    
-- 2. clone() 返回t1副本，修改t2,t1不会跟踪改变
    local t1 = { a = 1, b = 2 }
    local t2 = clone( t1 )
    t2.b = 3    -- t1 = { a = 1, b = 3, } == t1.b不跟着改变
    
-- @param object 要克隆的值
-- @return objectCopy 返回值的副本
--]]
function clone( object )
    local lookup_table = {}
    local function copyObj( object )
        if type( object ) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs( object ) do
            new_table[copyObj( key )] = copyObj( value )
        end
        return setmetatable( new_table, getmetatable( object ) )
    end
    return copyObj( object )
end

function table.show(t, name, indent)
    local cart     -- a container
    local autoref  -- for self references
 
    -- (RiciLake) returns true if the table is empty
    local function isemptytable(t) return next(t) == nil end
 
    local function basicSerialize (o)
       local so = tostring(o)
       if type(o) == "function" then
          local info = debug.getinfo(o, "S")
          -- info.name is nil because o is not a calling level
          if info.what == "C" then
             return string.format("%q", so .. ", C function")
          else 
             -- the information is defined through lines
             return string.format("%q", so .. ", defined in (" ..
                 info.linedefined .. "-" .. info.lastlinedefined ..
                 ")" .. info.source)
          end
       elseif type(o) == "number" or type(o) == "boolean" then
          return so
       else
          return string.format("%q", so)
       end
    end
 
    local function addtocart (value, name, indent, saved, field)
       indent = indent or ""
       saved = saved or {}
       field = field or name
 
       cart = cart .. indent .. field
 
       if type(value) ~= "table" then
          cart = cart .. " = " .. basicSerialize(value) .. ";\n"
       else
          if saved[value] then
             cart = cart .. " = {}; -- " .. saved[value] 
                         .. " (self reference)\n"
             autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
          else
             saved[value] = name
             --if tablecount(value) == 0 then
             if isemptytable(value) then
                cart = cart .. " = {};\n"
             else
                cart = cart .. " = {\n"
                for k, v in pairs(value) do
                   k = basicSerialize(k)
                   local fname = string.format("%s[%s]", name, k)
                   field = string.format("[%s]", k)
                   -- three spaces between levels
                   addtocart(v, fname, indent .. "   ", saved, field)
                end
                cart = cart .. indent .. "};\n"
             end
          end
       end
    end
 
    name = name or "__unnamed__"
    if type(t) ~= "table" then
       return name .. " = " .. basicSerialize(t)
    end
    cart, autoref = "", ""
    addtocart(t, name, indent)
    return cart .. autoref
 end



 

-- 本文来自 武凯凯 的CSDN 博客 ，全文地址请点击：https://blog.csdn.net/w18756901575/article/details/74982666?utm_source=copy 
 function shuffle(t)
    math.randomseed(os.time())
    if type(t)~="table" then
        return
    end
    local tab={}
    local index=1
    while #t~=0 do
        local n=math.random(0,#t)
        if t[n]~=nil then
            tab[index]=t[n]
            table.remove(t,n)
            index=index+1
        end
    end
    return tab
end

-- https://www.cnblogs.com/kane0526/p/3992032.html
function toSerial(s)
    if type(s)=="number"  then
        io.write(s)
    elseif  type(s)=="string" then
        io.write(string.format("%q",s))
    elseif type(s)=="table" then
        io.write('{\n')
        for i, v in pairs(s) do
            io.write('[') toSerial(i) io.write(']=')
            toSerial(v)
            io.write(',\n')
        end
        io.write('}\n')
    end
 end

--  https://www.jb51.net/article/55716.htm

function serialize (o)  
    local str_serialize = str_serialize or ""  
    if o == nil then  
        io.write("nil")  
        str_serialize = str_serialize.."nil"  
        return  str_serialize
    end  
    if type(o) == "number" then  
        io.write(o)  
        str_serialize = str_serialize..o  
    elseif type(o) == "string" then  
        io.write(string.format("%q", o))  
        str_serialize = str_serialize..string.format("%q", o)  
    elseif type(o) == "table" then  
        io.write("{\n")  
        str_serialize = str_serialize.."{\n"  
        for k,v in pairs(o) do  
            print(str_serialize)
            io.write(" [");  
            str_serialize = str_serialize.." ["  
            serialize(k);  
            io.write("] = ")  
            str_serialize = str_serialize.."] = "  
            serialize(v)  
            io.write(",\n")  
            str_serialize = str_serialize..",\n"  
        end  
        io.write("}")  
        str_serialize = str_serialize.."}"  
    elseif type(o) == "boolean" then  
        io.write( o and "true" or "false" )  
        str_serialize = str_serialize..(o and "true" or "false")  
    elseif type(o) == "function" then  
        io.write( "function" )  
        str_serialize = str_serialize.."function"  
    else  
        error("cannot serialize a " .. type(o))  
    end  
    return  str_serialize
end  

-- 吃亏弹性指数
function ChiKuiZhiShu(nZongShu,nChiKuiShu)
    if nChiKuiShu == 0 then 
        nChiKuiShu = 0.000000001;
    end 
    return math.ceil( 1/(nChiKuiShu/nZongShu) - 1)
end 

function table.elem_swap(table, r1, r2)
    assert(r1 ~= r2, false);
    local temp = table[r1];
    if r2 < r1 then             -- To left
        for i = r1, r2 + 1, -1 do
            table[i] = table[i - 1];
        end
        table[r2] = temp;
        temp = nil;
        return true;
    elseif r2 > r1 then         -- To right
        for i = r1, r2 - 1 do
            table[i] = table[i + 1];
        end
        table[r2] = temp;
        temp = nil;
        return true;
    end
    return false;
end