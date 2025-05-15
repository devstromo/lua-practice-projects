local input = [[
Welcome to the log analyzer!
This is a simple log analyzer that will help you analyze your logs.
Please enter the path to the log file you want to analyze:
]]

-- Function to print the welcome message
local function print_welcome_message()
    print(input)
end
-- Function to read the log file path from the user
local function read_log_file_path()
    print("Please enter the path to the log file you want to analyze:")
    local log_file_path = io.read()
    return log_file_path
end
-- Function to read the log file
local function read_log_file(log_file_path)
    local file = io.open(log_file_path, "r")
    if not file then
        print("Error: Could not open log file at " .. log_file_path)
        return nil
    end
    local log_data = file:read("*a")
    file:close()
    return log_data
end

local function analyze_log_data(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Error: Cannot open file " .. filename)
        return
    end

    local line_count = 0

    for line in file:lines() do
        line_count = line_count + 1
        -- You can analyze each line here (count status codes, IPs, etc.)
    end

    file:close()
    print("Total lines processed: " .. line_count)
end

print_welcome_message()
local log_file_path = read_log_file_path()
local log_data = read_log_file(log_file_path)
if not log_data then
    print("Error: Could not read log file.")
    return
end

analyze_log_data(log_file_path)
