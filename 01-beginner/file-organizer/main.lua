-- MAIN
local input = [[
Welcome to the basic file organizer, what would you like to do?
1. Organize files
2. Help
3. Exit
]]
io.write(input)

local option = io.read("*number")
local _ = io.read() -- Consume newline
if option == 1 then
    print("Organize files")
    io.write("Enter the source path: ")
    local sourcePath = io.input():read()
    io.write("Enter the destination path: ")
    local destinationPath = io.input():read()
    print("Source path: " .. sourcePath)
    print("Destination path: " .. destinationPath)
elseif option == 2 then
    print("Help")
elseif option == 3 then
    print("Exit")
else
    print("Invalid option")
end