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

local function get_keys(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end

local map = {
    -- Documents
    ["txt"]  = "Documents",
    ["doc"]  = "Documents",
    ["pdf"]  = "Documents",
    ["xlsx"] = "Documents",

    -- Music
    ["mp3"]  = "Music",
    ["flac"] = "Music",
    ["wav"]  = "Music",
    ["ogg"]  = "Music",
    ["m4a"]  = "Music",
    ["wma"]  = "Music",
    ["aac"]  = "Music",

    -- Video
    ["mp4"]    = "Video",
    ["avi"]    = "Video",
    ["mkv"]    = "Video",
    ["mov"]    = "Video",
    ["wmv"]    = "Video",
    ["webm"]   = "Video",
    ["3gp"]    = "Video",
    ["mpeg"]   = "Video",
    ["mpg"]    = "Video",
    ["m4v"]    = "Video",
    ["m2ts"]   = "Video",
    ["ts"]     = "Video",
    ["vob"]    = "Video",
    ["divx"]   = "Video",
    ["xvid"]   = "Video",
    ["rm"]     = "Video",
    ["rmvb"]   = "Video",
    ["asf"]    = "Video",
    ["ogv"]    = "Video",
    ["3g2"]    = "Video",
    ["f4v"]    = "Video",
    ["h264"]   = "Video",
    ["h265"]   = "Video",
    ["hevc"]   = "Video",
    ["flv"]    = "Video",
    ["swf"]    = "Video",

    -- Image
    ["png"] = "Image",
    ["jpg"] = "Image",
    ["jpeg"] = "Image",
    ["gif"] = "Image",
    ["bmp"] = "Image",
    ["svg"] = "Image",
}

local keys = get_keys(map)
print("Map keys:")

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
        local max_depth = 2

        for _, file_type in ipairs(keys) do
            local destination_folder = map[file_type]
            if destination_folder then
                local destination_path = destinationPath .. "/" .. destination_folder
                local files = scan_folder(sourcePath, file_type, max_depth)

                if #files > 0 then
                    print(string.format("Found %d .%s file(s):", #files, file_type))
                    for _, file in ipairs(files) do
                        print("  → " .. file)
                    end
                    move_files(files, destination_path)
                else
                    print("No ." .. file_type .. " files found.")
                end
            else
                print("Warning: No destination folder mapped for file type: " .. file_type)
            end
        end
    elseif option == 2 then
        print("Help\n")
    elseif option == 3 then
        print("Exit\n")
    else
        print("Invalid option\n")
    end
until option == 3
