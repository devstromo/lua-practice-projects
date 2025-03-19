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

local function get_task_by_number(task_number)
    local file = io.open("tasks.txt", "r")
    if not file then
        print("Error: tasks.txt not found.")
        return
    end

    for line in file:lines() do
        local num, task = line:match("(%d+)%.%s(.+)")
        if tonumber(num) == task_number then
            file:close()
            return task
        end
    end

    file:close()
    return nil
end

-- MAIN
local input = [[
Welcome back to the basic to-do list, what would you like to do?
1. Add a new task
2. List my tasks
3. Get task by number
4. Exit
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
    io.write("Enter the task number: ")
    local task_number = io.read("*number")
    local task = get_task_by_number(task_number)
    if task then
        print("Task [" .. task_number .. "]: " .. task)
    else
        print("Task not found")
    end
elseif option == 4 then
    print("Goodbye!")
    os.exit(0)
else
    print("Invalid option")
end
