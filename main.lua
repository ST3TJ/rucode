--#region: _G
_DEBUG = true
_OUTPUT = true
_LOAD = false
--#endregion
--#region: Импорт
---Функция для импорта локальных библиотек
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

-- Импорт библиотек
utils = import("utils.lua")
--#endregion
--#region: Чтение файла и синтаксис
-- Открываем файл с кодом
local main = io.open("main.rus", "r")
assert(main, "error: 0x1")

-- Читаем его
local code = main:read("a")

-- Синтаксис языка
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
--#endregion
--#region: Интерпретатор
-- Разбиваем на отдельные слова чтобы после сверять с синтаксисом и делать замены
local result = ""
for word in code:gmatch("[^%s]+") do
    if keywords[word] then
        result = result .. keywords[word] .. " "
    else
        result = result .. word .. " "
    end
end

-- Ищем переменные в коде
local variables = {}

-- TODO Хеш переменных для замены в ошибках
local hash = {}

-- Поиск паттерна
for variable in result:gmatch('(%S+)%s*=%s*%d+') do
    table.insert(variables, variable)
end

-- Создание английского имени и его замена
for i, variable in ipairs(variables) do
    local englishName = 'slot' .. i
    result = result:gsub(variable .. '%s*=', englishName .. ' =')
end
--#endregion
--#region: Вывод и загрузка
-- Вывод итогового кода
if _OUTPUT then
    print(result)
end

-- Создаем функцию с кодом и сразу вызываем ее
if _LOAD then
    load(result)()
end
io.close(main)
--#endregion