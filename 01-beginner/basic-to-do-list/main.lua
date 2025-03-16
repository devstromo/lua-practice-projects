local function get_sequence_number()
    local file = io.open("sequence.txt", "r")
    if file then
        local number = file:read("*n") -- Read a number
        file:close()
        return number or 1
    else
        return 1
    end
end

local function update_sequence_number(new_number)
    local file = io.open("sequence.txt", "w")
    if file then
        file:write(new_number .. "\n")
        file:close()
    else
        print("Error: Could not open sequence.txt for writing")
    end
end

local function add_task()
    local sequence = get_sequence_number()
    io.write("Enter your task: ")
    local task = io.read()
    local file = io.open("tasks.txt", "a")
    if file then
        file:write(sequence .. ". " .. task .. "\n")
        file:close()
        print("Task added successfully: [" .. sequence .. "] " .. task)
        update_sequence_number(sequence + 1)
    else
        print("Error: Could not open tasks.txt for writing")
    end
end

local input = [[
Welcome back to the basic to-do list, what would you like to do?
1. Add a new task
2. List my tasks
3. Exit
]]
io.write(input)

local option = io.read("*number")
io.read() -- Consume newline

if option == 1 then
    add_task()
elseif option == 2 then
    local file = io.open("tasks.txt", "r")
    if file then
        local tasks = file:read("*a")
        file:close()
        print("Your tasks are:")
        print(tasks)
    else
        print("No tasks found")
    end
elseif option == 3 then
    print("Goodbye!")
    os.exit(0)
else
    print("Invalid option")
end