-- This lua script takes in the path to a directory that is to be organised.
-- the files in the directory are sorted according to file extensions and are moved 
--into appropriate subdirectories within the specified directories representing their 
-- file type in trying to achieve organisation



local lfs = require("lfs")
local os = require("os")

local sourceDirectory = arg[1]  -- Get directory path passed as argument

if sourceDirectory then
    -- Target folders- subdirectories whre files will be moved to
    local targetFolders = {
        [".pdf"] = sourceDirectory .. "\\Documents\\PDFs",
        [".txt"] = sourceDirectory .. "\\Documents\\TextDoc",
        [".jpg"] = sourceDirectory .. "\\Pictures",
        [".docx"] = sourceDirectory .. "\\Documents\\WordDocs",
        [".xlsx"] = sourceDirectory .. "\\Documents\\ExcelDocs",
        [".zip"] = sourceDirectory .. "\\Archives",
        [".png"] = sourceDirectory .. "\\Pictures",
        [".gif"] = sourceDirectory .. "\\Pictures",
        [".mp3"] = sourceDirectory .. "\\Music",
        [".mp4"] = sourceDirectory .. "\\Videos",
        [".pptx"] = sourceDirectory .. "\\Documents\\Powerpoint",
        [".html"] = sourceDirectory .. "\\Documents\\HTML",
        [".css"] = sourceDirectory .. "\\Documents\\CSS",
        [".js"] = sourceDirectory .. "\\Documents\\JavaScript",
        [".exe"] = sourceDirectory .. "\\Executables",
        [".dll"] = sourceDirectory .. "\\Executables",
        [".bat"] = sourceDirectory .. "\\Scripts",
        [".sh"] = sourceDirectory .. "\\Scripts",
        [".tar"] = sourceDirectory .. "\\Archives",
        [".gz"] = sourceDirectory .. "\\Archives"
    }
    

    -- Function for checking extension
    local function moveFile(filePath)
        local fileName = string.match(filePath, "[^\\]+$")
        local fileExt = string.match(fileName, "%..+$")
        local targetFolder = targetFolders[fileExt]
        if targetFolder then
            -- Check if target folder exists, create it if not
            if not os.execute('if not exist "'..targetFolder..'" mkdir "'..targetFolder..'"') then
                print("Error creating directory: " .. targetFolder)
                return
            end
            -- Attempt to move the file
            local success, err = os.rename(filePath, targetFolder .. "\\" .. fileName)
            if success then
                print("Moved " .. fileName .. " to " .. targetFolder)
            else
                -- Handle error if move fails (e.g., permission issue)
                print("Error moving " .. fileName .. ": " .. err)
            end
        end
    end

    -- Function to move a specified file to a specific folder
    local function moveToSpecificFolder(filePath)
        local fileName = string.match(filePath, "[^\\]+$")
        local destinationPath = moveFolder .. "\\" .. fileName
        -- Check if move folder exists, create it if not
        if not os.execute('if not exist "'..moveFolder..'" mkdir "'..moveFolder..'"') then
            print("Error creating directory: " .. moveFolder)
            return
        end
        -- Attempt to move the file
        local success, err = os.rename(filePath, destinationPath)
        if success then
            print("Moved " .. fileName .. " to " .. moveFolder)
        else
            -- Handle error if move fails (e.g., permission issue)
            print("Error moving " .. fileName .. ": " .. err)
        end
    end

    -- Loop for going through the download folder
    local files = io.popen('dir "'..sourceDirectory..'" /b'):lines()
    for fileName in files do
        if not fileName:match("^%.") then -- Ignore hidden files starting with "."
            local filePath = sourceDirectory .. "\\" .. fileName
            moveFile(filePath)
        end
    end

    -- Example usage of moveToSpecificFolder
    --local specificFile = sourceDirectory .. "\\example.txt"
    --moveToSpecificFolder(specificFile)

    print("Download folder organization completed!")
else
    print("No directory specified")
end
