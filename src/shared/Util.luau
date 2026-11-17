local Util = {}
function Util.Clamp(n,low,high) return math.max(low,math.min(high,n)) end
function Util.FormatCoins(n) if n>=1000000 then return string.format("%.1fm",n/1000000) elseif n>=1000 then return string.format("%.1fk",n/1000) end return tostring(math.floor(n)) end
function Util.WeightedPick(items,weightOf)
 local total=0; for _,item in ipairs(items) do total+=weightOf(item) end
 if total<=0 then return items[1] end
 local roll=math.random()*total
 for _,item in ipairs(items) do roll-=weightOf(item); if roll<=0 then return item end end
 return items[#items]
end
return Util
