local sequential = io.open("sequence.txt", "r")
if sequential == nil then
    local file = io.open("sequence.txt", "a")
    if file ~= nil then
        file:write(1)
        file:close()
    end
end
local input = [[
Welcome back to the basic to do list, what would you like to do?
]] .. "\n\n1. Add a new task \n"
    .. "2. List my tasks\n"
io.write(input)

local option = io.read("*number")
io.read() -- This consumes the leftover newline
if option == 1 then
    io.write("Enter your task: ")
    local task = io.read()
    io.write("You entered: " .. task .. "\n")
    local file = io.open("tasks.txt", "a")
    if file ~= nil then
        file:write(task .. "\n")
        file:close()
    end
    print("Task added successfully")
elseif option == 2 then
    local file = io.open("tasks.txt", "r")
    if file == nil then
        print("No tasks found")
        return
    end
    local tasks = file:read("*a")
    file:close()
    print("Your tasks are:")
    print(tasks)
else
    print("Invalid option")
end