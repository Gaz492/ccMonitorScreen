local monitoring = {}
monitor = peripheral.wrap("top")
-- lvBatBox = peripheral.wrap("blockReader_0")
-- mvBatBox = peripheral.wrap("blockReader_1")
hvBatBox = peripheral.wrap("blockReader_0")
-- evBatBox = peripheral.wrap("blockReader_3")

-- lavaTank = peripheral.wrap("blockReader_4")
-- bioFuelTank = peripheral.wrap("blockReader_5")
-- essenceTank = peripheral.wrap("blockReader_6")

rsStorage = peripheral.wrap("rsBridge_1")

monBG = colors.gray
winBG = colors.black

monitor.setBackgroundColor(monBG)
monitor.clear()
monX, monY = monitor.getSize()
print("MonX: " .. monX .. ", MonY: " .. monY)

local tank1 = window.create(monitor, 4, 2, 15, 11)
local tank2 = window.create(monitor, 28, 2, 15, 11)
local tank3 = window.create(monitor, 52, 2, 15, 11)

local lvWindow = window.create(monitor, 6, 19, 33, 5)
local mvWindow = window.create(monitor, 42, 19, 33, 5)
local hvWindow = window.create(monitor, 6, 25, 33, 5)
local evWindow = window.create(monitor, 42, 25, 33, 5)

local storageWindow = window.create(monitor, 6, 32, 69, 5)

storageTable = {
    -- FTB:IC Energy Storage
    ["ftbic:lv_battery_box"] = 40000,
    ["ftbic:mv_battery_box"] = 400000,
    ["ftbic:hv_battery_box"] = 4000000,
    ["ftbic:ev_battery_box"] = 40000000,
    -- Tanks
    ["industrialforegoing:common_black_hole_tank"] = 16000,
    ["industrialforegoing:pity_black_hole_tank"] = 64000,
    ["industrialforegoing:simple_black_hole_tank"] = 1024000,
    ["industrialforegoing:advanced_black_hole_tank"] = 65536000,
    ["industrialforegoing:supreme_black_hole_tank"] = 2147483647
}

function roundNum(val, decimal)
    if (decimal) then
        return math.floor(((val * 10 ^ decimal) + 0.5) / (10 ^ decimal))
    else
        return math.floor(val + 0.5)
    end
end

function drawPixel(window, x, y, color)
    window.setCursorPos(x, y)
    window.setBackgroundColor(color)
    window.write(" ")
end

function drawTank(window, tankName, x, y, color, maxLiq, currentLiq)
    window.setBackgroundColor(winBG)
    window.clear()
    if currentLiq == nil then
        currentLiq = 0
    end

    if maxLiq == nil then
        maxLiq = 0
    end

    percentage = roundNum(((currentLiq / maxLiq) * 100), 0)

    for i = 0, 11 do
        drawPixel(window, x, y + i, colors.white)
        drawPixel(window, x + 18, y + i, colors.white)
    end

    for i = 1, 17 do
        drawPixel(window, x + i, y + 11, colors.white)
    end

    rows = roundNum((percentage / 10), 0)

    for i = 10 - rows, 10 do
        for j = 1, 17 do
            if tankName == "Lava Tank" then
                if math.random(1, 20 - i) == 1 then
                    if math.random(1, 4) == 1 then
                        drawPixel(window, x + j, y + i, colors.black)
                    else
                        drawPixel(window, x + j, y + i, colors.orange)
                    end
                else
                    drawPixel(window, x + j, y + i, color)
                end
            elseif tankName == "BioFuel Tank" then
                if math.random(1, 20 - i) == 1 then
                    drawPixel(window, x + j, y + i, colors.magenta)
                else
                    drawPixel(window, x + j, y + i, color)
                end
            elseif tankName == "Essence Tank" then
                if math.random(1, 20 - i) == 1 then
                    drawPixel(window, x + j, y + i, colors.lime)
                else
                    drawPixel(window, x + j, y + i, color)
                end
            else
                drawPixel(window, x + j, y + i, color)
            end
        end
    end

    window.setCursorPos(x, y + 12)
    window.setBackgroundColor(monBG)
    window.clearLine()
    window.setCursorPos(x, y + 13)
    window.clearLine()
    window.setTextColor(colors.white)
    window.write(tankName .. "  " .. tostring(percentage) .. "%")
    window.setCursorPos(x, y + 14)
    window.clearLine()
    window.write(tostring(shortenNum(currentLiq)) .. "mB / " .. tostring(shortenNum(maxLiq)) .. "mB")
end

function drawEnergy(window, name, unit, x, y, energyMax, energyCurrent)
    window.setBackgroundColor(winBG)
    window.clear()
    energyPercent = roundNum(((energyCurrent / energyMax) * 100), 0)
    energyCols = roundNum((energyPercent / (10 / 3)), 0)

    drawPixel(window, x, y + 3, colors.white)
    drawPixel(window, x + 32, y + 3, colors.white)

    for i = 0, 32 do
        drawPixel(window, x + i, y + 2, colors.white)
        drawPixel(window, x + i, y + 4, colors.white)
    end

    for i = 0, energyCols do
        drawPixel(window, x + 1 + i, y + 3, colors.red)
    end

    window.setCursorPos(x, y)
    window.setBackgroundColor(monBG)
    window.clearLine()
    window.setTextColor(colors.white)
    window.write(name .. " " .. energyPercent .. "%")
    window.setCursorPos(x, y + 1)
    window.clearLine()
    window.write(format_int(energyCurrent) .. unit .. " / " .. format_int(energyMax) .. unit)
    window.setBackgroundColor(winBG)
end

function drawStorageSpace(window, name, x, y, storageMax, storageCurrent)
    window.setBackgroundColor(winBG)
    window.clear()
    storagePercent = roundNum(((storageCurrent / storageMax) * 100), 0)
    storageCols = roundNum((storagePercent / (10 / 6.6)), 0)

    drawPixel(window, x, y + 3, colors.white)
    drawPixel(window, x + 68, y + 3, colors.white)

    for i = 0, 68 do
        drawPixel(window, x + i, y + 2, colors.white)
        drawPixel(window, x + i, y + 4, colors.white)
    end

    for i = 0, storageCols do
        drawPixel(window, x + 1 + i, y + 3, colors.red)
    end

    window.setCursorPos(x, y)
    window.setBackgroundColor(monBG)
    window.clearLine()
    window.setTextColor(colors.white)
    window.write(name .. " " .. storagePercent .. "%")
    window.setCursorPos(x, y + 1)
    window.clearLine()
    window.write(format_int(storageCurrent) .. " / " .. format_int(storageMax))
    window.setBackgroundColor(winBG)
end

function tableLength(T)
    local count = 0
    for _, v in pairs(T) do
        count = count + v["amount"]
    end
    return count
end

function getTopStored(T)
    length = tableLength(T)
    if length > 0 then
        table.sort(T, function(a, b)
            return a.amount > b.amount
        end)
        return T[1].displayName
    end
    return "null"
end

function format_int(number)

    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    -- reverse the int-string back remove an optional comma and put the 
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

function shortenNum(n)
    if n >= 10^6 then
        return string.format("%.2fM ", n / 10^6)
    elseif n >= 10^3 then
        return string.format("%.2fK ", n / 10^3)
    else
        return tostring(n)
    end
end


function renderLavaTank()
--     drawTank(tank1, "Lava Tank", 1, 1, colors.red, storageTable[lavaTank.getBlockData()["id"]],
--         lavaTank.getBlockData()["tank"].Amount)
end
function renderBioFuelTank()
--     drawTank(tank2, "BioFuel Tank", 1, 1, colors.purple, storageTable[bioFuelTank.getBlockData()["id"]],
--         bioFuelTank.getBlockData()["tank"].Amount)
end
function renderEssenceTank()
--     drawTank(tank3, "Essence Tank", 1, 1, colors.green, storageTable[essenceTank.getBlockData()["id"]],
--         essenceTank.getBlockData()["tank"].Amount)
end
function renderLV()
--     drawEnergy(lvWindow, "LV BatBox", "Z", 1, 1, storageTable[lvBatBox.getBlockData()["id"]],
--         lvBatBox.getBlockData()["Energy"])
end
function renderMV()
--     drawEnergy(mvWindow, "MV BatBox", "Z", 1, 1, storageTable[mvBatBox.getBlockData()["id"]],
--         mvBatBox.getBlockData()["Energy"])
end
function renderHV()
    drawEnergy(hvWindow, "HV BatBox", "Z", 1, 1, storageTable[hvBatBox.getBlockData()["id"]],
        hvBatBox.getBlockData()["Energy"])
end
function renderEV()
--     drawEnergy(evWindow, "EV BatBox", "Z", 1, 1, storageTable[evBatBox.getBlockData()["id"]],
--         evBatBox.getBlockData()["Energy"])
end
function renderStorage()
    drawStorageSpace(storageWindow, "RS Storage", 1, 1, rsStorage.getMaxItemDiskStorage(),
        tableLength(rsStorage.listItems()))
end

function monitoring.init()
    while true do
        parallel.waitForAll(renderLavaTank, renderBioFuelTank, renderEssenceTank, renderLV, renderMV, renderHV, renderEV,
            renderStorage)
        monitor.setCursorPos(6, 38)
        monitor.clearLine()
        monitor.write("Most popular item: " .. getTopStored(rsStorage.listItems()))

        sleep(1)
    end
end
