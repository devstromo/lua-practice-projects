-- A simple chatbot that responds to user input with predefined answers.
local function normalize(text)
    return text:lower():gsub("%p", ""):gsub("^%s*(.-)%s*$", "%1")
end

-- Bot logic
local responses = {
    hello = "Hi there!",
    hi = "Hello!",
    how = "I'm just a bot, but I'm doing fine!",
    thanks = "You're welcome!",
    ["whats your name"] = "I'm LuaBot!"
}

local function bot(input)
    local msg = normalize(input)
    for keyword, reply in pairs(responses) do
        if msg:find(keyword) then
            return reply
        end
    end
    return "Sorry, I don't understand."
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
end
