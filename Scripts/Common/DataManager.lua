--[[ DataManager by Apple - Auto saving data ]]--

iclass, imetatable, class_metatable = {}, {}, {}
class_metatable.__index = class_metatable
setmetatable(iclass, imetatable)

function class_metatable:__call(...)
	local object = {}
	object.GetClass = function() return self.__class end
	object.GetClassName = function() return self.__class.__name end
	setmetatable(object, self)
	if object.__init then object:__init(...) end
	return object
end

function imetatable:__call(...)
	local class = {}
	class.__class, class.__index, class.__name = class, class, ({...})[1]
	class.GetClass = function() return self.__class end
	class.GetClassName = function() return self.__class.__name end
	setmetatable(class, class_metatable)

	_G[class.__name] = class
	return class
end

iclass 'DataManager'

local _dataManager = {}
local _dataManagerProxy = {}

function DataManager:__init(filePath)
	assert(type(filePath) == "string", "Error: DataManager(filePath) -> String expected for argument filePath, got "..type(filePath))
	if _dataManager[filePath] then
		self = _dataManager[filePath]
	else
		self.filePath = filePath
		_dataManagerProxy[filePath] = {}
		self:setMT()

		_dataManager[filePath] = self
	end
end

function DataManager:setMT()
	local newMT = {
		__newindex = DataManager_newindex_main,
		__newindex_old = (getmetatable(self) or {}).__newindex,
		__hasNewMT = true,
		__save = function() self:save() end,
		__masterParent = self,
		__index = function(table, key) return getmetatable(table).__index_old[key] or _dataManagerProxy[table.filePath][key] end,
		__index_old = (getmetatable(self) or {}).__index
	}

	for k, v in pairs(getmetatable(self) or {}) do
		if k ~= "__newindex" and k ~= "__index" then
			newMT[k] = v
		end
	end

	setmetatable(self, newMT)
	DataManager_setsubtables(self, nil, nil, self) 
end

function DataManager:save_old()
	local file = io.open(self.filePath, "w")
	file:write("return " .. table.serialize(self))
	file:close()
end

function DataManager:save()
	local file = io.open(self.filePath, "w")
	file:write("return " .. self:serialize())
	file:close()
end

function DataManager:load()
	local file = io.open(self.filePath, "r")
	if file then
		local t = dofile(self.filePath)
		for k, v in pairs(t or {}) do
			self[k] = v
		end
	end
end

function DataManager:getTable(T)
	local LeTable = table.copy(T)
	for k, v in pairs(_dataManagerProxy[T]) do
		if type(v) == "table" and _dataManagerProxy[v] then
			LeTable[k] = self:getTable(v)
		else
			LeTable[k] = v
		end
	end
	return LeTable
end

function DataManager:serialize()
	local LeTable = {}
	for k, v in pairs(_dataManagerProxy[self.filePath]) do
		if type(v) == "table" and _dataManagerProxy[v] then
			LeTable[k] = self:getTable(v)
		else
			LeTable[k] = v
		end
	end
	return table.serialize(LeTable)
end

-- newIndex functions

function DataManager_newindex_main(table, key, value, isChildCall)
	--if not isChildCall then rawset(table, key, value) end
	_dataManagerProxy[table.filePath][key] = value

	if type(value) == "table" then
		if not _dataManagerProxy[value] then
			_dataManagerProxy[value] = {}
		end
		for k, v in pairs(value) do
			value[k] = nil
			_dataManagerProxy[value][k] = v
		end
		if not (getmetatable(value) or {}).__hasNewMT then
			local newMT = {
				__newindex = DataManager_newindex_sub,
				__newindex_old = (getmetatable(value) or {}).__newindex,
				__hasNewMT = true,
				__masterParent = getmetatable(table).__masterParent,
				__index = function(table, key) return _dataManagerProxy[table][key] end
			}

			for k, v in pairs(getmetatable(value) or {}) do
				if k ~= "__newindex" then
					newMT[k] = v
				end
			end

			setmetatable(value, newMT)
		end
	end

	(getmetatable(table).__newindex_old or function() end)()
	
	table:save()
end

function DataManager_newindex_sub(table, key, value, isChildCall)
	--if not isChildCall then rawset(table, key, value) end
	_dataManagerProxy[table][key] = value

	if type(value) == "table" then
		if not _dataManagerProxy[value] then
			_dataManagerProxy[value] = {}
		end
		for k, v in pairs(value) do
			value[k] = nil
			_dataManagerProxy[value][k] = v
		end
		if not (getmetatable(value) or {}).__hasNewMT then
			local newMT = {
				__newindex = DataManager_newindex_sub,
				__newindex_old = (getmetatable(value) or {}).__newindex,
				__hasNewMT = true,
				__masterParent = getmetatable(table).__masterParent,
				__index = function(table, key) return _dataManagerProxy[table][key] end
			}

			for k, v in pairs(getmetatable(value) or {}) do
				if k ~= "__newindex" then
					newMT[k] = v
				end
			end

			setmetatable(value, newMT)
		end
	end
	
	local tableMT = getmetatable(table) or {}

	getmetatable(table).__masterParent:save()
	
	if tableMT.__newindex_old then
		tableMT.__newindex_old(table, key, value)
	end
end

function DataManager_setsubtables(table, parent, key, masterParent)
	if type(table) == "table" then
		for k, v in pairs(table) do
			DataManager_setsubtables(v, table, k, masterParent)
		end

		if not (getmetatable(table) or {}).__hasNewMT then
			local newMT = {
				__newindex = DataManager_newindex_sub,
				__newindex_old = (getmetatable(table) or {}).__newindex,
				__hasNewMT = true,
				__masterParent = masterParent,
			}

			for k, v in pairs(getmetatable(table) or {}) do
				if k ~= "__newindex" then
					newMT[k] = v
				end
			end
			setmetatable(table, newMT)
		end
	end
end