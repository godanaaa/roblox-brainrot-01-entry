local CoinService={}
local Players=game:GetService("Players")
local function safeAmount(amount)
 return type(amount)=="number" and amount==amount and amount~=math.huge and amount~=-math.huge and math.floor(amount) or nil
end
function CoinService.Init(ctx)
 CoinService.Context=ctx; CoinService.Balances={}; CoinService.Lifetime={}
end
function CoinService.Set(player,value)
 if not player or not player.Parent then return end
 local amount=safeAmount(value); if not amount then return end
 amount=math.max(0,amount); CoinService.Balances[player]=amount; player:SetAttribute("Coins",amount)
 local stats=player:FindFirstChild("leaderstats"); local coins=stats and stats:FindFirstChild("Meme Coins"); if coins then coins.Value=amount end
 if CoinService.Context and CoinService.Context.Snapshot then CoinService.Context.Remotes.State:FireClient(player,CoinService.Context.Snapshot(player)) end
end
function CoinService.Load(player,balance,lifetime)
 CoinService.Lifetime[player]=math.max(0,safeAmount(lifetime) or 0); CoinService.Set(player,balance or 0)
end
function CoinService.Get(player) return CoinService.Balances[player] or 0 end
function CoinService.GetLifetime(player) return CoinService.Lifetime[player] or 0 end
function CoinService.Add(player,amount,reason)
 local value=safeAmount(amount); if not player or not player.Parent or not value or value==0 then return false end
 local before=CoinService.Get(player); CoinService.Set(player,before+value)
 if value>0 then CoinService.Lifetime[player]=(CoinService.Lifetime[player] or 0)+value end
 if reason and CoinService.Context then CoinService.Context.Announce.To(player,(value>0 and "+" or "")..value.." Meme Coins • "..reason) end
 return true
end
function CoinService.Spend(player,amount)
 local value=safeAmount(amount); if not player or not player.Parent or not value or value<0 or CoinService.Get(player)<value then return false end
 CoinService.Set(player,CoinService.Get(player)-value); return true
end
function CoinService.Cleanup(player) CoinService.Balances[player]=nil; CoinService.Lifetime[player]=nil end
return CoinService
