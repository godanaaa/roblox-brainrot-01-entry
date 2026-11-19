local DataService={}
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local function newData()
 return {Coins=0,LifetimeEarned=0,Rebirths=0,RebirthTitle="",Titles={},Wins=0,Events=0,Level=1,Pets={},Cosmetics={},Emotes={},Secrets={},Brainrots={},FoundBrainrots={},Upgrades={ ["Income Boost"]=0, ["Base Shield"]=0 },LabFound=false,Daily={},DailyDate=os.date("!%Y-%m-%d")}
end
function DataService.Init(ctx)
 DataService.Context=ctx; DataService.Data={}; local store
 pcall(function()store=DataStoreService:GetDataStore("BrainrotMayhem_v1")end); DataService.Store=store
 local function load(player)
  if DataService.Data[player] then return end
  local data=newData()
  if store then local ok,loaded=pcall(function()return store:GetAsync("u"..player.UserId)end); if ok and type(loaded)=="table" then for key,value in pairs(loaded)do if value~=nil then data[key]=value end end end end
  local today=os.date("!%Y-%m-%d"); if data.DailyDate~=today then data.Daily={}; data.DailyDate=today end
  DataService.Data[player]=data; ctx.Coin.Load(player,tonumber(data.Coins) or 0,tonumber(data.LifetimeEarned) or tonumber(data.Coins) or 0); player:SetAttribute("Rebirths",tonumber(data.Rebirths) or 0); player:SetAttribute("Wins",tonumber(data.Wins) or 0); player:SetAttribute("EventsSurvived",tonumber(data.Events) or 0); player:SetAttribute("Level",tonumber(data.Level) or 1); local secretCount=0; for _ in pairs(data.Secrets or {})do secretCount+=1 end; player:SetAttribute("SecretsCount",secretCount)
 end
 local function save(player)
  local data=DataService.Data[player]; if not data or not store then return end
  data.Coins=ctx.Coin.Get(player); data.LifetimeEarned=ctx.Coin.GetLifetime(player); data.Rebirths=player:GetAttribute("Rebirths") or 0; data.Wins=player:GetAttribute("Wins") or 0; data.Events=player:GetAttribute("EventsSurvived") or 0; data.Level=player:GetAttribute("Level") or 1; data.DailyDate=os.date("!%Y-%m-%d")
  if ctx.Base then data.Brainrots={}; data.BaseSlots=ctx.Base.SlotCounts[player] or 4; for _,rot in ipairs(ctx.Base.GetOwned(player))do table.insert(data.Brainrots,{Name=rot.Name,Mutation=rot.Mutation})end end
  if ctx.Upgrade then data.Upgrades=ctx.Upgrade.GetUpgrades(player) end
  if ctx.Pet then data.Pets=ctx.Pet.Owned[player] or {}; data.ActivePet=ctx.Pet.ActiveName[player] end
  if ctx.Shop then data.Cosmetics=ctx.Shop.GetOwned(player) end
  if ctx.Daily then data.Daily=ctx.Daily.Progress[player] or {} end
  if ctx.Index then data.FoundBrainrots=ctx.Index.Found[player] or {} end
  if ctx.Secret and ctx.Secret.Found[player] then data.Secrets={}; for key,value in pairs(ctx.Secret.Found[player])do if value then data.Secrets[tostring(key)]=true end end end
  local ok,err=pcall(function()store:UpdateAsync("u"..player.UserId,function(old) if type(old)=="table" then for key,value in pairs(data)do if value~=nil then old[key]=value end end; return old end; return data end)end)
  if not ok then warn("Data save failed for "..player.Name..": "..tostring(err))end
 end
 Players.PlayerAdded:Connect(load); for _,player in ipairs(Players:GetPlayers())do task.spawn(load,player)end
 Players.PlayerRemoving:Connect(save)
 task.spawn(function()while true do task.wait(60); for _,player in ipairs(Players:GetPlayers())do save(player)end end end)
 game:BindToClose(function()for _,player in ipairs(Players:GetPlayers())do save(player)end end)
end
function DataService.MarkSecret(player,index)
 local data=DataService.Data[player]; if not data then return end; data.Secrets=data.Secrets or {}; data.Secrets[tostring(index)]=true; local count=0; for _ in pairs(data.Secrets)do count+=1 end; player:SetAttribute("SecretsCount",count)
end
return DataService
