local monitorTop = peripheral.wrap("top")
local rftPower1 = peripheral.wrap("rftoolspower:cell3_0")

local fluidTank1 = peripheral.wrap("dynamicValve_0") -- Lava
local fluidTank2 = peripheral.wrap("dynamicValve_1") -- XP
local fluidTank3 = peripheral.wrap("dynamicValve_3") -- ??????

local rsStorage = peripheral.wrap("rsBridge_0")

require("utils")

local monBG = colors.gray
local winBG = colors.black

monitorTop.setBackgroundColor(monBG)
monitorTop.clear()
local monX, monY = monitorTop.getSize()
print("MonX: " .. monX .. ", MonY: " .. monY)

local tank1 = window.create(monitorTop, 7, 2, 15, 13)
local tank2 = window.create(monitorTop, 29, 2, 15, 13)
local tank3 = window.create(monitorTop, 52, 2, 15, 13)

local powerWindow1 = window.create(monitorTop, 6, 16, 28, 5)
local powerWindow2 = window.create(monitorTop, 39, 16, 28, 5)
local powerWindow3 = window.create(monitorTop, 6, 22, 28, 5)
local powerWindow4 = window.create(monitorTop, 39, 22, 28, 5)

local storageWindow = window.create(monitorTop, 6, 28, 61, 5)

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

    if percentage ~= 0 then
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

function drawEnergy(window, name, unit, x, y, energyMax, energyCurrent, energyUsage)
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

    local energryString = ""
    if energyUsage ~= nil then
        energryString = tostring(shortenNum(roundNum(energyCurrent))) .. unit .. "/" .. tostring(shortenNum(roundNum(energyMax))) .. unit .. "|" .. tostring(shortenNum(energyUsage))
    else
        energryString = tostring(shortenNum(roundNum(energyCurrent))) .. unit .. "/" .. tostring(shortenNum(roundNum(energyMax))) .. unit
    end

    window.setCursorPos(x, y)
    window.setBackgroundColor(monBG)
    window.clearLine()
    window.setTextColor(colors.white)
    window.write(name .. " " .. energyPercent .. "%")
    window.setCursorPos(x, y + 1)
    window.clearLine()
    window.write(energryString)
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
    window.write(tostring(shortenNum(storageCurrent)) .. " / " .. tostring(shortenNum(storageMax)) .. " - " .. "Most popular item: " .. getTopStored(rsStorage.listItems()))
    window.setBackgroundColor(winBG)
end

-- TANKS
function renderFluidTank1()
    tank1.setVisible(false)
    drawTank(tank1, "Lava", 1, 1, colors.red, fluidTank1.getTankCapacity(),
        fluidTank1.getStored()["amount"])
    tank1.setVisible(true)
end
function renderFluidTank2()
    tank2.setVisible(false)
    drawTank(tank2, "Essence", 1, 1, colors.green, fluidTank2.getTankCapacity(), fluidTank2.getStored()["amount"])
    tank2.setVisible(true)
end
function renderFluidTank3()
    tank2.setVisible(false)
    drawTank(tank3, "BioFuel", 1, 1, colors.purple, fluidTank3.getTankCapacity(), fluidTank3.getStored()["amount"])
    tank2.setVisible(true)
end

-- POWER
function renderPower1()
    powerWindow1.setVisible(false)
    drawEnergy(powerWindow1, "Cell 1", "RF", 1, 1, rftPower1.getEnergyCapacity(), rftPower1.getEnergy())
    powerWindow1.setVisible(true)
end

function renderPower2()
    powerWindow2.setVisible(false)
    drawEnergy(powerWindow2, "RS", "RF", 1, 1, rsStorage.getMaxEnergyStorage(), rsStorage.getEnergyStorage(), rsStorage.getEnergyUsage())
    powerWindow2.setVisible(true)
end
-- function renderBB2()
--         drawEnergy(mvWindow, "EV BatBox S2", "Z", 1, 1, storageTable[batBox2.getBlockData()["id"]],
--         batBox2.getBlockData()["Energy"])
-- end
-- function renderBB3()
--     drawEnergy(hvWindow, "EV BatBox Auto", "Z", 1, 1, storageTable[batBox3.getBlockData()["id"]],
--     batBox3.getBlockData()["Energy"])
-- end
-- function renderBB4()
--     --     drawEnergy(evWindow, "EV BatBox", "Z", 1, 1, storageTable[batBox4.getBlockData()["id"]],
--     --         batBox4.getBlockData()["Energy"])
-- end

-- STORAGE
function renderStorage()
    storageWindow.setVisible(false)
    drawStorageSpace(storageWindow, "RS Storage", 1, 1, rsStorage.getMaxItemDiskStorage() + rsStorage.getMaxItemExternalStorage(),
        tableLength(rsStorage.listItems()))
    storageWindow.setVisible(true)
end

function mainTick()
    -- parallel.waitForAll(renderLavaTank, renderBioFuelTank, renderEssenceTank, renderBB1, renderBB2, renderBB3, renderBB4, renderStorage)
    parallel.waitForAll(
        renderFluidTank1,
        renderFluidTank2,
        renderFluidTank3,
        renderPower1,
        renderPower2,
        renderStorage
    )
end