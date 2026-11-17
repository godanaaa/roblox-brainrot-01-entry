local Game={}
local Players=game:GetService("Players")
function Game.Init(ctx)
 Game.Context=ctx
 local function setup(p)
  if p:FindFirstChild("leaderstats") then return end
  local ls=Instance.new("Folder"); ls.Name="leaderstats"; ls.Parent=p
  for _,pair in ipairs({{"Meme Coins",0},{"Events Survived",0},{"Wins",0}}) do local v=Instance.new("IntValue"); v.Name=pair[1]; v.Value=pair[2]; v.Parent=ls end
  ls["Meme Coins"].Value=p:GetAttribute("Coins") or 0; ls["Events Survived"].Value=p:GetAttribute("EventsSurvived") or 0; ls.Wins.Value=p:GetAttribute("Wins") or 0
  p:GetAttributeChangedSignal("Coins"):Connect(function()ls["Meme Coins"].Value=p:GetAttribute("Coins") or 0 end)
  p:GetAttributeChangedSignal("EventsSurvived"):Connect(function()ls["Events Survived"].Value=p:GetAttribute("EventsSurvived") or 0 end)
  p:GetAttributeChangedSignal("Wins"):Connect(function()ls.Wins.Value=p:GetAttribute("Wins") or 0 end)
 end
 Players.PlayerAdded:Connect(setup); for _,p in ipairs(Players:GetPlayers()) do setup(p) end
 local function load(p)
  if not p:GetAttribute("Playing") then return end
  local waited=0; while (ctx.Data and not ctx.Data.Data[p] or p:GetAttribute("BaseReady")==false) and waited<60 do task.wait(.1); waited+=.1 end
  p:LoadCharacter(); task.wait(.15); local char=p.Character; local root=char and char:WaitForChild("HumanoidRootPart",5); if root then local index=p:GetAttribute("PlotIndex"); local plot; for _,m in ipairs(workspace.BrainrotMap.Plots:GetChildren()) do if m:GetAttribute("PlotIndex")==index then plot=m end end; root.CFrame=plot and plot:FindFirstChild("Owner Spawn").CFrame*CFrame.new(0,4,0) or CFrame.new(0,5,0) end
  local hum=char and char:FindFirstChildOfClass("Humanoid"); if hum then hum.Died:Connect(function()task.delay(4,function()if p.Parent and p:GetAttribute("Playing")then load(p)end end)end) end
 end
 ctx.Remotes.Play.OnServerEvent:Connect(function(p) if p:GetAttribute("Playing") then return end; p:SetAttribute("Playing",true); load(p); ctx.Remotes.State:FireClient(p,ctx.Snapshot(p)) end)
 ctx.Remotes.State.OnServerEvent:Connect(function(p,action) if action=="Request" then ctx.Remotes.State:FireClient(p,ctx.Snapshot(p)) end end)
 task.spawn(function()while true do task.wait(10); local scores={}; for _,p in ipairs(Players:GetPlayers())do table.insert(scores,{Name=p.Name,Coins=ctx.Coin.Get(p)})end; table.sort(scores,function(a,b)return a.Coins>b.Coins end); while #scores>5 do table.remove(scores)end; ctx.Remotes.State:FireAllClients({Leaderboard=scores,Players=#Players:GetPlayers()})end end)
end
return Game
