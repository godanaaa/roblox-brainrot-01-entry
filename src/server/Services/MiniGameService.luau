local Mini={}
local Players=game:GetService("Players")
function Mini.Init(ctx) Mini.Context=ctx; Mini.Count=0 end
local function reward(player,name)
 local ctx=Mini.Context; ctx.Coin.Add(player,100,"mini-game win"); player:SetAttribute("Wins",(player:GetAttribute("Wins") or 0)+1); ctx.Daily.Increment(player,"MinigameWins",1); ctx.Announce.All(player.Name.." won "..name.."!")
end
function Mini.Start()
 local ctx=Mini.Context; Mini.Count+=1; local players=Players:GetPlayers(); if #players==0 then return end
 local name=({"Don't Fall","Chicken Tag","Button Panic"})[(Mini.Count-1)%3+1]; ctx.Announce.All("MINI-GAME: "..name.." starts now!")
 if name=="Button Panic" then
  local arena=Instance.new("Model"); arena.Name="Button Panic Arena"; arena.Parent=workspace; local correct=math.random(1,5)
  for i=1,5 do local button=Instance.new("Part"); button.Name="Button"..i; button.Size=Vector3.new(5,1,5); button.Position=Vector3.new((i-3)*8,2,-35); button.Anchored=true; button.Color=i==correct and Color3.fromRGB(30,255,80) or Color3.fromRGB(255,70,70); button.Parent=arena; local prompt=Instance.new("ProximityPrompt"); prompt.ActionText="Press"; prompt.ObjectText="Button"; prompt.Parent=button; prompt.Triggered:Connect(function(player)if i==correct and arena.Parent then reward(player,name); arena:Destroy() elseif button.Parent then button.Color=Color3.fromRGB(60,60,60); prompt.Enabled=false end end) end
  task.delay(30,function()if arena.Parent then arena:Destroy(); ctx.Announce.All("Button Panic timed out!")end end)
 elseif name=="Chicken Tag" then
  local chicken=players[math.random(1,#players)]; local tagged=0; chicken:SetAttribute("IsChicken",true); ctx.Announce.All(chicken.Name.." is the chicken! Tag someone in 60 seconds!")
  local root=chicken.Character and chicken.Character:FindFirstChild("HumanoidRootPart")
  local connection
  if root then connection=root.Touched:Connect(function(hit) local target=Players:GetPlayerFromCharacter(hit.Parent); if target and target~=chicken and not target:GetAttribute("WasTagged") then target:SetAttribute("WasTagged",true); tagged+=1; ctx.Coin.Add(target,25,"tagged by chicken") end end) end
  task.delay(60,function()if connection then connection:Disconnect()end; chicken:SetAttribute("IsChicken",false); for _,p in ipairs(players)do p:SetAttribute("WasTagged",false)end; if chicken.Parent and tagged>0 then reward(chicken,name) else ctx.Announce.All("Nobody got tagged. The chicken is suspiciously bad at this.")end end)
 else
  local arena=Instance.new("Model"); arena.Name="Don't Fall Arena"; arena.Parent=workspace; local tiles={}
  for x=1,5 do for z=1,5 do local tile=Instance.new("Part"); tile.Name="Disappearing Tile"; tile.Size=Vector3.new(9,1,9); tile.Position=Vector3.new((x-3)*10,22,(z-3)*10); tile.Anchored=true; tile.Color=Color3.fromRGB(75+math.random(0,120),100,220); tile.Parent=arena; table.insert(tiles,tile) end end
  for _,player in ipairs(players)do local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(math.random(-20,20),28,math.random(-20,20))end end
  local running=true; task.spawn(function()while running and arena.Parent do task.wait(1.5); if #tiles>1 then local i=math.random(1,#tiles); local tile=table.remove(tiles,i); if tile.Parent then tile:Destroy()end end; local alive={}; for _,player in ipairs(players)do local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if root and root.Position.Y>5 then table.insert(alive,player)end end; if #alive<=1 then running=false; if alive[1] then reward(alive[1],name) else ctx.Announce.All("Don't Fall ended with no survivor!")end; arena:Destroy()end end end)
  task.delay(45,function()if arena.Parent then running=false; local winner; for _,player in ipairs(players)do local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if root and root.Position.Y>5 then winner=player end end; if winner then reward(winner,name)end; arena:Destroy()end end)
 end
end
return Mini
