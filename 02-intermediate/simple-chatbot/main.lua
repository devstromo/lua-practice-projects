-- A simple chatbot that responds to user input with predefined answers.
local cli_args = {}
for _, arg_str in ipairs(arg or {}) do
    local key, val = arg_str:match("^%-%-(.-)=(.+)$")
    if key and val then
        cli_args[key] = val
    else
        key = arg_str:match("^%-%-(.+)$")
        if key then
            cli_args[key] = true
        end
    end
end

local function normalize(text)
    return text:lower():gsub("%p", ""):gsub("^%s*(.-)%s*$", "%1")
end

local function get_formatted_timestamp()
    local now = os.time()
    local formatted = os.date("[%Y/%m/%d %H:%M:%S", now)

    local millis = math.floor((os.clock() % 1) * 10000) -- 4 digits for .ssss

    return string.format("%s.%04d]", formatted, millis)
end

local ok, responses = pcall(require, "responses")
if not ok then
    print("Error loading responses:", responses)
    return
end

local function bot(input)
    local msg = normalize(input)

    for reply, keywords in pairs(responses) do
        for _, keyword in ipairs(keywords) do
            if msg:find(keyword) then
                return reply
            end
        end
    end

    return "Sorry, I don't understand."
end

local function load_log_file()
    local date_str = os.date("%Y_%m_%d")
    local default_filename = date_str .. "_chat_log.txt"

    local log_file_path = cli_args.log_file or default_filename

    local file, err = io.open(log_file_path, "a+")
    if not file then
        print("Error opening log file:", err)
        return nil
    end

    print("Logging to:", log_file_path)
    return file
end

local log_file = load_log_file()
if not log_file then
    print("Exiting due to log file error.")
    return
end

-- Chat loop
print("ChatBot is running. Type 'exit' or 'bye' to quit.")
while true do
    io.write("You: ")
    local user_input = io.read()
    if not user_input then
        break
    end -- handle Ctrl+D or EOF

    local msg = normalize(user_input)
    if msg == "exit" or msg == "bye" then
        print("Bot: Goodbye!")
        break
    end

    local reply = bot(user_input)
    print("Bot:", reply)
    if cli_args["save-chat"] then
        local formatted_time = get_formatted_timestamp()
        log_file:write(string.format("%s User: %s\n%s Bot: %s\n", formatted_time, user_input, formatted_time, reply))
        log_file:flush()
    end
end
log_file:close()
