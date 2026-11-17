local Announce={}
Announce.Lines={"BRO WHAT ARE YOU DOING 💀","WHO GAVE HIM ADMIN???","THE CHICKENS HAVE ARRIVED.","THIS WAS A TERRIBLE IDEA.","SOMEONE STOP THE POTATO.","WHY IS THE FLOOR MOVING?","ABSOLUTELY NOTHING IS UNDER CONTROL.","🚨 BRAINROT LEVEL CRITICAL 🚨","🚨 THE BRAINROT HAS ESCAPED 🚨"}
function Announce.Init(ctx) Announce.Context=ctx end
function Announce.All(line) Announce.Context.Remotes.Announcement:FireAllClients(line or Announce.Lines[math.random(1,#Announce.Lines)]) end
function Announce.To(player,line) Announce.Context.Remotes.Announcement:FireClient(player,line) end
return Announce
