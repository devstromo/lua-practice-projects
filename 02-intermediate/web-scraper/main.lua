local https = require("ssl.https")
local http = require("socket.http")
local ltn12 = require("ltn12")
local htmlparser = require("htmlparser")
-- MAIN

local input = [[
Welcome to the web scraper, what would you like to do?
1. Scrape a webpage
2. Extract links
3. Extract images
4. Extract text
5. Extract tables
6. Extract all
7. Help
8. Exit
]]

repeat
    io.write(input)
    io.write("Enter your option: ")
    local option = io.read("*number")
    local _ = io.read()
    if option == 1 then
        print("Scraping a webpage")
        io.write("Enter URL: ")
        local url = io.read()
        print("Scraping " .. url .. "...")
        local response = http.request(url)
        print(response)
    elseif option == 2 then
        print("Extracting links")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting links from " .. url .. "...")
        local response = http.request(url)
        local links = {}
        for link in response:gmatch("<a href=[\"'](.-)[\"]") do
            table.insert(links, link)
        end
        for i, link in ipairs(links) do
            print(i .. ": " .. link)
        end
        print("Total links found: " .. #links)
        local file = io.open("links.txt", "w")
        for i, link in ipairs(links) do
            file:write(i .. ": " .. link .. "\n")
        end
        file:close()
        print("Links saved to links.txt")

    elseif option == 3 then
        print("Extracting images")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting images from " .. url .. "...")
        -- Here you would implement the logic to extract images from the webpage
        local response = http.request(url)
        local images = {}
        local root = htmlparser.parse(response)
        for _, img in ipairs(root:select("img")) do
            table.insert(images, img.attributes.src)
        end
        for i, img in ipairs(images) do
            print(i .. ": " .. img)
        end
        print("Total images found: " .. #images)
        local file = io.open("images.txt", "w")
        for i, img in ipairs(images) do
            file:write(i .. ": " .. img .. "\n")
        end
        file:close()
        print("Images saved to images.txt")
    elseif option == 4 then
        print("Extracting text")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting text from " .. url .. "...")
        local body = {}
        local res, code = nil, nil
        if url:match("^https://") then
            res, code = https.request {
                url = url,
                sink = ltn12.sink.table(body)
            }
        elseif url:match("^http://") then
            res, code = http.request {
                url = url,
                sink = ltn12.sink.table(body)
            }
        else
            print("Invalid URL. Must start with http:// or https://")
            return
        end

        -- Validate response
        if not res or code ~= 200 then
            print("Failed to fetch page. Status:", code or "unknown")
            return
        end

        -- Join content and parse HTML
        local html = table.concat(body)
        local tree = htmlparser.parse(html)

        -- Collect all visible text nodes
        local extracted_text = {}

        local function collect_text(node)
            for _, child in ipairs(node.nodes) do
                if child._type == "text" then
                    table.insert(extracted_text, child.text)
                else
                    collect_text(child)
                end
            end
        end

        collect_text(tree)

        -- Clean and write to file
        local final_text = table.concat(extracted_text, " ")
        final_text = final_text:gsub("%s+", " ")

        local file = io.open("text.txt", "w")
        file:write(final_text)
        file:close()

        print("Text saved to text.txt")

    elseif option == 5 then
        print("Extracting tables")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting tables from " .. url .. "...")
        -- Here you would implement the logic to extract tables from the webpage
        local response = http.request(url)
        local tables = {}
        local root = htmlparser.parse(response)
        for _, table in ipairs(root:select("table")) do
            local rows = {}
            for _, row in ipairs(table:select("tr")) do
                local cells = {}
                for _, cell in ipairs(row:select("td")) do
                    table.insert(cells, cell:getcontent())
                end
                table.insert(rows, cells)
            end
            table.insert(tables, rows)
        end
        for i, tbl in ipairs(tables) do
            print("Table " .. i .. ":")
            for _, row in ipairs(tbl) do
                print(table.concat(row, "\t"))
            end
        end
        print("Total tables found: " .. #tables)
        local file = io.open("tables.txt", "w")
        for i, tbl in ipairs(tables) do
            file:write("Table " .. i .. ":\n")
            for _, row in ipairs(tbl) do
                file:write(table.concat(row, "\t") .. "\n")
            end
            file:write("\n")
        end
        file:close()
        if #tables ~= 0 then
            print("Tables saved to tables.txt")
        else
            print("No tables found.")
        end
    elseif option == 6 then
        print("Extracting all")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting all from " .. url .. "...")
        local response = http.request(url)
        local all_data = {}
        local root = htmlparser.parse(response)
        -- Extract links
        local links = {}
        for link in response:gmatch("<a href=[\"'](.-)[\"]") do
            table.insert(links, link)
        end
        all_data.links = links
        -- Extract images
        local images = {}
        for _, img in ipairs(root:select("img")) do
            table.insert(images, img.attributes.src)
        end
        all_data.images = images
        -- Extract text
        local text = response:gsub("<[^>]+>", "") -- Remove HTML tags
        text = text:gsub("%s+", " ") -- Remove extra whitespace
        all_data.text = text
        -- Extract tables
        local tables = {}
        for _, table in ipairs(root:select("table")) do
            local rows = {}
            for _, row in ipairs(table:select("tr")) do
                local cells = {}
                for _, cell in ipairs(row:select("td")) do
                    table.insert(cells, cell:getcontent())
                end
                table.insert(rows, cells)
            end
            table.insert(tables, rows)
        end
        all_data.tables = tables
        -- Save all data to a file
        local file = io.open("all_data.txt", "w")
        file:write("Links:\n")
        for i, link in ipairs(all_data.links) do
            file:write(i .. ": " .. link .. "\n")
        end
        file:write("\nImages:\n")
        for i, img in ipairs(all_data.images) do
            file:write(i .. ": " .. img .. "\n")
        end
        file:write("\nText:\n" .. all_data.text .. "\n")
        file:write("\nTables:\n")
        for i, tbl in ipairs(all_data.tables) do
            file:write("Table " .. i .. ":\n")
            for _, row in ipairs(tbl) do
                file:write(table.concat(row, "\t") .. "\n")
            end
            file:write("\n")
        end
        file:close()
        print("All data saved to all_data.txt")
    elseif option == 7 then
        print("Help")
        print("1. Scrape a webpage: Enter a URL to scrape the webpage.")
        print("2. Extract links: Enter a URL to extract all links from the webpage.")
        print("3. Extract images: Enter a URL to extract all images from the webpage.")
        print("4. Extract text: Enter a URL to extract all text from the webpage.")
        print("5. Extract tables: Enter a URL to extract all tables from the webpage.")
        print("6. Extract all: Enter a URL to extract all data from the webpage.")
        print("7. Help: Show this help message ")
        print("8. Exit: Exit the program.")
    elseif option == 8 then
        print("Exiting the program.")
    else
        print("Invalid option, please try again.")
    end
until option == 8 or option == nil
