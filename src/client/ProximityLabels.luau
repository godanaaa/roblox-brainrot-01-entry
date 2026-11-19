local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
local Labels={}
local RANGE=20
local tracked={}

local function add(instance)
 if instance:IsA("BillboardGui") then
  tracked[instance]={kind="billboard",visible=false}
  instance.Enabled=false
 elseif instance:IsA("SurfaceGui") and instance.Name~="TitleSurface" then
  tracked[instance]={kind="surface",visible=false}
  instance.Enabled=false
 end
end

local function transparency(gui,value)
 for _,child in ipairs(gui:GetDescendants()) do
  if child:IsA("TextLabel") or child:IsA("TextButton") then
   TweenService:Create(child,TweenInfo.new(.16,Enum.EasingStyle.Quad),{TextTransparency=value,TextStrokeTransparency=value}):Play()
  end
 end
end

function Labels.Init()
 for _,instance in ipairs(workspace:GetDescendants()) do add(instance) end
 workspace.DescendantAdded:Connect(add)
 workspace.DescendantRemoving:Connect(function(instance) tracked[instance]=nil end)
 task.spawn(function()
  while player.Parent do
   local character=player.Character
   local root=character and character:FindFirstChild("HumanoidRootPart")
   for gui,meta in pairs(tracked) do
    local adornee=gui:IsA("BillboardGui") and gui.Adornee or gui.Parent
    local position=adornee and (adornee:IsA("BasePart") and adornee.Position or adornee:IsA("Model") and adornee:GetPivot().Position)
    local near=root and position and (position-root.Position).Magnitude<=RANGE
    if near and not meta.visible then meta.visible=true; gui.Enabled=true; transparency(gui,0)
    elseif not near and meta.visible then meta.visible=false; transparency(gui,1); task.delay(.17,function() if gui.Parent and not meta.visible then gui.Enabled=false end end) end
   end
   task.wait(.2)
  end
 end)
end

return Labels
