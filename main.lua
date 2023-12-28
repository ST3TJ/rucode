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
init = import("init.lua")
--#endregion
--#region: Interpreter table
local Interpreter = {
    memory = {
        vars = {},
        consts = {}
    },
    rawTokens = {
        list = {},
    },
    keywords = {
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
    },
    patternList = {
        equation = "%s*([%a_][%w_]*)%s*=%s*([^;]+)"
    },
    code = "",
}
--#endregion
--#region: Interpreter functions
Interpreter.replacement = function()
    for word in _CODE:gmatch("[^%s]+") do
        if Interpreter.keywords[word] then
            Interpreter.code = Interpreter.code .. Interpreter.keywords[word] .. " "
        else
            Interpreter.code = Interpreter.code .. word .. " "
        end
    end
end

Interpreter.memory.handler = function()
    for k, v in Interpreter.code:gmatch(Interpreter.patternList.equation) do
        print(k .. " = " .. v) -- TODO
    end
end

Interpreter.rawTokens.handler = function()
    for token in Interpreter.code:gmatch("[А-Яа-яЁё]+") do
        table.insert(Interpreter.rawTokens.list, token)
    end
    
    for i, token in ipairs(Interpreter.rawTokens.list) do
        local englishName = 'slot' .. i
        Interpreter.code = Interpreter.code:gsub(token, englishName)
    end
end

Interpreter.replacement()
Interpreter.memory.handler()
Interpreter.rawTokens.handler()
--#endregion
--#region: Loading code
if _OUTPUT then
    print(Interpreter.code)
end
if _LOAD then
    load(Interpreter.code)()
end
io.close(_FILE)
--#endregion