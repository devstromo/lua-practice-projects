local https = require("ssl.https")
local http = require("socket.http")
local ltn12 = require("ltn12")

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
        for img in response:gmatch('<img src=[\"'](.-)[\"']') do
            table.insert(images, img)
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
        -- Note: The above regex is a simple example and may not work for all cases.
        -- You may need to use a more robust HTML parser for complex webpages.
        -- For example, you could use the LuaXML or lua-htmlparser libraries for better parsing.
        -- You can also use the lxml library in Python for more complex scraping tasks.
        -- For example, you could use the requests library to fetch the webpage and then use BeautifulSoup to parse it.
    elseif option == 4 then
        print("Extracting text")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting text from " .. url .. "...")
        local response = http.request(url)
        local text = response:gsub("<[^>]+>", "") -- Remove HTML tags
        text = text:gsub("%s+", " ") -- Remove extra whitespace
        print("Extracted text: " .. text)
        local file = io.open("text.txt", "w")
        file:write(text)
        file:close()
        print("Text saved to text.txt")
        -- Note: The above regex is a simple example and may not work for all cases.
        -- You may need to use a more robust HTML parser for complex webpages.
        -- For example, you could use the LuaXML or lua-htmlparser libraries for better parsing.

    elseif option == 5 then
        print("Extracting tables")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting tables from " .. url .. "...")
        -- Here you would implement the logic to extract tables from the webpage
    elseif option == 6 then
        print("Extracting all")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting all from " .. url .. "...")
        -- Here you would implement the logic to extract all data from the webpage
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
