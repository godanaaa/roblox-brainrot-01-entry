local Daily={}
local Players=game:GetService("Players")
Daily.Challenges={
 {Name="Survive 10 events",Goal=10,Key="EventsSurvived",Reward=500},
 {Name="Get launched 5 times",Goal=5,Key="Launched",Reward=250},
 {Name="Find a secret room",Goal=1,Key="SecretRoom",Reward=300},
 {Name="Win a mini-game",Goal=1,Key="MinigameWins",Reward=400},
}
function Daily.Init(ctx)
 Daily.Context=ctx; Daily.Progress={}
 local function load(player)
  task.spawn(function()
   for _=1,600 do local data=ctx.Data and ctx.Data.Data[player]
    if data then Daily.Progress[player]=type(data.Daily)=="table" and data.Daily or {}; return end
    task.wait(.1)
   end
   Daily.Progress[player]={}
  end)
 end
 Players.PlayerAdded:Connect(load); for _,player in ipairs(Players:GetPlayers()) do load(player) end
 Players.PlayerRemoving:Connect(function(player) Daily.Progress[player]=nil end)
 ctx.Remotes.Panel.OnServerEvent:Connect(function(player,action)
  if action~="Daily" then return end
  ctx.Remotes.State:FireClient(player,{Daily=Daily.Challenges,Progress=Daily.Progress[player] or {}})
 end)
end
function Daily.GetProgress(player) return Daily.Progress[player] or {} end
function Daily.Increment(player,key,amount)
 if not player or not player.Parent or type(key)~="string" then return false end
 local progress=Daily.Progress[player]; if not progress then progress={}; Daily.Progress[player]=progress end
 local increment=math.clamp(math.floor(tonumber(amount) or 1),0,100); if increment==0 then return false end
 local matched=false
 for _,challenge in ipairs(Daily.Challenges) do
  if challenge.Key==key then
   matched=true; local old=math.clamp(math.floor(tonumber(progress[key]) or 0),0,challenge.Goal)
   local nextValue=math.min(challenge.Goal,old+increment); progress[key]=nextValue
   local marker="Done_"..key
   if nextValue>=challenge.Goal and not progress[marker] then
    progress[marker]=true; Daily.Context.Coin.Add(player,challenge.Reward,"daily challenge complete")
    Daily.Context.Announce.To(player,"DAILY COMPLETE: "..challenge.Name.." • +"..challenge.Reward.." coins!")
   end
  end
 end
 return matched
end
return Daily
