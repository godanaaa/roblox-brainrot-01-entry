local Announce={}
Announce.Lines={"BRO WHAT ARE YOU DOING 💀","WHO GAVE HIM ADMIN???","THE CHICKENS HAVE ARRIVED.","THIS WAS A TERRIBLE IDEA.","SOMEONE STOP THE POTATO.","WHY IS THE FLOOR MOVING?","ABSOLUTELY NOTHING IS UNDER CONTROL.","🚨 BRAINROT LEVEL CRITICAL 🚨","🚨 THE BRAINROT HAS ESCAPED 🚨"}
function Announce.Init(ctx)
 Announce.Context=ctx; Announce.Queue={}; Announce.Busy=false
end
local function enqueue(target,line)
 local ctx=Announce.Context; if not ctx then return end
 table.insert(Announce.Queue,{Target=target,Text=type(line)=="string" and line~="" and line or Announce.Lines[math.random(1,#Announce.Lines)]})
 if Announce.Busy then return end
 Announce.Busy=true
 task.spawn(function()
  while #Announce.Queue>0 do local entry=table.remove(Announce.Queue,1)
   if entry.Target and entry.Target.Parent then ctx.Remotes.Announcement:FireClient(entry.Target,entry.Text) elseif not entry.Target then ctx.Remotes.Announcement:FireAllClients(entry.Text) end
   task.wait(.12)
  end
  Announce.Busy=false
 end)
end
function Announce.All(line) enqueue(nil,line) end
function Announce.To(player,line) enqueue(player,line) end
return Announce
