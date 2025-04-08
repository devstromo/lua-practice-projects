local function get_script_dir()
    local info = debug.getinfo(1, "S")
    local script_path = info.source:sub(2)  -- Remove '@'
    return script_path:match("(.*/)")
        or script_path:match("(.*\\)")      -- For Windows backslashes
end

-- MAIN
local function parse_csv_line(line)
    local fields = {}
    local field = ""
    local inside_quotes = false

    for i = 1, #line do
        local c = line:sub(i, i)
        if c == '"' then
            inside_quotes = not inside_quotes
        elseif c == ',' and not inside_quotes then
            table.insert(fields, field)
            field = ""
        else
            field = field .. c
        end
    end

    table.insert(fields, field) -- last field
    return fields
end

local script_dir = get_script_dir()
local filename = script_dir .. "flat-ui__data-us.csv"
local file = io.open(filename, "r")

if not file then
    print("File not found!")
    os.exit(1)
end

for line in file:lines() do
    local row = parse_csv_line(line)
    for i, value in ipairs(row) do
        print(string.format("Column %d: %s", i, value))
    end
    print("------")
end

file:close()

