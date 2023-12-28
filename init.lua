_DEBUG = true
_OUTPUT = false
_LOAD = false
_FILE_NAME = "main.rus"
_FILE = io.open(_FILE_NAME, "r")

if not _FILE then
    print(("Init error: A file named \"%s\" was not found"):format(_FILE_NAME))
    print("Exiting...")
    return
end

_CODE = _FILE:read("a")