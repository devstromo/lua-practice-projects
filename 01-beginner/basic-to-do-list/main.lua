local input = [[
Welcome back to the basic to do list, what would you like to do?
]] .. "\n\n1. Add a new task \n"
    .. "2. List my tasks\n"
io.write(input)
local option = io.read("*number")
if option == 1 then
    io.write("Enter your task: ")
    local task = io.read()
    local file = io.open("tasks.txt", "a")
    file:write(task .. "\n")
    file:close()
    print("Task added successfully")
elseif option == 2 then
    local file = io.open("tasks.txt", "r")
    local tasks = file:read("*a")
    file:close()
    print("Your tasks are:")
    print(tasks)
else
    print("Invalid option")
end