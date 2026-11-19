local MapBuilder={}
local function part(parent,name,size,pos,color,material)
 local p=Instance.new("Part"); p.Name=name; p.Size=size; p.Position=pos; p.Anchored=true; p.Color=color; p.Material=material or Enum.Material.SmoothPlastic; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth; p.Parent=parent; return p
end
local function sign(parent,text,pos,color)
 local p=part(parent,"Sign",Vector3.new(16,4,1),pos,color); local gui=Instance.new("SurfaceGui"); gui.Face=Enum.NormalId.Front; gui.Parent=p
 local t=Instance.new("TextLabel"); t.Size=UDim2.fromScale(1,1); t.BackgroundTransparency=1; t.Text=text; t.TextScaled=true; t.Font=Enum.Font.FredokaOne; t.TextColor3=Color3.new(1,1,1); t.Parent=gui; return p
end
local function tree(parent,x,z,scale)
 scale=scale or 1
 part(parent,"Tree Trunk",Vector3.new(2.5,8,2.5)*scale,Vector3.new(x,4*scale,z),Color3.fromRGB(133,78,42),Enum.Material.Wood)
 for n=1,3 do local crown=part(parent,"Leafy Crown",Vector3.new(8,8,8)*scale,Vector3.new(x+(n-2)*3*scale,8*scale,z),({Color3.fromRGB(74,205,82),Color3.fromRGB(54,184,75),Color3.fromRGB(110,220,65)})[n]); crown.Shape=Enum.PartType.Ball end
end
local function flowerBed(parent,x,z,color)
 part(parent,"Flower Bed Soil",Vector3.new(12,.35,5),Vector3.new(x,.22,z),Color3.fromRGB(106,71,49),Enum.Material.Ground)
 for i=1,5 do local f=part(parent,"Bright Flower",Vector3.new(1.2,.8,1.2),Vector3.new(x-5+i*2,.8,z),color,Enum.Material.Neon); f.Shape=Enum.PartType.Ball end
end
local function car(parent,x,z,bodyColor)
 local m=Instance.new("Model"); m.Name="Parked Car"; m.Parent=parent
 part(m,"Car Body",Vector3.new(13,3,7),Vector3.new(x,2,z),bodyColor,Enum.Material.SmoothPlastic)
 part(m,"Car Roof",Vector3.new(7,3,6),Vector3.new(x,5,z),bodyColor,Enum.Material.SmoothPlastic)
 part(m,"Windshield",Vector3.new(5,2,.2),Vector3.new(x,5,z-3.1),Color3.fromRGB(135,222,255),Enum.Material.Glass)
 for _,dx in ipairs({-4.5,4.5}) do local w=part(m,"Wheel",Vector3.new(2,2,1),Vector3.new(x+dx,1,z-3.3),Color3.fromRGB(35,36,42),Enum.Material.Rubber); w.Shape=Enum.PartType.Cylinder; w.Orientation=Vector3.new(0,90,0); local w2=part(m,"Wheel",Vector3.new(2,2,1),Vector3.new(x+dx,1,z+3.3),Color3.fromRGB(35,36,42),Enum.Material.Rubber); w2.Shape=Enum.PartType.Cylinder; w2.Orientation=Vector3.new(0,90,0) end
end
function MapBuilder.Build()
 local old=workspace:FindFirstChild("BrainrotMap"); if old then old:Destroy() end
 local map=Instance.new("Model"); map.Name="BrainrotMap"; map.Parent=workspace
 -- Split the lawn around a concealed laboratory hatch so the stairwell reaches the basement.
 part(map,"Neighborhood Lawn North",Vector3.new(420,2,380),Vector3.new(0,-1,-20),Color3.fromRGB(95,185,95),Enum.Material.Grass)
 part(map,"Neighborhood Lawn South West",Vector3.new(184,2,22),Vector3.new(-118,-1,199),Color3.fromRGB(95,185,95),Enum.Material.Grass)
 part(map,"Neighborhood Lawn South East",Vector3.new(224,2,22),Vector3.new(92,-1,199),Color3.fromRGB(95,185,95),Enum.Material.Grass)
 part(map,"Hatch Lawn West",Vector3.new(184,2,20),Vector3.new(-118,-1,178),Color3.fromRGB(95,185,95),Enum.Material.Grass)
 part(map,"Hatch Lawn East",Vector3.new(224,2,20),Vector3.new(92,-1,178),Color3.fromRGB(95,185,95),Enum.Material.Grass)
 part(map,"Main Street",Vector3.new(400,1,30),Vector3.new(0,0,0),Color3.fromRGB(55,57,65),Enum.Material.Asphalt)
 part(map,"Cross Street",Vector3.new(30,1,400),Vector3.new(0,0,0),Color3.fromRGB(55,57,65),Enum.Material.Asphalt)
 for i=-9,9 do part(map,"Lane Dash",Vector3.new(8,.12,.7),Vector3.new(i*20,.58,0),Color3.fromRGB(255,225,90),Enum.Material.Neon) end
 for _,z in ipairs({-15,15}) do for i=-5,5 do part(map,"Crosswalk Stripe",Vector3.new(1,.14,11),Vector3.new(i*2,.62,z),Color3.fromRGB(245,245,240)) end end
 for _,x in ipairs({-15,15}) do for i=-5,5 do part(map,"Crosswalk Stripe",Vector3.new(11,.14,1),Vector3.new(x,.62,i*2),Color3.fromRGB(245,245,240)) end end
 -- A narrow canal frames the east edge of town; the crossing leaves the radial
 -- plots and the existing street grid in their original positions.
 local canal=part(map,"East Canal",Vector3.new(24,.5,380),Vector3.new(225,-.1,0),Color3.fromRGB(55,177,226),Enum.Material.Glass); canal.Transparency=.18
 for _,x in ipairs({209,241}) do part(map,"Canal Bank",Vector3.new(4,1,380),Vector3.new(x,.25,0),Color3.fromRGB(192,184,157),Enum.Material.Rock) end
 local bridge=Instance.new("Model"); bridge.Name="East Canal Bridge"; bridge.Parent=map
 part(bridge,"Bridge Deck",Vector3.new(54,2,30),Vector3.new(225,1.1,0),Color3.fromRGB(142,100,65),Enum.Material.Wood)
 for _,x in ipairs({203,247}) do part(bridge,"Bridge Rail",Vector3.new(2,4,30),Vector3.new(x,4,0),Color3.fromRGB(239,217,167),Enum.Material.Wood) end
 for _,z in ipairs({-11,11}) do for x=207,243,12 do part(bridge,"Bridge Post",Vector3.new(2,5,2),Vector3.new(x,4,z),Color3.fromRGB(106,73,53),Enum.Material.Wood) end end
 -- Broad green rises define the outer districts without covering the plots.
 for _,spec in ipairs({{Vector3.new(-205,13,-185),Vector3.new(80,28,70)},{Vector3.new(-205,10,185),Vector3.new(75,22,64)},{Vector3.new(175,12,190),Vector3.new(76,25,70)}}) do local hill=part(map,"Rolling Hill",spec[2],spec[1],Color3.fromRGB(105,180,91),Enum.Material.Grass); hill.Shape=Enum.PartType.Ball end
 for _,z in ipairs({-20,20}) do part(map,"Sidewalk",Vector3.new(400,1,5),Vector3.new(0,.1,z),Color3.fromRGB(205,199,177),Enum.Material.Concrete) end
 -- Neighborhood connectors tie the house rows and community buildings into the central streets.
 for _,z in ipairs({-125,-55,55,125}) do
  part(map,"Neighborhood Road",Vector3.new(400,.8,18),Vector3.new(0,.05,z),Color3.fromRGB(54,57,64),Enum.Material.Asphalt)
  for x=-190,190,24 do part(map,"Road Dash",Vector3.new(10,.12,.65),Vector3.new(x,.52,z),Color3.fromRGB(255,213,74),Enum.Material.Neon) end
  for _,side in ipairs({-1,1}) do part(map,"Neighborhood Sidewalk",Vector3.new(400,.7,4),Vector3.new(0,.2,z+side*11),Color3.fromRGB(218,209,187),Enum.Material.Concrete) end
 end
 for _,x in ipairs({-205,-65,65,205}) do
  part(map,"Neighborhood Road",Vector3.new(18,.8,400),Vector3.new(x,.05,0),Color3.fromRGB(54,57,64),Enum.Material.Asphalt)
  for z=-190,190,24 do part(map,"Road Dash",Vector3.new(.65,.12,10),Vector3.new(x,.52,z),Color3.fromRGB(255,213,74),Enum.Material.Neon) end
  for _,side in ipairs({-1,1}) do part(map,"Neighborhood Sidewalk",Vector3.new(4,.7,400),Vector3.new(x+side*11,.2,0),Color3.fromRGB(218,209,187),Enum.Material.Concrete) end
 end
 for _,z in ipairs({-125,-55,55,125}) do for _,x in ipairs({-205,-65,65,205}) do for n=-3,3 do part(map,"Neighborhood Crosswalk Stripe",Vector3.new(1,.13,12),Vector3.new(x+n*2,.52,z),Color3.fromRGB(248,247,230),Enum.Material.Concrete) end end end
 for x=-180,180,60 do for _,z in ipairs({-27,27}) do part(map,"Streetlight Pole",Vector3.new(1,12,1),Vector3.new(x,6,z),Color3.fromRGB(54,60,72),Enum.Material.Metal); part(map,"Streetlight Arm",Vector3.new(5,.6,.6),Vector3.new(x+2.5,11,z),Color3.fromRGB(54,60,72),Enum.Material.Metal); local bulb=part(map,"Streetlight",Vector3.new(2,1,2),Vector3.new(x+4.5,10.8,z),Color3.fromRGB(255,245,175),Enum.Material.Neon); local light=Instance.new("PointLight"); light.Color=bulb.Color; light.Range=18; light.Brightness=.5; light.Parent=bulb end end
 -- Bright houses with doors, windows, roof and visible street frontage.
 local colors={Color3.fromRGB(255,119,102),Color3.fromRGB(255,205,72),Color3.fromRGB(96,190,255),Color3.fromRGB(203,126,255),Color3.fromRGB(255,145,203),Color3.fromRGB(119,225,154)}
 for i=1,6 do local x=-145+(i-1)*58; local z=(i%2==0) and -82 or 82; local m=Instance.new("Model"); m.Name="House "..i; m.Parent=map
  part(m,"House",Vector3.new(38,20,30),Vector3.new(x,10,z),colors[i]); part(m,"Roof",Vector3.new(42,3,34),Vector3.new(x,21.5,z),Color3.fromRGB(95,53,84),Enum.Material.Slate)
  local roofA=Instance.new("WedgePart"); roofA.Name="Slanted Roof Face"; roofA.Size=Vector3.new(21,5,32); roofA.Position=Vector3.new(x-10.5,24,z); roofA.Color=Color3.fromRGB(112,63,92); roofA.Material=Enum.Material.Slate; roofA.Anchored=true; roofA.Parent=m
  local roofB=Instance.new("WedgePart"); roofB.Name="Slanted Roof Face"; roofB.Size=Vector3.new(21,5,32); roofB.Position=Vector3.new(x+10.5,24,z); roofB.Orientation=Vector3.new(0,180,0); roofB.Color=Color3.fromRGB(112,63,92); roofB.Material=Enum.Material.Slate; roofB.Anchored=true; roofB.Parent=m
  part(m,"Roof Eave",Vector3.new(44,1,36),Vector3.new(x,21,z),Color3.fromRGB(255,211,104),Enum.Material.Wood)
  part(m,"Door",Vector3.new(5,10,.6),Vector3.new(x,5,z-15.4),({Color3.fromRGB(112,63,43),Color3.fromRGB(45,104,170),Color3.fromRGB(170,63,90)})[(i-1)%3+1],Enum.Material.Wood)
  part(m,"Porch Floor",Vector3.new(16,1,7),Vector3.new(x,1,z-19),Color3.fromRGB(245,220,166),Enum.Material.Wood)
  for _,dx in ipairs({-7,7}) do part(m,"Porch Post",Vector3.new(.8,6,.8),Vector3.new(x+dx,4,z-21),Color3.fromRGB(255,245,222),Enum.Material.Wood) end
  for wi,dx in ipairs({-11,11}) do local lit=((i+wi)%2==0); local win=part(m,"Window",Vector3.new(7,7,.6),Vector3.new(x+dx,12,z-15.5),lit and Color3.fromRGB(255,226,112) or Color3.fromRGB(115,218,255),Enum.Material.Glass); if lit then local glow=Instance.new("PointLight"); glow.Color=Color3.fromRGB(255,207,105); glow.Range=10; glow.Brightness=.35; glow.Parent=win end; part(m,"Window Sill",Vector3.new(8,1,1),Vector3.new(x+dx,8.5,z-15.7),Color3.fromRGB(255,245,222),Enum.Material.Wood) end
  part(m,"Chimney",Vector3.new(4,11,4),Vector3.new(x+13,26,z+7),Color3.fromRGB(225,97,73),Enum.Material.Brick)
  for _,dx in ipairs({-19,19}) do part(m,"Picket Fence",Vector3.new(1,4,1),Vector3.new(x+dx,2,z+20),Color3.fromRGB(255,247,221),Enum.Material.Wood) end
  part(m,"Fence Rail",Vector3.new(38,1,1),Vector3.new(x,2.5,z+20),Color3.fromRGB(255,247,221),Enum.Material.Wood)
  part(m,"Mailbox",Vector3.new(3,2,2),Vector3.new(x+23,2,z-12),Color3.fromRGB(255,91,104),Enum.Material.Metal)
 end
 local school=Instance.new("Model"); school.Name="Mayhem Elementary"; school.Parent=map
 part(school,"School",Vector3.new(68,26,42),Vector3.new(-95,13,145),Color3.fromRGB(255,223,112)); part(school,"Roof",Vector3.new(72,3,45),Vector3.new(-95,27,145),Color3.fromRGB(224,75,80)); sign(school,"MAYHEM ELEMENTARY",Vector3.new(-95,19,123),Color3.fromRGB(224,65,65))
 part(school,"Flag Pole",Vector3.new(1,22,1),Vector3.new(-58,11,145),Color3.fromRGB(220,220,220)); part(school,"Flag",Vector3.new(8,4,.4),Vector3.new(-53,19,145),Color3.fromRGB(50,120,255))
 part(school,"Swing Frame Left",Vector3.new(1,12,1),Vector3.new(-115,6,112),Color3.fromRGB(75,75,85),Enum.Material.Metal); part(school,"Swing Frame Right",Vector3.new(1,12,1),Vector3.new(-75,6,112),Color3.fromRGB(75,75,85),Enum.Material.Metal); part(school,"Swing Beam",Vector3.new(42,1,1),Vector3.new(-95,12,112),Color3.fromRGB(75,75,85),Enum.Material.Metal)
 for _,x in ipairs({-105,-85}) do part(school,"Swing Chain",Vector3.new(.2,7,.2),Vector3.new(x,8,112),Color3.fromRGB(180,180,190),Enum.Material.Metal); part(school,"Swing Seat",Vector3.new(5,.5,2),Vector3.new(x,4.2,112),Color3.fromRGB(255,90,90)) end
 part(school,"Slide Ladder",Vector3.new(4,7,4),Vector3.new(-55,3.5,112),Color3.fromRGB(70,125,240),Enum.Material.Metal); local slide=part(school,"Slide",Vector3.new(5,1,14),Vector3.new(-55,2,103),Color3.fromRGB(255,115,60),Enum.Material.Metal); slide.Orientation=Vector3.new(25,0,0)
 local shop=Instance.new("Model"); shop.Name="Meme Mart"; shop.Parent=map; part(shop,"Store",Vector3.new(42,20,32),Vector3.new(95,10,-100),Color3.fromRGB(75,205,193)); part(shop,"Roof",Vector3.new(46,3,36),Vector3.new(95,21,-100),Color3.fromRGB(255,111,65)); sign(shop,"MEME MART",Vector3.new(95,17,-117),Color3.fromRGB(45,90,170)); part(shop,"Counter",Vector3.new(24,4,3),Vector3.new(95,3,-91),Color3.fromRGB(120,75,46)); part(shop,"Shop Awning",Vector3.new(34,1,10),Vector3.new(95,15,-120),Color3.fromRGB(255,203,67),Enum.Material.Fabric); for _,x in ipairs({80,110}) do part(shop,"Awning Support",Vector3.new(1,8,1),Vector3.new(x,11,-117),Color3.fromRGB(133,79,45),Enum.Material.Wood) end
 local gas=Instance.new("Model"); gas.Name="Gas Station"; gas.Parent=map; part(gas,"Shop",Vector3.new(28,14,24),Vector3.new(155,7,110),Color3.fromRGB(241,242,228)); part(gas,"Canopy",Vector3.new(42,2,25),Vector3.new(155,18,105),Color3.fromRGB(255,79,79)); sign(gas,"GAS",Vector3.new(155,16,92),Color3.fromRGB(220,50,50))
 for i=1,3 do part(gas,"Pump",Vector3.new(5,7,4),Vector3.new(140+i*12,4,108),Color3.fromRGB(60,95,180)) end
 local park=Instance.new("Model"); park.Name="Pigeon Park"; park.Parent=map; part(park,"Park Circle",Vector3.new(88,.4,88),Vector3.new(-145,.3,-140),Color3.fromRGB(102,210,130),Enum.Material.Grass)
 for i=1,7 do local x=-175+(i%3)*25; local z=-170+math.floor(i/3)*24; tree(park,x,z,1.15) end
 part(park,"Pond",Vector3.new(34,.5,20),Vector3.new(-145,.4,-140),Color3.fromRGB(49,175,226),Enum.Material.Glass)
 for i=1,3 do part(park,"Bench",Vector3.new(12,2,3),Vector3.new(-180+i*25,2,-105),Color3.fromRGB(112,67,43)) end
 -- Colorful playground and planted edges make the park readable from the road.
 part(park,"Playground Mat",Vector3.new(30,.5,24),Vector3.new(-145,.65,-147),Color3.fromRGB(255,202,82),Enum.Material.Sand)
 for _,x in ipairs({-157,-133}) do part(park,"Swing Upright",Vector3.new(1,11,1),Vector3.new(x,6,-155),Color3.fromRGB(70,125,240),Enum.Material.Metal) end
 part(park,"Swing Bar",Vector3.new(25,1,1),Vector3.new(-145,11,-155),Color3.fromRGB(255,89,112),Enum.Material.Metal)
 for _,x in ipairs({-151,-139}) do part(park,"Swing Chain",Vector3.new(.2,6,.2),Vector3.new(x,7,-155),Color3.fromRGB(210,220,235),Enum.Material.Metal); part(park,"Swing Seat",Vector3.new(4,.5,2),Vector3.new(x,4,-155),Color3.fromRGB(255,95,120)) end
 part(park,"Slide Platform",Vector3.new(6,5,6),Vector3.new(-145,3,-137),Color3.fromRGB(75,135,245),Enum.Material.Metal)
 local parkSlide=part(park,"Rainbow Slide",Vector3.new(6,1,13),Vector3.new(-145,1.2,-127),Color3.fromRGB(255,113,62),Enum.Material.Metal); parkSlide.Orientation=Vector3.new(22,0,0)
 part(park,"Sandpit",Vector3.new(25,.5,16),Vector3.new(-145,.65,-117),Color3.fromRGB(255,218,142),Enum.Material.Sand)
 for _,x in ipairs({-188,-105}) do flowerBed(park,x,-140,Color3.fromRGB(255,84,164)) end
 part(map,"Hill",Vector3.new(90,35,110),Vector3.new(175,15,-165),Color3.fromRGB(96,174,84),Enum.Material.Grass)
 local lab=Instance.new("Model"); lab.Name="Meme Laboratory"; lab.Parent=map; part(lab,"Lab",Vector3.new(56,22,36),Vector3.new(-20,11,155),Color3.fromRGB(85,93,138)); sign(lab,"MEME LAB",Vector3.new(-20,17,136),Color3.fromRGB(160,65,255))
 -- Plaza, neighborhood greenery, and street furniture add color between landmarks.
 part(map,"Central Plaza",Vector3.new(42,.45,42),Vector3.new(0,.35,0),Color3.fromRGB(255,190,84),Enum.Material.Concrete)
 part(map,"Plaza Mosaic",Vector3.new(20,.15,20),Vector3.new(0,.68,0),Color3.fromRGB(88,205,224),Enum.Material.Neon)
 local pergola=Instance.new("Model"); pergola.Name="Spawn Plaza Pergola"; pergola.Parent=map
 for _,x in ipairs({-17,17}) do for _,z in ipairs({-17,17}) do part(pergola,"Pergola Post",Vector3.new(2,16,2),Vector3.new(x,8,z),Color3.fromRGB(128,76,48),Enum.Material.Wood) end end
 for _,z in ipairs({-17,17}) do part(pergola,"Pergola Beam",Vector3.new(36,2,2),Vector3.new(0,16,z),Color3.fromRGB(168,107,62),Enum.Material.Wood) end
 for _,x in ipairs({-17,17}) do part(pergola,"Pergola Beam",Vector3.new(2,2,36),Vector3.new(x,16,0),Color3.fromRGB(168,107,62),Enum.Material.Wood) end
 for x=-12,12,8 do part(pergola,"Pergola Canopy Slat",Vector3.new(2,1,36),Vector3.new(x,16.5,0),Color3.fromRGB(220,165,85),Enum.Material.Wood) end
 local titleSign=Instance.new("Model"); titleSign.Name="BRAINROT MAYHEM Plaza Sign"; titleSign.Parent=map
 part(titleSign,"Sign Foot",Vector3.new(22,1,3),Vector3.new(0,1,-48),Color3.fromRGB(34,25,58),Enum.Material.Metal)
 for _,x in ipairs({-9,9}) do part(titleSign,"Sign Post",Vector3.new(1,13,1),Vector3.new(x,7,-48),Color3.fromRGB(255,220,75),Enum.Material.Metal) end
 local titleBoard=part(titleSign,"BRAINROT MAYHEM",Vector3.new(22,7,1.2),Vector3.new(0,14,-48),Color3.fromRGB(255,55,135),Enum.Material.Neon)
 local titleGui=Instance.new("SurfaceGui"); titleGui.Name="TitleSurface"; titleGui.Face=Enum.NormalId.Front; titleGui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud; titleGui.PixelsPerStud=45; titleGui.Parent=titleBoard
 local titleText=Instance.new("TextLabel"); titleText.Size=UDim2.fromScale(1,1); titleText.BackgroundTransparency=1; titleText.Text="BRAINROT\nMAYHEM"; titleText.TextColor3=Color3.fromRGB(255,239,99); titleText.TextStrokeColor3=Color3.fromRGB(91,24,143); titleText.TextStrokeTransparency=.15; titleText.TextScaled=true; titleText.Font=Enum.Font.FredokaOne; titleText.Parent=titleGui
 -- Small market lane sits beside the plaza and makes the spawn district read as a lived-in street.
 for i,x in ipairs({-16,16}) do local stall=Instance.new("Model"); stall.Name="Brainrot Market Stall"; stall.Parent=map; local z=31
  part(stall,"Stall Counter",Vector3.new(12,3,6),Vector3.new(x,1.8,z),i==1 and Color3.fromRGB(255,104,104) or Color3.fromRGB(75,180,255),Enum.Material.Wood)
  part(stall,"Striped Awning",Vector3.new(14,1,8),Vector3.new(x,5,z),i==1 and Color3.fromRGB(255,225,85) or Color3.fromRGB(255,120,190),Enum.Material.Fabric)
  for _,dx in ipairs({-6,6}) do part(stall,"Awning Post",Vector3.new(.6,6,.6),Vector3.new(x+dx,3,z+3),Color3.fromRGB(112,68,43),Enum.Material.Wood) end
 end
 for i,pos in ipairs({Vector3.new(-29,1.2,31),Vector3.new(29,1.2,31),Vector3.new(-34,1.2,-28),Vector3.new(34,1.2,-28)}) do local crate=part(map,"Stacked Market Crate",Vector3.new(4,3,4),pos,({Color3.fromRGB(150,95,55),Color3.fromRGB(182,125,65)})[(i-1)%2+1],Enum.Material.Wood); crate.Orientation=Vector3.new(0,i*13,0) end
 local fountain=Instance.new("Model"); fountain.Name="Pigeon Plaza Fountain"; fountain.Parent=map; local basin=part(fountain,"Stone Basin",Vector3.new(13,2,13),Vector3.new(0,1.5,-32),Color3.fromRGB(215,220,230),Enum.Material.Marble); basin.Shape=Enum.PartType.Cylinder
 local water=part(fountain,"Fountain Water",Vector3.new(10,.6,10),Vector3.new(0,2.6,-32),Color3.fromRGB(65,205,255),Enum.Material.Glass); water.Shape=Enum.PartType.Cylinder
 part(fountain,"Pigeon Statue",Vector3.new(2,6,2),Vector3.new(0,5.5,-32),Color3.fromRGB(255,211,85),Enum.Material.Metal)
 for _,pos in ipairs({Vector3.new(-45,0,-45),Vector3.new(45,0,-45),Vector3.new(-45,0,45),Vector3.new(45,0,45),Vector3.new(-150,0,35),Vector3.new(150,0,-35),Vector3.new(35,0,150),Vector3.new(-35,0,-150)}) do tree(map,pos.X,pos.Z,.8); flowerBed(map,pos.X+10,pos.Z,Color3.fromRGB(255,94,174)) end
 for _,pos in ipairs({Vector3.new(-30,0,-70),Vector3.new(30,0,-70),Vector3.new(-30,0,70),Vector3.new(30,0,70),Vector3.new(-170,0,35),Vector3.new(170,0,-35)}) do local bush=part(map,"Bright Bush",Vector3.new(9,5,7),pos+Vector3.new(0,2.5,0),Color3.fromRGB(74,190,77),Enum.Material.Grass); bush.Shape=Enum.PartType.Ball end
 for _,pos in ipairs({Vector3.new(-28,0,-28),Vector3.new(28,0,-28),Vector3.new(-28,0,28),Vector3.new(28,0,28)}) do part(map,"Street Lamp",Vector3.new(1,10,1),pos+Vector3.new(0,5,0),Color3.fromRGB(48,57,72),Enum.Material.Metal); local lamp=part(map,"Lamp Glow",Vector3.new(3,1,3),pos+Vector3.new(0,10,0),Color3.fromRGB(255,237,147),Enum.Material.Neon); local l=Instance.new("PointLight"); l.Color=lamp.Color; l.Range=20; l.Brightness=.7; l.Parent=lamp end
 for i=1,4 do local hydrant=part(map,"Fire Hydrant",Vector3.new(2,3,2),Vector3.new(-32+i*18,1.5,28),Color3.fromRGB(255,61,54),Enum.Material.Metal); hydrant.Shape=Enum.PartType.Cylinder end
 car(map,-82,-28,Color3.fromRGB(255,87,103)); car(map,82,28,Color3.fromRGB(66,177,255))
 -- A narrow stairwell under a disguised wall leads to the hidden laboratory chamber.
 for step=1,9 do part(lab,"Basement Stair",Vector3.new(9,1,3),Vector3.new(-20,1-step,176+step*2),Color3.fromRGB(76,78,93),Enum.Material.Metal) end
 part(lab,"False Wall",Vector3.new(10,12,1),Vector3.new(-20,-5,197),Color3.fromRGB(85,93,138)).CanCollide=false
 part(lab,"Secret Room Floor",Vector3.new(24,1,20),Vector3.new(-20,-9.5,208),Color3.fromRGB(67,58,90))
 part(lab,"Secret Room Ceiling",Vector3.new(24,1,20),Vector3.new(-20,2,208),Color3.fromRGB(64,57,85))
 for _,x in ipairs({-32, -8}) do part(lab,"Secret Room Wall",Vector3.new(1,12,20),Vector3.new(x,-3.5,208),Color3.fromRGB(66,59,90)) end
 for _,z in ipairs({198,218}) do part(lab,"Secret Room Wall",Vector3.new(24,12,1),Vector3.new(-20,-3.5,z),Color3.fromRGB(66,59,90)) end
 for i=1,3 do local tank=part(lab,"Glowing Tank",Vector3.new(7,12,7),Vector3.new(-38+i*18,8,132),Color3.fromRGB(0,255,215),Enum.Material.Neon); tank.Transparency=.25 end
 local button=part(lab,"BIG RED BUTTON",Vector3.new(6,2,6),Vector3.new(-20,2,127),Color3.fromRGB(255,35,35),Enum.Material.Neon); button:SetAttribute("Secret",true)
 local sewer=Instance.new("Model"); sewer.Name="Sewer Entrance"; sewer.Parent=map; part(sewer,"Entrance",Vector3.new(24,2,12),Vector3.new(130,1,160),Color3.fromRGB(60,60,65)); part(sewer,"Tunnel Floor",Vector3.new(42,2,36),Vector3.new(130,-9,190),Color3.fromRGB(70,75,84)); part(sewer,"Tunnel Back",Vector3.new(42,18,2),Vector3.new(130,0,208),Color3.fromRGB(50,50,57))
 -- rooftop stair access on shop and gas station.
 for i=1,8 do part(map,"Shop Stair",Vector3.new(5,1,3),Vector3.new(70+i*3,i*2,-83),Color3.fromRGB(95,95,100)); part(map,"Gas Stair",Vector3.new(5,1,3),Vector3.new(176,i*2,124+i*3),Color3.fromRGB(95,95,100)) end
 -- Eight player plots, each with eight visible slots.
 local plots=Instance.new("Folder"); plots.Name="Plots"; plots.Parent=map
 for i=1,8 do local angle=(i-1)*math.pi/4; local center=Vector3.new(math.cos(angle)*135,0,math.sin(angle)*135); local m=Instance.new("Model"); m.Name="Plot"..i; m:SetAttribute("PlotIndex",i); m.Parent=plots
  local plotColors={Color3.fromRGB(92,211,255),Color3.fromRGB(255,128,169),Color3.fromRGB(255,211,81),Color3.fromRGB(141,237,132),Color3.fromRGB(180,133,255),Color3.fromRGB(255,151,91),Color3.fromRGB(89,230,198),Color3.fromRGB(255,112,104)}
  part(m,"Plot Floor",Vector3.new(48,1,48),center+Vector3.new(0,.1,0),plotColors[i]); for _,edge in ipairs({Vector3.new(0,2,-24),Vector3.new(0,2,24),Vector3.new(-24,2,0),Vector3.new(24,2,0)}) do part(m,"Bright Plot Border",Vector3.new(edge.X==0 and 48 or 1,4,edge.Z==0 and 48 or 1),center+edge,Color3.fromRGB(255,246,125),Enum.Material.Neon) end
  part(m,"Plot Banner Pole",Vector3.new(.7,11,.7),center+Vector3.new(19,5.5,-19),Color3.fromRGB(255,240,200),Enum.Material.Metal); part(m,"Plot Banner",Vector3.new(7,4,.5),center+Vector3.new(16,9,-19),Color3.fromRGB(255,88,146),Enum.Material.Neon)
  local lamp=part(m,"Plot Street Lamp",Vector3.new(1,10,1),center+Vector3.new(-29,5,0),Color3.fromRGB(48,57,72),Enum.Material.Metal); local glow=part(m,"Plot Lamp Glow",Vector3.new(2,1,2),center+Vector3.new(-29,10,0),Color3.fromRGB(255,237,147),Enum.Material.Neon); local light=Instance.new("PointLight"); light.Color=glow.Color; light.Range=15; light.Brightness=.45; light.Parent=glow
  part(m,"Plot Sidewalk Bench",Vector3.new(10,1.5,3),center+Vector3.new(0,1.2,29),Color3.fromRGB(130,78,48),Enum.Material.Wood)
  for _,dx in ipairs({-3.5,3.5}) do part(m,"Bench Leg",Vector3.new(.7,2,.7),center+Vector3.new(dx,.8,29),Color3.fromRGB(72,75,84),Enum.Material.Metal) end
  local slots=Instance.new("Folder"); slots.Name="Slots"; slots.Parent=m
  for s=1,8 do local xx=((s-1)%4-1.5)*10; local zz=(math.floor((s-1)/4)-.5)*15; local pad=part(slots,"Slot"..s,Vector3.new(.35,8.6,8.6),center+Vector3.new(xx,.8,zz),Color3.fromRGB(255,222,90),Enum.Material.Neon); pad.Shape=Enum.PartType.Cylinder; pad.Orientation=Vector3.new(0,0,90); pad:SetAttribute("Slot",s); local inset=part(slots,"Slot Inset"..s,Vector3.new(.4,7.4,7.4),center+Vector3.new(xx,1.02,zz),Color3.fromRGB(66,50,92),Enum.Material.SmoothPlastic); inset.Shape=Enum.PartType.Cylinder; inset.Orientation=Vector3.new(0,0,90); inset:SetAttribute("Slot",s) end
  local spawn=part(m,"Owner Spawn",Vector3.new(4,1,4),center+Vector3.new(0,1,0),Color3.fromRGB(255,255,255)); spawn.Transparency=1; spawn.CanCollide=false
 end
 -- Five touchable secret buttons have unique coordinates and can only be claimed once per player.
 local secretPositions={Vector3.new(-145,4,66),Vector3.new(-145,4,-140),Vector3.new(130,3,160),Vector3.new(95,24,-100),Vector3.new(-20,4,127)}
 for i,pos in ipairs(secretPositions) do local b=part(map,"Secret Button "..i,Vector3.new(2,1,2),pos,Color3.fromRGB(255,50,190),Enum.Material.Neon); b:SetAttribute("SecretIndex",i) end
 return map
end
return MapBuilder
