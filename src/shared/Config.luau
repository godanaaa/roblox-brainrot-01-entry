local Config = {}
Config.Rarities = {COMMON={Color=Color3.fromRGB(190,205,220),Weight=42,Chaos=5},UNCOMMON={Color=Color3.fromRGB(70,220,120),Weight=27,Chaos=0},RARE={Color=Color3.fromRGB(75,150,255),Weight=17,Chaos=10},EPIC={Color=Color3.fromRGB(190,80,255),Weight=10,Chaos=20},LEGENDARY={Color=Color3.fromRGB(255,190,35),Weight=4,Chaos=35},MYTHIC={Color=Color3.fromRGB(255,55,165),Weight=2,Chaos=50}}
Config.Brainrots = {
 {Name="Sir Pigeonsworth",Rarity="COMMON",Rate=5,Kind="Pigeon"},{Name="Toaster Steve",Rarity="COMMON",Rate=8,Kind="Toaster"},
 {Name="Captain Couch",Rarity="UNCOMMON",Rate=15,Kind="Couch"},{Name="DJ Microwave",Rarity="UNCOMMON",Rate=20,Kind="Microwave"},{Name="Professor Pickle",Rarity="UNCOMMON",Rate=25,Kind="Pickle"},
 {Name="Baron von Banana",Rarity="RARE",Rate=45,Kind="Banana"},{Name="Madame Lampshade",Rarity="RARE",Rate=60,Kind="Lamp"},{Name="General Sock",Rarity="RARE",Rate=75,Kind="Sock"},
 {Name="The Fridge King",Rarity="EPIC",Rate=120,Kind="Fridge"},{Name="Countess Washing Machine",Rarity="EPIC",Rate=160,Kind="Washer"},
 {Name="Grandma's WiFi Router",Rarity="LEGENDARY",Rate=300,Kind="Router"},{Name="The Almighty Printer",Rarity="LEGENDARY",Rate=500,Kind="Printer"},
 {Name="Kevin the Kettle",Rarity="COMMON",Rate=10,Kind="Kettle"},{Name="Auntie Airfryer",Rarity="UNCOMMON",Rate=30,Kind="Airfryer"},
 {Name="Doctor Doorknob",Rarity="RARE",Rate=55,Kind="Doorknob"},{Name="Lady Loo Roll",Rarity="RARE",Rate=70,Kind="ToiletRoll"},
 {Name="Sultan of the Sofa",Rarity="EPIC",Rate=140,Kind="Sofa"},
 {Name="The Eternal Loading Screen",Rarity="MYTHIC",Rate=900,Kind="Loading"},{Name="Baron von Buffering",Rarity="MYTHIC",Rate=750,Kind="Buffering"},
 {Name="Barry the Bin",Rarity="COMMON",Rate=12,Kind="Toaster"},{Name="Wanda the Wiper",Rarity="COMMON",Rate=9,Kind="Lamp"},
 {Name="Colonel Custard",Rarity="UNCOMMON",Rate=28,Kind="Pickle"},{Name="Nurse Noodle",Rarity="UNCOMMON",Rate=32,Kind="Sock"},
 {Name="Duke of Dishwashers",Rarity="RARE",Rate=65,Kind="Washer"},{Name="Princess Pillow",Rarity="RARE",Rate=80,Kind="Sofa"},
 {Name="Emperor of Escalators",Rarity="EPIC",Rate=150,Kind="Fridge"},{Name="Queen of Queues",Rarity="EPIC",Rate=175,Kind="Loading"},
 {Name="The Last Slice of Pizza",Rarity="LEGENDARY",Rate=400,Kind="Banana"},
 {Name="The Infinite Update",Rarity="MYTHIC",Rate=850,Kind="Loading"},{Name="Sir Spins-A-Lot",Rarity="MYTHIC",Rate=800,Kind="Washer"},{Name="The Forbidden Remote",Rarity="MYTHIC",Rate=950,Kind="Printer"},
 {Name="Mister Dustpan",Rarity="COMMON",Rate=6,Kind="ToiletRoll"},{Name="Biscuit Tin Brenda",Rarity="COMMON",Rate=11,Kind="Toaster"},{Name="Uncle Umbrella",Rarity="COMMON",Rate=13,Kind="Lamp"},{Name="Pocket-Sized Plunger",Rarity="COMMON",Rate=14,Kind="Doorknob"},
 {Name="Baron Bubblewrap",Rarity="UNCOMMON",Rate=22,Kind="Router"},{Name="Lady Left Sock",Rarity="UNCOMMON",Rate=27,Kind="Sock"},{Name="Sir Squeaky Hinge",Rarity="UNCOMMON",Rate=34,Kind="Doorknob"},{Name="Marmalade Mugsworth",Rarity="UNCOMMON",Rate=38,Kind="Kettle"},{Name="The Spare Charger",Rarity="UNCOMMON",Rate=42,Kind="Loading"},
 {Name="Count Crumb Vacuum",Rarity="RARE",Rate=58,Kind="Printer"},{Name="Duchess Drawerhandle",Rarity="RARE",Rate=72,Kind="Doorknob"},{Name="Mister Mismatched Mittens",Rarity="RARE",Rate=88,Kind="Sock"},{Name="The Wobbly Ceiling Fan",Rarity="RARE",Rate=96,Kind="Washer"},{Name="Pudding Bowl Pete",Rarity="RARE",Rate=105,Kind="Sofa"},
 {Name="Grand Duke Dish Rack",Rarity="EPIC",Rate=135,Kind="Fridge"},{Name="Madam Mystery Meat",Rarity="EPIC",Rate=165,Kind="Banana"},{Name="Sir Beeps-a-Lot",Rarity="EPIC",Rate=185,Kind="Microwave"},{Name="The Velvet Coat Hanger",Rarity="EPIC",Rate=210,Kind="ToiletRoll"},
 {Name="The Orbital Sock Drawer",Rarity="LEGENDARY",Rate=350,Kind="Sofa"},{Name="Admiral Alarm Clock",Rarity="LEGENDARY",Rate=450,Kind="Kettle"},{Name="The Royal Extension Lead",Rarity="LEGENDARY",Rate=600,Kind="Router"},
 {Name="Supreme Eternal Sandwich Bag",Rarity="MYTHIC",Rate=1000,Kind="Loading"},{Name="The Unplugged Universe",Rarity="MYTHIC",Rate=1100,Kind="Buffering"},{Name="Grandma's Final Password",Rarity="MYTHIC",Rate=1250,Kind="Printer"},
}
Config.BrainrotBuyPrices={ ["Baron von Banana"]=1000,["Madame Lampshade"]=1500,["General Sock"]=2000,["Doctor Doorknob"]=2200,["Lady Loo Roll"]=2700,["The Fridge King"]=5000,["Countess Washing Machine"]=6500,["Sultan of the Sofa"]=8000,["Grandma's WiFi Router"]=20000,["The Almighty Printer"]=30000,["Duke of Dishwashers"]=6000,["Princess Pillow"]=8000,["Emperor of Escalators"]=14000,["Queen of Queues"]=17000,["The Last Slice of Pizza"]=24000 }
-- Every catalog entry is purchasable. Price bands follow rarity, with a small
-- progression inside each band so adjacent entries do not share one price.
local priceBands={COMMON={50,150},UNCOMMON={200,600},RARE={1000,3000},EPIC={5000,17000},LEGENDARY={20000,40000},MYTHIC={50000,100000}}
local rarityCounts={}
for _,brainrot in ipairs(Config.Brainrots) do
 local band=priceBands[brainrot.Rarity]
 local ordinal=(rarityCounts[brainrot.Rarity] or 0)+1
 rarityCounts[brainrot.Rarity]=ordinal
 if Config.BrainrotBuyPrices[brainrot.Name]==nil then
  local total=0
  for _,candidate in ipairs(Config.Brainrots) do if candidate.Rarity==brainrot.Rarity then total+=1 end end
  local fraction=total>1 and (ordinal-1)/(total-1) or 0
  Config.BrainrotBuyPrices[brainrot.Name]=math.floor(band[1]+(band[2]-band[1])*fraction)
 end
end
Config.Mutations={Neon={Multiplier=2,Color=Color3.fromRGB(0,255,235)},Golden={Multiplier=3,Color=Color3.fromRGB(255,205,30)},Shadow={Multiplier=5,Color=Color3.fromRGB(75,30,125)},Diamond={Multiplier=3,Color=Color3.fromRGB(165,235,255)},Rainbow={Multiplier=6,Color=Color3.fromRGB(255,70,220)}}
Config.Shop={ ["Base Lock"]={Price=100},["Giant Head"]={Price=500},["Banana Sword"]={Price=400},["Chicken Pet"]={Price=300},["Toilet Mount"]={Price=800},["Meme Face"]={Price=200},["Exploding Backpack"]={Price=350},["Funny Trail"]={Price=250},["Silly Animations"]={Price=300},Transformation={Price=150} }
Config.Pets={"Chicken","Banana","Potato","Toilet","Mini NPC","Giant Hamster","Dancing Frog","Floating Head"}
Config.PetPrices={Chicken=300,Banana=450,Potato=500,Toilet=800,["Mini NPC"]=900,["Giant Hamster"]=1200,["Dancing Frog"]=1000,["Floating Head"]=1500}
Config.Transformations={"Chicken","Banana","Toilet","Giant Baby","Tiny Human","Giant NPC","Potato","Frog","Traffic Cone"}
Config.CoinRewards={Event=25,Minigame=100,Secret=150,Banana=5}
return Config
