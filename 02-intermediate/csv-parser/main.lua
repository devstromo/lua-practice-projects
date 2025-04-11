-- Used dataset from: https://datahub.io/core/house-prices-us

local function get_script_dir()
    local info = debug.getinfo(1, "S")
    local script_path = info.source:sub(2) -- Remove '@'
    return script_path:match("(.*/)")
        or script_path:match("(.*\\)")     -- For Windows backslashes
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

local skip_header = true
local sums = {}
local counts = {}

for line in file:lines() do
    if skip_header then
        skip_header = false
    else
        local row = parse_csv_line(line)
        for i, value in ipairs(row) do
            value = value:match("^%s*(.-)%s*$")

            if value ~= "null" and value ~= "" then
                local number = tonumber(value)
                if number then
                    sums[i] = (sums[i] or 0) + number
                    counts[i] = (counts[i] or 0) + 1
                else
                    print("Skipped non-numeric:", value)
                end
            else
                print("Skipped null/empty value in column", i)
            end
        end
    end
end

-- Print averages for each column
print("\nAverages per column:")
for i, total in pairs(sums) do
    local avg = total / counts[i]
    print(string.format("Column %d average: %.2f", i, avg))
end


file:close()
