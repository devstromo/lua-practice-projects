local lfs = require("lfs")

local function isValidPath(path)
    local attr = lfs.attributes(path)
    return attr ~= nil
end


local function scan_folder(path, extension, max_depth, current_depth)
    current_depth = current_depth or 0
    if current_depth > max_depth then return {} end

    local results = {}

    for item in lfs.dir(path) do
        if item ~= "." and item ~= ".." then
            local full_path = path .. "/" .. item
            local attr = lfs.attributes(full_path)

            if attr.mode == "file" and full_path:match("%." .. extension .. "$") then
                table.insert(results, full_path)
            elseif attr.mode == "directory" then
                local sub_results = scan_folder(full_path, extension, max_depth, current_depth + 1)
                for _, v in ipairs(sub_results) do
                    table.insert(results, v)
                end
            end
        end
    end

    return results
end

local function move_files(files, output_folder)
    local attr = lfs.attributes(output_folder)
    if not attr then
        lfs.mkdir(output_folder)
    end

    for _, file in ipairs(files) do
        local filename = file:match("([^/\\]+)$")
        local destination = output_folder .. "/" .. filename

        local success, err = os.rename(file, destination)
        if success then
            print("Moved:", file, "→", destination)
        else
            print("Failed to move:", file, "Error:", err)
        end
    end
end

local map = {
    ["txt"] = "Documents",
    ["doc"] = "Documents",
    ["mp4"] = "Media"
}

-- MAIN
local input = [[
Welcome to the basic file organizer, what would you like to do?
1. Organize files
2. Help
3. Exit
]]
repeat
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
        if isValidPath(sourcePath) then
            print("Source path is valid.")
        else
            print("Source path is invalid.")
            return
        end
        print("Destination path: " .. destinationPath)
        if isValidPath(destinationPath) then
            print("Destination path is valid.")
        else
            print("Destination path is invalid.")
            return
        end
        local folder_path = "."
        local file_type = "txt"
        local max_depth = 2

        local files = scan_folder(sourcePath, file_type, max_depth)

        print("Found " .. #files .. " ." .. file_type .. " files:")
        for _, file in ipairs(files) do
            print(file)
        end
        move_files(files, destinationPath)
    elseif option == 2 then
        print("Help\n")
    elseif option == 3 then
        print("Exit\n")
    else
        print("Invalid option\n")
    end
until option == 3
