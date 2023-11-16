--#region: _G and File
_DEBUG = true
_OUTPUT = false
_LOAD = true
_FILE_NAME = io.read()

if _FILE_NAME == "" then
    _FILE_NAME = "main.rus"
end

_FILE = io.open(_FILE_NAME, "r")
if not _FILE then
    print(("A file named \"%s\" was not found"):format(_FILE_NAME))
    print("Exiting...")
    return
end

local code = _FILE:read("a")
--#endregion
--#region: Import
---Function for local libraries import
---@param name string
---@return any
local function import(name)
    local file = io.open(name, "r")
    assert(file, name .. " library do not exist")

    local lib = load(file:read("a"))
    io.close(file)

    assert(lib, name .. " library load error")

    local s, m = pcall(lib)

    if not s and _DEBUG then
        print(m)
    else
        return lib()
    end
end

utils = import("utils.lua")
--#endregion
--#region: Interpreter
local keywords = {
    ["локально"] = "local",
    ["локальное"] = "local",
    ["локальная"] = "local",
    ["локальный"] = "local",

    ["вывести"] = "print",
    ["вывод"] = "print",
    ["ввести"] = "io.read",
    ["ввод"] = "io.read",

    ["функция"] = "function",
    ["вернуть"] = "return",

    ["если"] = "if",
    ["и"] = "and",
    ["или"] = "or",
    ["тогда"] = "then",
    ["конец"] = "end",
    ["кц"] = "end",
    ["не"] = "not",

    ["правда"] = "true",
    ["правдиво"] = "true",
    ["правду"] = "true",
    ["ложь"] = "false",
    ["неправда"] = "false",
    ["неверно"] = "false",
    ["ничто"] = "nil",

    ["иначе"] = "else",
    ["иначесли"] = "elseif",
    ["пока"] = "while",
    ["для"] = "for",

    ["импорт"] = "require",
    ["импортировать"] = "require",

    ["корень"] = "math.sqrt",
    ["округлить"] = "utils.ceil",
    ["квадрат"] = "math.sqr"
}

local result = ""
for word in code:gmatch("[^%s]+") do
    if keywords[word] then
        result = result .. keywords[word] .. " "
    else
        result = result .. word .. " "
    end
end

-- Finding rawTokens and replacing it
local rawTokens = {}

for token in result:gmatch("[А-Яа-яЁё]+") do
    table.insert(rawTokens, token)
end

for i, token in ipairs(rawTokens) do
    local englishName = 'slot' .. i
    result = result:gsub(token, englishName)
end
--#endregion
--#region: Loading code
if _OUTPUT then
    print(result)
end
if _LOAD then
    load(result)()
end
io.close(_FILE)
--#endregion