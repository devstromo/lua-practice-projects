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

local function update_task(task_number, new_description)
    local file = io.open("tasks.txt", "r")
    if not file then
        print("Error: tasks.txt not found.")
        return
    end

    local tasks = {}
    local task_found = false

    for line in file:lines() do
        local num, task = line:match("(%d+)%.%s(.+)")
        if tonumber(num) == task_number then
            table.insert(tasks, num .. ". " .. new_description)
            task_found = true
        else
            table.insert(tasks, line)
        end
    end

    file:close()

    if not task_found then
        print("Task number " .. task_number .. " not found.")
        return
    end

    file = io.open("tasks.txt", "w")
    if file == nil then
        return
    end
    for _, task in ipairs(tasks) do
        file:write(task .. "\n")
    end
    file:close()

    print("Task " .. task_number .. " updated successfully!")
end

local function delete_task(task_number)
    local file = io.open("tasks.txt", "r")
    if not file then
        print("Error: tasks.txt not found.")
        return
    end

    local tasks = {}
    local task_found = false

    for line in file:lines() do
        local num, task = line:match("(%d+)%.%s(.+)")
        if tonumber(num) == task_number then
            task_found = true
        else
            table.insert(tasks, task)
        end
    end

    file:close()

    if not task_found then
        print("Task number " .. task_number .. " not found.")
        return
    end

    file = io.open("tasks.txt", "w")
    if not file then
        print("Error: Could not open tasks.txt for writing.")
        return
    end

    for i, task in ipairs(tasks) do
        file:write(i .. ". " .. task .. "\n") -- Reassign numbers sequentially
    end

    file:close()

    local new_sequence = #tasks + 1
    update_sequence_number(new_sequence)

    print("Task " .. task_number .. " deleted and numbers updated successfully!")
end

-- MAIN
local input = [[
Welcome back to the basic to-do list, what would you like to do?
1. Add a new task
2. List my tasks
3. Get task by number
4. Update task
5. Delete task
6. Exit
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
    print("Update task")
    local task_number = io.read("*number")
    local task = get_task_by_number(task_number)
    if task == nil then
        print("Task not found")
        return
    end
    io.write("Enter your task: ")
    io.read()
    local description = io.read()
    update_task(task_number, description)
elseif option == 5 then
    io.write("Enter the task number: ")
    local task_number = io.read("*number")
    delete_task(task_number)
elseif option == 6 then
    print("Goodbye!")
    os.exit(0)
else
    print("Invalid option")
end
