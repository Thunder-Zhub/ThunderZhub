local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- [[ SERVICES ]]
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIGURATION ]]
local ICON_ID = "rbxassetid://129491563059955"

-- [[ 1. CLEANUP OLD UI ]]
if CoreGui:FindFirstChild("ThunderToggleGui") then CoreGui.ThunderToggleGui:Destroy() end
if CoreGui:FindFirstChild("ThunderZHubLoading") then CoreGui.ThunderZHubLoading:Destroy() end

-- [[ 2. LOADING SCREEN ]]
local function runLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ThunderZHubLoading"
    ScreenGui.Parent = CoreGui
    ScreenGui.DisplayOrder = 999
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.fromOffset(100, 100)
    Icon.Position = UDim2.new(0.5, -50, 0.45, -50)
    Icon.BackgroundTransparency = 1
    Icon.Image = ICON_ID
    Icon.ImageTransparency = 1
    Icon.Parent = MainFrame
    
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.6}):Play()
    TweenService:Create(Icon, TweenInfo.new(0.5), {ImageTransparency = 0.1}):Play()
    
    task.spawn(function()
        while ScreenGui.Parent do 
            Icon.Rotation = Icon.Rotation + 3 
            task.wait() 
        end
    end)
    
    task.wait(2.5) 
    ScreenGui:Destroy()
end

runLoadingScreen()

-- [[ 3. MAIN WINDOW ]]
local Window = Fluent:CreateWindow({
    Title = "THUNDER Z HUB | The 1,000,000 Jump Rope",
    SubTitle = "by Thunder", 
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- [[ 4. TOGGLE BUTTON ]]
do
    local ScreenGui = Instance.new("ScreenGui")
    local ToggleButton = Instance.new("ImageButton")
    ScreenGui.Name = "ThunderToggleGui"
    ScreenGui.Parent = CoreGui
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ScreenGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ToggleButton.BackgroundTransparency = 0.5
    ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
    ToggleButton.Size = UDim2.fromOffset(45, 45)
    ToggleButton.Image = ICON_ID
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)
    ToggleButton.Draggable = true
    ToggleButton.Active = true
    ToggleButton.MouseButton1Click:Connect(function() Window:Minimize() end)
end

-- [[ 5. FUNCTIONS ]]
local function PurchaseItem(price, itemName)
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Gamepasses_Remotes", 5):WaitForChild("PurchaseShop", 5)
    if remote then
        remote:FireServer(price, itemName)
        Fluent:Notify({Title = "Shop", Content = "Attempted to purchase: " .. itemName, Duration = 3})
    end
end

-- [[ 6. UI ELEMENTS ]]

-- --- MAIN TAB ---
local InfoSection = Tabs.Main:AddSection("Info")
InfoSection:AddButton({
    Title = "Copy Discord Link",
    Description = "Click to copy Discord link",
    Callback = function()
        setclipboard("https://discord.gg/f6Mge5f2w2")
        Fluent:Notify({Title = "Thunder Z Hub", Content = "Discord link copied!", Duration = 3})
    end
})

local ItemSection = Tabs.Main:AddSection("Items")
ItemSection:AddButton({
    Title = "Claim All Free Gear",
    Description = "Runs the event 6 times",
    Callback = function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("FreeGear_Remotes", 5):WaitForChild("FreeGearEvent", 5)
        if remote then
            for i = 1, 6 do remote:FireServer(LocalPlayer) task.wait(0.1) end
            Fluent:Notify({Title = "Items", Content = "Claimed 6 Free Gear items!", Duration = 5})
        end
    end
})

local MoneySection = Tabs.Main:AddSection("Money")
-- "MoneyToggle" คือ ID สำหรับเซฟ
local MoneyToggle = MoneySection:AddToggle("MoneyToggle", {Title = "Auto Farm Money", Default = false })

local SpeedSection = Tabs.Main:AddSection("Speed")
-- "AddSpeedToggle" และ "DelSpeedToggle" คือ ID สำหรับเซฟ
local AddSpeedToggle = SpeedSection:AddToggle("AddSpeedToggle", {Title = "Auto Add Speed", Default = false })
local DelSpeedToggle = SpeedSection:AddToggle("DelSpeedToggle", {Title = "Auto Del Speed", Default = false })

-- --- SHOP TAB ---
local CoilsSection = Tabs.Shop:AddSection("Coils")
CoilsSection:AddButton({Title = "Buy Fire Coil (10k)", Callback = function() PurchaseItem(10000, "FireCoil") end})
CoilsSection:AddButton({Title = "Buy Gold Coil (25k)", Callback = function() PurchaseItem(25000, "GoldCoil") end})
CoilsSection:AddButton({Title = "Buy Void Coil (50k)", Callback = function() PurchaseItem(50000, "VoidCoil") end})
CoilsSection:AddButton({Title = "Buy Super Coil (100k)", Callback = function() PurchaseItem(100000, "SuperCoil") end})

local CarpetSection = Tabs.Shop:AddSection("Carpets")
CarpetSection:AddButton({Title = "Buy Golden Carpet (50k)", Callback = function() PurchaseItem(50000, "GoldenCarpet") end})
CarpetSection:AddButton({Title = "Buy Diamond Carpet (100k)", Callback = function() PurchaseItem(100000, "DiamondCarpet") end})
CarpetSection:AddButton({Title = "Buy Dragon Carpet (150k)", Callback = function() PurchaseItem(150000, "DragonCarpet") end})

local GloveSection = Tabs.Shop:AddSection("Gloves")
GloveSection:AddButton({Title = "Buy Slap Glove (25k)", Callback = function() PurchaseItem(25000, "SlapGlove") end})
GloveSection:AddButton({Title = "Buy Golden Glove (50k)", Callback = function() PurchaseItem(50000, "GoldenGlove") end})
GloveSection:AddButton({Title = "Buy Rainbow Glove (100k)", Callback = function() PurchaseItem(100000, "RainbowGlove") end})
GloveSection:AddButton({Title = "Buy Overkill Glove (200k)", Callback = function() PurchaseItem(200000, "Overkill") end})

local SpecialSection = Tabs.Shop:AddSection("Special")
SpecialSection:AddButton({Title = "Buy Admin (200k)", Callback = function() PurchaseItem(200000, "Admin") end})
SpecialSection:AddButton({Title = "Buy Frontman (500k)", Callback = function() PurchaseItem(500000, "Frontman") end})

-- --- SETTINGS TAB ---
local CharacterSection = Tabs.Settings:AddSection("Character")
-- "ZoomSlider" คือ ID สำหรับเซฟ
CharacterSection:AddSlider("ZoomSlider", {
    Title = "Camera Max Zoom",
    Description = "Adjust how far you can zoom out",
    Default = 400,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        LocalPlayer.CameraMaxZoomDistance = Value
    end
})

-- [[ 7. SAVE & INTERFACE CONFIGURATION ]]
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- กำหนดโฟลเดอร์ที่จะใช้เซฟ (จะอยู่ในโฟลเดอร์ workspace ของ Executor คุณ)
SaveManager:SetFolder("ThunderZHub/TheJumpRope")

-- สร้างหน้าต่างสำหรับจัดการ Config (ปุ่ม Save/Load/Autoload) ในหน้า Settings
SaveManager:BuildConfigSection(Tabs.Settings)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

-- โหลดค่าที่ตั้งไว้ล่าสุดโดยอัตโนมัติ
SaveManager:LoadAutoloadConfig()

-- [[ 8. LOOPS ]]

task.spawn(function()
    while true do
        if Options.MoneyToggle and Options.MoneyToggle.Value then
            local remote = game:GetService("ReplicatedStorage"):WaitForChild("Spin_Remotes", 5):WaitForChild("QuintoPremio", 5)
            if remote then remote:FireServer(LocalPlayer) end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if Options.AddSpeedToggle and Options.AddSpeedToggle.Value then
            local btn = workspace:FindFirstChild("Troll_Buttons") and workspace.Troll_Buttons:FindFirstChild("YellowModel") and workspace.Troll_Buttons.YellowModel:FindFirstChild("Button")
            local rp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if btn and rp then
                rp.CFrame = btn.CFrame
                local cd = btn:FindFirstChildOfClass("ClickDetector") if cd then fireclickdetector(cd) end
                local pp = btn:FindFirstChildOfClass("ProximityPrompt") if pp then fireproximityprompt(pp) end
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if Options.DelSpeedToggle and Options.DelSpeedToggle.Value then
            local btn = workspace:FindFirstChild("Troll_Buttons") and workspace.Troll_Buttons:FindFirstChild("RedModel")
            local rp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if btn and rp then
                rp.CFrame = btn:IsA("Model") and btn:GetModelCFrame() or btn.CFrame
                local cd = btn:FindFirstChildOfClass("ClickDetector") if cd then fireclickdetector(cd) end
                local pp = btn:FindFirstChildOfClass("ProximityPrompt") if pp then fireproximityprompt(pp) end
            end
        end
        task.wait(0.1)
    end
end)

Window:SelectTab(1)