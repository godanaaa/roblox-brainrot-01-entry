local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Modules=ReplicatedStorage:WaitForChild("Modules")
local Remotes=require(Modules.Remotes)
local services=script:WaitForChild("Services")
local function requireService(name) return require(services:WaitForChild(name)) end
local MapBuilder=requireService("MapBuilder")
MapBuilder.Build()
local brainrots=Instance.new("Folder"); brainrots.Name="Brainrots"; brainrots.Parent=workspace
local ctx={Remotes=Remotes}
function ctx.Snapshot(player)
 local owned=ctx.Base and ctx.Base.GetOwned(player) or {}
 local incomeRate=ctx.Base and ctx.Base.GetIncomeRate(player) or 0
 return {Coins=ctx.Coin and ctx.Coin.Get(player) or 0,PlotIndex=player:GetAttribute("PlotIndex"),Owned=owned,Playing=player:GetAttribute("Playing") or false,Chaos=ctx.Chaos and ctx.Chaos.Meter or 0,Event=ctx.Chaos and ctx.Chaos.Current or "Waiting for chaos",Players=#game:GetService("Players"):GetPlayers(),EventsSurvived=player:GetAttribute("EventsSurvived") or 0,Wins=player:GetAttribute("Wins") or 0,IncomeRate=incomeRate,FoundBrainrots=ctx.Index and ctx.Index.Found[player] or {},IndexFound=ctx.Index and ctx.Index.GetFoundCount(player) or 0,IndexTotal=ctx.Index and ctx.Index.GetFoundTotal() or #require(Modules.Config).Brainrots,Daily=ctx.Daily and ctx.Daily.Challenges or {},Progress=ctx.Daily and ctx.Daily.GetProgress(player) or {},Secrets=player:GetAttribute("SecretsCount") or 0,Shop=require(Modules.Config).Shop,Pets=require(Modules.Config).Pets,OwnedPets=ctx.Pet and ctx.Pet.Owned[player] or {},Transformations=require(Modules.Config).Transformations,OwnedCosmetics=ctx.Shop and ctx.Shop.GetOwned(player) or {},Rebirths=player:GetAttribute("Rebirths") or 0,RebirthMultiplier=ctx.Rebirth and ctx.Rebirth.GetIncomeMultiplier(player) or 1,RebirthCost=ctx.Rebirth and ctx.Rebirth.GetRebirthCost(player),Upgrades=ctx.Upgrade and ctx.Upgrade.GetUpgrades(player) or {},LockSeconds=ctx.Base and ctx.Base.GetLockSeconds(player) or 0}
end
ctx.Coin=requireService("CoinService"); ctx.Coin.Init(ctx)
ctx.Announce=requireService("AnnounceService"); ctx.Announce.Init(ctx)
ctx.Data=requireService("DataService"); ctx.Data.Init(ctx)
ctx.Index=requireService("IndexService"); ctx.Index.Init(ctx)
ctx.Rebirth=requireService("RebirthService"); ctx.Rebirth.Init(ctx)
ctx.Base=requireService("BaseService"); ctx.Base.Init(ctx)
ctx.Upgrade=requireService("UpgradeService"); ctx.Upgrade.Init(ctx)
ctx.Transform=requireService("TransformService"); ctx.Transform.Init(ctx)
ctx.Pet=requireService("PetService"); ctx.Pet.Init(ctx)
ctx.Shop=requireService("ShopService"); ctx.Shop.Init(ctx)
ctx.Brainrot=requireService("BrainrotService"); ctx.Brainrot.Init(ctx)
ctx.Steal=requireService("StealService"); ctx.Steal.Init(ctx)
ctx.Daily=requireService("DailyService"); ctx.Daily.Init(ctx)
ctx.Minigame=requireService("MiniGameService"); ctx.Minigame.Init(ctx)
ctx.Secret=requireService("SecretService"); ctx.Secret.Init(ctx)
ctx.Chaos=requireService("ChaosService"); ctx.Chaos.Init(ctx)
ctx.Game=requireService("GameService"); ctx.Game.Init(ctx)
