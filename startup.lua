local versionURL = "https://gaz492.github.io/ccMonitorScreen/version"
local scriptURL = "https://gaz492.github.io/ccMonitorScreen/monitor.lua"

local scriptFileName = "script" --do not add file type

local isFirstRun = true

function update()
    print("Updating software")
    fs.delete(scriptFileName .. ".lua")
    v = http.get(versionURL .. "?t=" .. os.time())
    s = http.get(scriptURL .. "?t=" .. os.time())
    fVersion = fs.open("version", "w")
    fMonitor = fs.open(scriptFileName .. ".lua", "w")
    fVersion.write(v.readAll())
    v.close()
    fVersion.close()
    fMonitor.write(s.readAll())
    s.close()
    fMonitor.close()
    print("Update finished")
end

function checkVersion()
    print("Checking for newer version")
    v = http.get(versionURL .. "?t=" .. os.time())
    local currVersion
    if fs.exists("version") then
        fCV = fs.open("version", "r")
        currVersion = fCV.readAll()
        remoteVersion = v.readAll()
        print("Local: " .. currVersion .. "\nRemote: " .. remoteVersion)
        if currVersion ~= remoteVersion then
            print("Found newer version updating...")
            fCV.close()
            v.close()
            update()
            return true
        else
            print("No update found")
            fCV.close()
            v.close()
            return false
        end
    else
        print("Version not found creating files")
        v.close()
        update()
        return true
    end
end

while true do
    if isFirstRun then
        isFirstRun = false
        _ = checkVersion()
        if fs.exists("version") and fs.exists(scriptFileName .. ".lua") then
            require(scriptFileName)
        else
            print("Failed to find script")
            break
        end
        -- Optional left/right screen
        if fs.exists("leftMonitor.lua") then
            require("leftMonitor")
        end
        if fs.exists("rightMonitor.lua") then
            require("rightMonitor")
        end
    end
    mainTick()
    if fs.exists("leftMonitor.lua") then
        leftTick()
    end
    if fs.exists("rightMonitor.lua") then
       rightTick()
    end

    -- debug
    -- hasUpdated = checkVersion()
    -- if not hasUpdated then
    --     tick()
    -- else
    --     package.loaded[ 'monitor' ] = nil
    --     print("Reloading")
    --     require("monitor")
    -- end
    sleep(1)
end
