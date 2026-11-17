local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Effects={}
function Effects.Init(player)
 local remotes=ReplicatedStorage:WaitForChild("Remotes"); local camera=workspace.CurrentCamera; local shakeUntil=0
 remotes.Event.OnClientEvent:Connect(function(event)
  if event.Name=="BRAINROT" or event.Name=="Meteor Shower" or event.Name=="Giant Chicken" then shakeUntil=os.clock()+math.min(event.Duration or 2,8) end
  if event.Name=="BRAINROT" then local color=Instance.new("ColorCorrectionEffect"); color.Name="TemporaryBrainrotTint"; color.TintColor=Color3.fromRGB(215,145,255); color.Saturation=.3; color.Parent=game.Lighting; task.delay(event.Duration or 45,function()if color.Parent then color:Destroy()end end) end
 end)
 local elapsed=0; RunService.RenderStepped:Connect(function(dt) if os.clock()<shakeUntil and camera then elapsed+=dt; camera.CFrame=camera.CFrame*CFrame.new(math.sin(elapsed*55)*.07,math.cos(elapsed*45)*.05,0) end end)
end
return Effects
