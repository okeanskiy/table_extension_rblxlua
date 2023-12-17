
local table = require(game.ReplicatedStorage.Common.table_extension)

local fruits = table.array{"Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew", "Kiwi", "Lemon"}

print(fruits.concat(" "))

local shuffled_fruits = fruits.clone().shuffle()
print(shuffled_fruits.concat(" "))
print(fruits.concat(" "))

local random_choice = fruits.randomchoice()
print(random_choice)

fruits.remove(fruits.find(random_choice))
print(fruits.concat(" "))

local last_fruit = fruits.pop()
print(last_fruit)
print(fruits.peek())

print(fruits.concat(" "))

fruits.push(last_fruit)
print(fruits.concat(" "))

fruits.foreach(function(key, value)
	print(key, value, #value)
end)

fruits.insert(1, random_choice)
print(fruits.concat(" "))

fruits.sort(function(a, b) return #a < # b end)
print(fruits.concat(" "))

fruits[1] = fruits[1]:upper()
print(fruits.concat(" "))

print(fruits.getn())
print(fruits.maxn())
print(fruits.sizeof())

local size = fruits.sizeof()
fruits[size] = fruits[size]:upper()
print(fruits.concat(" "))

local lower_fruits = fruits.map(function(s) return s:lower() end)
print(lower_fruits.concat(" "))

print("any fruits greater than 16 characters?:", lower_fruits.any(function(s) return #s > 16 end))
print("all fruits less than or equal to 16 characters?:", lower_fruits.all(function(s) return #s <= 16 end))

local filtered = fruits.filter(function(s) return #s <= 5 end)
print(filtered.concat(" "))

local merged = filtered.merge(lower_fruits)
print(merged.concat(" "))

print(merged.keys())
print(merged.map(function(s) return s:lower() end).unique())
print(merged.map(function(s) return s:lower() end).unique().keys())

print("\n\n\n")

local fruits = table.set{"Apple", "Banana", "Cherry", "Date", "Cherry", "Cherry", "Cherry", "Date"}

print(fruits)
print(fruits.concat(" "))

fruits.add("Kiwi")
print(fruits.concat(" "))

fruits.remove("Banana")
print(fruits.concat(" "))

print("has mango?", fruits.has("Mango"))
print("has cherry?", fruits.has("Cherry"))

fruits.foreach(function(s)
	print(s, #s)
end)

for i = 1, 5 do
	print(i, fruits.randomchoice())
end

print("current size", fruits.sizeof())
fruits.add("Mango")
fruits.add("Orange")
print("current size", fruits.sizeof())

fruits.clear()
print(fruits)
