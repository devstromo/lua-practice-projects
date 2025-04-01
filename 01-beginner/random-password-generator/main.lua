-- MAIN
local input = [[
Welcome to the random password generator, what would you like to do?
1. Generate password
2. Help
3. Exit
]]
local password_length = 12
local password_characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+[]{}|;:,.<>?"
local password = ""

repeat
    local option = io.read("*number")
    local _ = io.read()
    if option == 1 then
        print("Generating password...")
    elseif option == 2 then
        print("\n=== Help ===")
        print("1. Generate Password:")
        print("   - Choose option 1 to generate a random password.")
        print("   - The password will be " .. password_length .. " characters long.")
        print("   - It will include letters, numbers, and special characters.\n")

        print("2. Help:")
        print("   - Displays this message to explain how the generator works.\n")

        print("3. Exit:")
        print("   - Choose option 3 to exit the application.\n")
    elseif option == 3 then
        print("Exit\n")
    else
        print("Invalid option. Please try again.")
    end
until option == 3 or option == nil
