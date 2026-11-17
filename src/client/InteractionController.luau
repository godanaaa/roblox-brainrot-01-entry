local CAS=game:GetService("ContextActionService")
local Interaction={}
function Interaction.Init(player,hud)
 local function nearestPrompt()
  local char=player.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return nil end
  local best,dist
  for _,obj in ipairs(workspace:GetDescendants())do if obj:IsA("ProximityPrompt") and obj.Enabled then local host=obj.Parent; local part=host:IsA("BasePart") and host or host:IsA("Model") and host.PrimaryPart; if part then local d=(part.Position-root.Position).Magnitude; if d<=obj.MaxActivationDistance and (not dist or d<dist) then best=obj;dist=d end end end end
  return best
 end
 local current
 local function touchAction(_,state) if state==Enum.UserInputState.Begin then current=nearestPrompt(); if current then current:InputHoldBegin() end elseif state==Enum.UserInputState.End then if current then current:InputHoldEnd(); current=nil end end; return Enum.ContextActionResult.Sink end
 CAS:BindAction("BrainrotInteract",touchAction,false,Enum.KeyCode.E)
 hud.InteractButton.InputBegan:Connect(function(input)if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then touchAction(nil,Enum.UserInputState.Begin)end end)
 hud.InteractButton.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then touchAction(nil,Enum.UserInputState.End)end end)
end
return Interaction
