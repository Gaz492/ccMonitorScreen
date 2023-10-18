monitor = peripheral.wrap("top")
batBox1 = peripheral.wrap("blockReader_4")
batBox2 = peripheral.wrap("blockReader_5")
batBox3 = peripheral.wrap("blockReader_0")
-- batBox4 = peripheral.wrap("blockReader_3")

-- lavaTank = peripheral.wrap("blockReader_4")
bioFuelTank = peripheral.wrap("blockReader_1")
-- essenceTank = peripheral.wrap("blockReader_6")

rsStorage = peripheral.wrap("rsBridge_1")

monBG = colors.gray
winBG = colors.black

monitor.setBackgroundColor(monBG)
monitor.clear()
monX, monY = monitor.getSize()
print("MonX: " .. monX .. ", MonY: " .. monY)

local tank1 = window.create(monitor, 7, 2, 15, 13)
local tank2 = window.create(monitor, 29, 2, 15, 13)
local tank3 = window.create(monitor, 52, 2, 15, 13)

local lvWindow = window.create(monitor, 6, 16, 28, 5)
local mvWindow = window.create(monitor, 39, 16, 28, 5)
local hvWindow = window.create(monitor, 6, 22, 28, 5)
local evWindow = window.create(monitor, 39, 22, 28, 5)

local storageWindow = window.create(monitor, 6, 28, 61, 5)

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

    for i = 0, 9 do
        drawPixel(window, x, y + i, colors.white)
        drawPixel(window, x + 14, y + i, colors.white)
    end

    for i = 1, 13 do
        drawPixel(window, x + i, y + 9, colors.white)
    end

    rows = roundNum((percentage / 13), 0)

    for i = 8 - rows, 8 do
        for j = 1, 13 do
            if tankName == "Lava" then
                if math.random(1, 20 - i) == 1 then
                    if math.random(1, 4) == 1 then
                        drawPixel(window, x + j, y + i, colors.black)
                    else
                        drawPixel(window, x + j, y + i, colors.orange)
                    end
                else
                    drawPixel(window, x + j, y + i, color)
                end
            elseif tankName == "BioFuel" then
                if math.random(1, 20 - i) == 1 then
                    drawPixel(window, x + j, y + i, colors.magenta)
                else
                    drawPixel(window, x + j, y + i, color)
                end
            elseif tankName == "Essence" then
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

    window.setCursorPos(x, y + 10)
    window.setBackgroundColor(monBG)
    window.clearLine()
    window.setCursorPos(x, y + 11)
    window.clearLine()
    window.setTextColor(colors.white)
    window.write(tankName .. " " .. tostring(percentage) .. "%")
    window.setCursorPos(x, y + 12)
    window.clearLine()
    window.write(tostring(shortenNum(currentLiq)) .. "/" .. tostring(shortenNum(maxLiq)) .. "")
end

function drawEnergy(window, name, unit, x, y, energyMax, energyCurrent)
    window.setBackgroundColor(winBG)
    window.clear()
    energyPercent = roundNum(((energyCurrent / energyMax) * 100), 0)
    energyCols = roundNum((energyPercent / (10 / 2.5)), 0)

    drawPixel(window, x, y + 3, colors.white)
    drawPixel(window, x + 27, y + 3, colors.white)

    for i = 0, 27 do
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
    window.write(format_int(roundNum(energyCurrent)) .. unit .. " / " .. format_int(roundNum(energyMax)) .. unit)
    window.setBackgroundColor(winBG)
end

function drawStorageSpace(window, name, x, y, storageMax, storageCurrent)
    window.setBackgroundColor(winBG)
    window.clear()
    storagePercent = roundNum(((storageCurrent / storageMax) * 100), 0)
    storageCols = roundNum((storagePercent / (10 / 5.8)), 0)
    
    for i = 0, storageCols do
        drawPixel(window, x + 1 + i, y + 3, colors.red)
    end
    drawPixel(window, x, y + 3, colors.white)
    drawPixel(window, x + 60, y + 3, colors.white)

    for i = 0, 68 do
        drawPixel(window, x + i, y + 2, colors.white)
        drawPixel(window, x + i, y + 4, colors.white)
    end


    window.setCursorPos(x, y)
    window.setBackgroundColor(monBG)
    window.clearLine()
    window.setTextColor(colors.white)
    window.write(name .. " " .. storagePercent .. "%")
    window.setCursorPos(x, y + 1)
    window.clearLine()
    window.write(format_int(storageCurrent) .. " / " .. format_int(storageMax) .. " - " .. "Most popular item: " .. getTopStored(rsStorage.listItems()))
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
    if n >= 10 ^ 6 then
        return string.format("%.2fM", n / 10 ^ 6)
    elseif n >= 10 ^ 3 then
        return string.format("%.2fK", n / 10 ^ 3)
    else
        return tostring(n)
    end
end

function renderLavaTank()
    -- drawTank(tank1, "Lava Tank", 1, 1, colors.red, storageTable[lavaTank.getBlockData()["id"]],
        -- lavaTank.getBlockData()["tank"].Amount)
end
function renderBioFuelTank()
        drawTank(tank2, "BioFuel", 1, 1, colors.purple, storageTable[bioFuelTank.getBlockData()["id"]],
            bioFuelTank.getBlockData()["tank"].Amount)
end
function renderEssenceTank()
    --     drawTank(tank3, "Essence Tank", 1, 1, colors.green, storageTable[essenceTank.getBlockData()["id"]],
    --         essenceTank.getBlockData()["tank"].Amount)
end
function renderBB1()
    drawEnergy(lvWindow, "EV BatBox S1", "Z", 1, 1, storageTable[batBox1.getBlockData()["id"]],
        batBox1.getBlockData()["Energy"])
end
function renderBB2()
        drawEnergy(mvWindow, "EV BatBox S2", "Z", 1, 1, storageTable[batBox2.getBlockData()["id"]],
        batBox2.getBlockData()["Energy"])
end
function renderBB3()
    drawEnergy(hvWindow, "EV BatBox Auto", "Z", 1, 1, storageTable[batBox3.getBlockData()["id"]],
    batBox3.getBlockData()["Energy"])
end
function renderBB4()
    --     drawEnergy(evWindow, "EV BatBox", "Z", 1, 1, storageTable[batBox4.getBlockData()["id"]],
    --         batBox4.getBlockData()["Energy"])
end
function renderStorage()
    drawStorageSpace(storageWindow, "RS Storage", 1, 1, rsStorage.getMaxItemDiskStorage(),
        tableLength(rsStorage.listItems()))
end

function tick()
    parallel.waitForAll(renderLavaTank, renderBioFuelTank, renderEssenceTank, renderBB1, renderBB2, renderBB3, renderBB4,
        renderStorage)
end
