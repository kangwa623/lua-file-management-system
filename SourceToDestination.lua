--this lua script takes in two arguments the first one is the  source folder which is being organised
-- and the second one is the destination file where the organised subdirectories are to made


local lfs = require("lfs")
local os = require("os")

local sourceFolder = arg[1]  -- Get source directory path passed as first argument
local destinationFolder = arg[2]  -- Get destination directory path passed as second argument

if sourceFolder and destinationFolder then
    -- Target folders relative to the destination folder
    local targetFolders = {
        [".pdf"] = destinationFolder .. "\\Documents\\PDFs",
        [".txt"] = destinationFolder .. "\\Documents\\TextDoc",
        [".jpg"] = destinationFolder .. "\\Pictures",
        [".docx"] = destinationFolder .. "\\Documents\\WordDocs",
        [".png"] = destinationFolder .. "\\Pictures",
        [".gif"] = destinationFolder .. "\\Pictures",
        [".mp3"] = destinationFolder .. "\\Music",
        [".mp4"] = destinationFolder .. "\\Videos",
        [".pptx"] = destinationFolder .. "\\Documents\\Powerpoint",
        [".xls"] = destinationFolder .. "\\Documents\\ExcelDocs",
        [".xlsx"] = destinationFolder .. "\\Documents\\ExcelDocs",
        [".zip"] = destinationFolder .. "\\Archives",
        [".rar"] = destinationFolder .. "\\Archives",
        [".7z"] = destinationFolder .. "\\Archives",
        [".html"] = destinationFolder .. "\\Documents\\HTML",
        [".css"] = destinationFolder .. "\\Documents\\CSS",
        [".js"] = destinationFolder .. "\\Documents\\JavaScript",
        [".exe"] = destinationFolder .. "\\Executables",
        [".dll"] = destinationFolder .. "\\Executables"
        
    }
    
    -- Rest of your script remains the same...


    -- Function for checking extension and moving files
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

    -- Loop for going through the source folder
    local files = io.popen('dir "'..sourceFolder..'" /b'):lines()
    for fileName in files do
        if not fileName:match("^%.") then -- Ignore hidden files starting with "."
            local filePath = sourceFolder .. "\\" .. fileName
            moveFile(filePath)
        end
    end

    print("Files organization completed!")
else
    print("Source or destination directory not specified")
end
