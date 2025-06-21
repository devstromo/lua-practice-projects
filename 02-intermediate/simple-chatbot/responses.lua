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
    }
}

