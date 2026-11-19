local player=game:GetService("Players").LocalPlayer
local ClientMain={}
local modules=script.Parent
local HUD=require(modules:WaitForChild("HUDController"))
local Menu=require(modules:WaitForChild("MenuController"))
local Effects=require(modules:WaitForChild("EffectsController"))
local Emotes=require(modules:WaitForChild("EmoteController"))
local Interaction=require(modules:WaitForChild("InteractionController"))
local ProximityLabels=require(modules:WaitForChild("ProximityLabels"))
HUD.Init(player)
Effects.Init(player)
Emotes.Init(player,HUD)
Menu.Init(player,HUD)
Interaction.Init(player,HUD)
ProximityLabels.Init()
