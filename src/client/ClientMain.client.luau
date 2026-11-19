local player=game:GetService("Players").LocalPlayer
local ClientMain={}
local modules=script.Parent
local HUD=require(modules:WaitForChild("HUDController"))
local Effects=require(modules:WaitForChild("EffectsController"))
local Emotes=require(modules:WaitForChild("EmoteController"))
local Menu=require(modules:WaitForChild("MenuController"))
local Interaction=require(modules:WaitForChild("InteractionController"))
local ProximityLabels=require(modules:WaitForChild("ProximityLabels"))
local function initialize(name, callback)
 local ok,err=pcall(callback)
 if not ok then warn(name.." initialization failed: "..tostring(err)) end
 return ok
end
initialize("HUD",function() HUD.Init(player) end)
initialize("Effects",function() Effects.Init(player) end)
initialize("Emotes",function() Emotes.Init(player,HUD) end)
initialize("Menu",function() Menu.Init(player,HUD) end)
initialize("Interaction",function() Interaction.Init(player,HUD) end)
initialize("ProximityLabels",function() ProximityLabels.Init() end)
