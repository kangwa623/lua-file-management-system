--this lua script takes in three argument, the first one being the source directory
-- the second argument being the destination directory, where the files are moved to 
-- the third one is a list of specified file extensions for files to be moved.
 
local os = require("os")

local sourceDirectory = arg[1]  -- Source directory path passed as argument
local destinationDirectory = arg[2]  -- Destination directory path passed as argument
local extensions = {}
local numOfFilesMoved = 0            -- for keeping track of the number of files moved
-- Populate the extensions table with the extensions passed as arguments
for i = 3, #arg do
    extensions[arg[i]] = true
end

if sourceDirectory and destinationDirectory then
    -- Ensure the destination directory exists
    if not os.execute('if not exist "' .. destinationDirectory .. '" mkdir "' .. destinationDirectory .. '"') then
        print("Error creating directory: " .. destinationDirectory)
        return
    end

    -- Function for moving files based on extension
    local function moveFile(filePath)
        local fileName = string.match(filePath, "[^\\]+$")
        local fileExt = string.match(fileName, "%..+$")
        if fileExt and extensions[fileExt] then
            local targetFolder = destinationDirectory
            -- Ensure the target folder exists
            if not os.execute('if not exist "' .. targetFolder .. '" mkdir "' .. targetFolder .. '"') then
                print("Error creating directory: " .. targetFolder)
                return
            end
            -- Attempt to move the file
            local success, err = os.rename(filePath, targetFolder .. "\\" .. fileName)
            if success then
                numOfFilesMoved = numOfFilesMoved + 1
                print()
            else
                -- Handle error if move fails (e.g., permission issue)
                print("Error moving " .. fileName .. ": " .. err)
            end
        end
    end

    -- Loop through the source directory and move files based on extension
    local files = io.popen('dir "' .. sourceDirectory .. '" /b'):lines()
    for fileName in files do
        if not fileName:match("^%.") then -- Ignore hidden files starting with "."
            local filePath = sourceDirectory .. "\\" .. fileName
            moveFile(filePath)
        end
    end

    print(numOfFilesMoved)
else
    print("Source or destination directory not specified")
end
