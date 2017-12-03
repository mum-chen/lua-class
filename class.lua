local DEBUG_MODE = false

local META_CLASS = "CLASS"
local CLASS = "class"
local INSTANCE = "instance"

local Class = {__type__ = META_CLASS}

local function instance_init(cls, ...)
	local instance = {
		__class__ = cls,
		__type__ = "instance",
	}
	setmetatable(instance, { __index = cls })
	if cls.__init__ then cls.__init__(instance, ...) end
	return instance
end

local function class_init(metaclass, cls)
	local cls = cls or metaclass
	local _ = DEBUG_MODE and assert(Class.isclass(cls))
	local kls = {
		__parent__ = cls,
		__type__ = CLASS
	}
	setmetatable(kls, {
		__index = cls,
		__call = instance_init
	})
	return kls
end

setmetatable(Class, {__call = class_init})

function Class.parent(cls)
	return cls.__parent__
end

function Class.super(cls, self, ...)
	local parent = Class.parent(cls)
	if not parent then
		local _ = DEBUG_MODE and "Don't have parent"
		return
	end
	parent.__init__(self, ...)
end

function Class.type(obj)
	local t = type(obj)
	if t ~= "table" then return t end
	return obj.__type__ or "table"
end

function Class.isclass(cls)
	local t = Class.type(cls)
	return (t == META_CLASS or t == CLASS)
end

function Class.isinstance(instance)
	return Class.type(instance) == INSTANCE
end

function Class.class(obj)
	if Class.isinstance(obj) then
		return obj.__class__
	elseif Class.isclass(obj) then
		return obj
	else
		local _ = DEBUG_MODE and error("error value in class")
		return nil
	end
end

local function ischild(child, father)
	local parent = Class.class(child)
	while parent do
		if parent == father then return true end
		parent = Class.parent(parent)
	end
	return false
end

function Class.childof(child, father)
	if not (Class.isclass(child) or Class.isclass(father)) then
		local _ = DEBUG_MODE and error("error value in ischild")
		return false
	end
	return ischild(child, father)
end

function Class.instanceof(instance, cls)
	if not (Class.isclass(cls) or Class.isinstance(instance)) then
		local _ = DEBUG_MODE and error("error value in isinstance")
		return false
	end
	return ischild(instance, cls)
end

return Class
