
local table_extension = {}

-- generic table functions

-- random choice from an array-like table
function table_extension.randomchoice(t)
	return t[math.random(#t)]
end

-- random choice from a table where keys are choices and values are weights
function table_extension.weightedchoice(t)
	local sum = 0
	for _, v in pairs(t) do
		assert(v >= 0, "weight value less than zero")
		sum = sum + v
	end
	assert(sum ~= 0, "all weights are zero")
	local rnd = lume.random(sum)
	for k, v in pairs(t) do
		if rnd < v then return k end
		rnd = rnd - v
	end
end

-- push tuple to array-like table
function table_extension.push(t, ...)
	local n = select("#", ...)
	for i = 1, n do
		table.insert(t, select(i, ...))
	end
	return ...
end

-- pop from array-like table
function table_extension.pop(t)
	local i = #t
	if i == 0 then
		return nil
	end
	return table.remove(t)
end

-- peek from array-like table
function table_extension.peek(t)
	local i = #t
	if i == 0 then
		return nil
	end
	return t[i]
end

-- shuffle an array-like table
function table_extension.shuffle(t)
	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
	return t
end

-- map each value by a function
function table_extension.map(t, fn)
	local rtn = {}
	for k, v in t do
		rtn[k] = fn(v)
	end
	return rtn
end

-- boolean check to see if all values in a table satisfy a function
function table_extension.all(t, fn)
	for _, v in t do
		if not fn(v) then return false end
	end
	return true
end

-- boolean check to see if any values in a table satisfy a function
function table_extension.any(t, fn)
	for _, v in t do
		if fn(v) then return true end
	end
	return false
end

-- additional generic table functions

-- .concat
-- .find
-- .slice .first .last (array like)
-- .deepcopy

-- implement standard lua table library

--clear(table: table): void  
--Sets all keys in the given table to nil. (added return of cleared table for convinience)
table_extension.clear = function(t)
	table.clear(t)
	return t
end

--clone(t: table): table  
--Returns a shallow copy of the provided table.
table_extension.clone = table.clone
table_extension.copy = table.clone

--concat(t: Array, sep: string, i: number, j: number): string  
--Returns the given range of table elements as a string where each element is separated by the given separator.
table_extension.concat = table.concat

--find(haystack: table, needle: Variant, init: number): Variant  
--Returns the index of the first occurrence of needle within haystack starting from init.
table_extension.find = table.find

--foreach(t: table, f: function): void  
--Iterates over the provided table, passing the key and value of each iteration over to the provided function.
table_extension.foreach = table.foreach

--foreachi(t: Array, f: function): void  
--Similar to table.foreach() except index-value pairs are passed instead of key-value pairs.
table_extension.foreachi = table.foreachi

--freeze(t: table): table  
--Makes the given table read-only.
table_extension.freeze = table.freeze

--isfrozen(t: table): boolean  
--Returns true if the given table is frozen and false if it isn't frozen.
table_extension.isfrozen = table.isfrozen

--getn(t: Array): number  
--Returns the number of elements in the table passed.
table_extension.getn = table.getn

--insert(t: Array, pos: number, value: Variant): void  
--Inserts the provided value to the target position of the array.

--insert(t: Array, value: Variant): void  
--Appends the provided value to the end of the array.
table_extension.insert = table.insert

--maxn(t: table): number  
--Returns the maximum numeric key of the provided table, or zero if the table has no numeric keys.
table_extension.maxn = table.maxn

--move(src: table, a: number, b: number, t: number, dst: table): table  
--Copies the specified range of elements from one table to another.
table_extension.move = table.move

--remove(t: Array, pos: number): Variant  
--Removes the specified element from the array, shifting later elements down to fill in the empty space if possible.
table_extension.remove = table.remove

--sort(t: Array, comp: function): void  
--Sorts table elements using the provided comparison function or the < operator.
table_extension.sort = table.sort

--pack(values...: Variant): Variant  
--Returns a new table containing the provided values.
table_extension.pack = table.pack

--unpack(list: table, i: number, j: number): Tuple  
--Returns all elements from the given list as a tuple.
table_extension.unpack = table.unpack



-- Arrays

-- array function library
local array_lib = {}

-- inheritance from generic table_extension
array_lib.randomchoice = table_extension.randomchoice
array_lib.push = table_extension.push
array_lib.pop = table_extension.pop
array_lib.peek = table_extension.peek
array_lib.shuffle = table_extension.shuffle
array_lib.all = table_extension.all
array_lib.any = table_extension.any

-- inheritance from luau table library in table_extension
array_lib.clear = table_extension.clear
array_lib.concat = table_extension.concat
array_lib.find = table_extension.find
array_lib.foreach = table_extension.foreachi
array_lib.foreachi = table_extension.foreachi
array_lib.insert = table_extension.insert
array_lib.remove = table_extension.remove
array_lib.sort = table_extension.sort
array_lib.getn = table_extension.getn
array_lib.maxn = table_extension.maxn
array_lib.sizeof = table_extension.maxn

local ARRAY = {
	__index = function(t, k)
		-- array lib functionalities
		if type(k) == "string" then
			local fn = array_lib[k]
			if fn then
				return function(...) return fn(t, ...) end
			end
			error("Undefined array member name: " .. tostring(k))
		end
	
		-- numerical indexing
		if type(k) == "number" then
			local v = rawget(t, k)
			if v then
				return v
			end
			error("Out of bounds index: " .. tostring(k))
		end
		
		error("Array indexed with non-string and non-number: " .. tostring(k))
	end;
	__newindex = function(t, k, v)
		error("newindex undefined for arrays. use .insert() instead")
	end;
}

-- clone/copy for arrays
function array_lib.clone(t)
	return setmetatable(table.clone(t), ARRAY)
end

array_lib.copy = array_lib.clone

-- map for arrays
function array_lib.map(t, fn)
	return setmetatable(table_extension.map(t, fn), ARRAY)
end

-- filter for arrays
function array_lib.filter(t, fn)
	return table_extension.filter(t, fn, false)
end

-- create a new array populated with many instances of the specified value.
function table_extension.create(count, value)
	return setmetatable(table.create(count, value), ARRAY)
end

-- give array functionality to an existing generic table
function table_extension.array(t)
	return setmetatable(t, ARRAY)
end

-- get an array of unique values
function table_extension.unique(t)
	local value_set = {}
	for _, v in t do
		value_set[v] = true
	end
	local rtn = {}
	for k in value_set do
		table.insert(rtn, k)
	end
	return setmetatable(rtn, ARRAY)
end

-- get an array of keys
function table_extension.keys(t)
	local rtn = {}
	for k in t do
		table.insert(rtn, k)
	end
	return setmetatable(rtn, ARRAY)
end

-- filter with a function
function table_extension.filter(t, fn, retainkeys)
	local rtn = {}
	if retainkeys then
		for k, v in t do
			if fn(v) then rtn[k] = v end
		end
	else
		for _, v in t do
		  if fn(v) then table.insert(rtn, v) end
		end
	end
	if retainkeys then
		return rtn
	else
		return setmetatable(rtn, ARRAY)
	end
end

-- merge a tuple of array-like tables together
function table_extension.merge(...)
	local rtn = {}
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t ~= nil then
			table.foreachi(t, function(i, v)
				table.insert(rtn, v)
			end)
		end
	end
	return setmetatable(rtn, ARRAY)
end

array_lib.unique = table_extension.unique
array_lib.keys = table_extension.keys
array_lib.merge = table_extension.merge



-- Sets

-- set function library
local set_lib = {}

set_lib.keys = table_extension.keys
set_lib.clear = table_extension.clear

set_lib.foreach = function(t, fn)
	t.keys().foreachi(function(_, v) fn(v) end)
end

set_lib.concat = function(t, sep)
	return t.keys().concat(sep)
end

set_lib.randomchoice = function(t)
	return table_extension.randomchoice(t.keys())
end

set_lib.add = function(t, item)
	rawset(t, item, true)
end

set_lib.remove = function(t, item)
	t[item] = nil
end

set_lib.has = function(t, item)
	if rawget(t, item) then
		return true
	end
	return false
end

set_lib.sizeof = function(t)
	return t.keys().sizeof()
end

set_lib.all = function(t, fn)
	return t.keys().all(fn)
end

set_lib.any = function(t, fn)
	return t.keys().any(fn)
end

local SET = {
	__index = function(t, k)
		-- set lib functionalities
		if type(k) == "string" then
			local fn = set_lib[k]
			if fn then
				return function(...) return fn(t, ...) end
			end
			error("(Use set.has() for indexing sets) Undefined set member name: " .. tostring(k))
		end
		
		error("Set indexed with non-string: " .. tostring(k))
	end;
	__newindex = function(t, k, v)
		error("newindex undefined for sets. use set.add() instead")
	end;
}

-- clone/copy for sets
function set_lib.clone(t)
	return setmetatable(table.clone(t), SET)
end

set_lib.copy = set_lib.clone

-- map for sets
function set_lib.map(t, fn)
	return table_extension.set(table_extension.map(t.keys(), fn))
end

-- filter for sets
function set_lib.filter(t, fn)
	return table_extension.set(table_extension.filter(t.keys(), fn, false))
end

-- set builder from generic array-like table
function table_extension.set(t)
	local rtn = {}
	table_extension.array(t).unique().foreach(function(k, v)
		rtn[v] = true
	end)
	return setmetatable(rtn, SET)
end



-- Hashes

local hash_lib = {}

hash_lib.remove = (function(t, k)
	local prev_v = t[k]
	if prev_v == nil then
		return nil
	end
	
	local cleanup_fn = getmetatable(t).cleanup_fn
	if cleanup_fn then
		cleanup_fn(prev_v)
	end

	rawset(t, k, nil)
	return t
end)

hash_lib.add = function(t, k, v)
	if type(k) ~= "userdata" and type(k) ~= "table" then
		error("add called with non-userdata non-table key " .. tostring(k))
	end

	local prev_v = t[k]
	if prev_v then
		hash_lib.remove(t, k)
	end

	rawset(t, k, v)
	return t
end

hash_lib.setCleanup = function(t, fn)
	assert(type(fn) == "function", "fn not a function in .setCleanup")
	getmetatable(t).cleanup_fn = fn
	return t
end

local HASH = {
	__index = function(t, k)
		-- normally indexing the hash for values
		if type(k) == "userdata" or type(k) == "table" then
			local v = rawget(t, k)
			return v
		end
	
		-- hash lib functionalities
		if type(k) == "string" then
			local fn = hash_lib[k]
			if fn then
				return function(...) return fn(t, ...) end
			end
			error("Undefined hash member name: " .. tostring(k))
		end
		
		error("Hash indexed with non-string, non-userdata, non-table: " .. tostring(k))
	end;
	__newindex = function(t, k, v)
		error("newindex undefined for hash. use hash.add() instead")
	end;
}

table_extension.hash = function()
	local t = {}
	return setmetatable(t, {
		__index = HASH.__index;
		__newindex = HASH.__newindex;
		-- hash-specific cleanup function stored here
	})
end

return table_extension
