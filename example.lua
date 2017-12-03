local Class = require("class")
local type = Class.type

local Grandfather = Class()
function Grandfather:__init__(attr_a)
	self.attr_a = attr_a
end

local Father = Class(Grandfather)
function Father:__init__(attr_b)
	Father:super(self, "grandpa")
	self.attr_b = attr_b
end

local Child = Class(Father)
function Child:__init__(attr_c)
	Child:super(self, "father")
	self.attr_c = attr_c
end

local grandfather = Grandfather("grandpa")
local father = Father("father")
local child = Child("child")
print("Success: init Class & Instance")

assert(grandfather.attr_a == "grandpa")
assert(father.attr_a == "grandpa")
assert(child.attr_a == "grandpa")
assert(father.attr_b == "father")
assert(child.attr_b == "father")
assert(child.attr_c == "child")
print("Success: Class:supper")

local Child2 = Class(Father)
local child2 = Child2("father2")
assert(child2.attr_a == "grandpa")
assert(child2.attr_b == "father2")
print("Success: Class extend __init__")

local child_list = {
	{
		class = Grandfather,
		instance = grandfather,
		parent = {Class, Grandfather},
	}, {
		class = Father,
		instance = father,
		parent = {Class, Grandfather, Father},
	}, {
		class = Child,
		instance = child,
		parent = {Class, Grandfather, Father, Child}
	}
}

assert(type(Class) == "CLASS")
print("Success: META CLASS")

for _, v in ipairs(child_list) do
	assert(type(v.class) == "class")
end
print("Success: class type")

for _, v in ipairs(child_list) do
	assert(type(v.instance) == "instance")
end
print("Success: instance type")

for _, v in ipairs(child_list) do
	local cls = v.class
	for _, p in ipairs(v.parent) do
		assert(cls:childof(p))
	end
end
print("Success: child of")

for _, v in ipairs(child_list) do
	local inst = v.instance
	for _, p in ipairs(v.parent) do
		assert(inst:instanceof(p))
	end
end
print("Success: instance of")
