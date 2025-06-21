-- responses.lua
return {
    greetings = {
        replies = {"Hi there!", "Hello!", "Hey! How can I help?"},
        keywords = {"hello", "hi", "hey"}
    },
    help = {
        replies = {"You can ask me anything!", "Try saying 'hello' or 'thanks'."},
        keywords = {"help", "what can you do", "how to use"}
    },
    gratitude = {
        replies = {"You're welcome!", "No problem!", "Anytime!"},
        keywords = {"thanks", "thank you"}
    },
    identity = {
        replies = {"I'm LuaBot!", "They call me LuaBot.", "LuaBot at your service!"},
        keywords = {"your name", "who are you", "whats your name"}
    },
    fallback = {
        replies = {"Sorry, I don't understand.", "Can you rephrase that?", "Hmm, I didn't catch that."}
    },
    slash_commands = {
        ["/help"] = [[
Available commands:
/help – Show this help message
Type any greeting like "hello" or "hi"
Say "thanks" to see a gratitude reply
Ask "what's your name" or similar
Type 'exit' or 'bye' to quit the bot
]]
    }
}

