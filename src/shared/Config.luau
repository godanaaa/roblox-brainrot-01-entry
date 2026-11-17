local Config = {}
Config.Rarities = {COMMON={Color=Color3.fromRGB(190,205,220),Weight=42,Chaos=5},UNCOMMON={Color=Color3.fromRGB(70,220,120),Weight=27,Chaos=0},RARE={Color=Color3.fromRGB(75,150,255),Weight=17,Chaos=10},EPIC={Color=Color3.fromRGB(190,80,255),Weight=10,Chaos=20},LEGENDARY={Color=Color3.fromRGB(255,190,35),Weight=4,Chaos=35}}
Config.Brainrots = {
 {Name="Sir Pigeonsworth",Rarity="COMMON",Rate=5,Kind="Pigeon"},{Name="Toaster Steve",Rarity="COMMON",Rate=8,Kind="Toaster"},
 {Name="Captain Couch",Rarity="UNCOMMON",Rate=15,Kind="Couch"},{Name="DJ Microwave",Rarity="UNCOMMON",Rate=20,Kind="Microwave"},{Name="Professor Pickle",Rarity="UNCOMMON",Rate=25,Kind="Pickle"},
 {Name="Baron von Banana",Rarity="RARE",Rate=45,Kind="Banana"},{Name="Madame Lampshade",Rarity="RARE",Rate=60,Kind="Lamp"},{Name="General Sock",Rarity="RARE",Rate=75,Kind="Sock"},
 {Name="The Fridge King",Rarity="EPIC",Rate=120,Kind="Fridge"},{Name="Countess Washing Machine",Rarity="EPIC",Rate=160,Kind="Washer"},
 {Name="Grandma's WiFi Router",Rarity="LEGENDARY",Rate=300,Kind="Router"},{Name="The Almighty Printer",Rarity="LEGENDARY",Rate=500,Kind="Printer"},
}
Config.BrainrotBuyPrices={ ["Baron von Banana"]=1000,["Madame Lampshade"]=1500,["General Sock"]=2000,["The Fridge King"]=5000,["Countess Washing Machine"]=6500,["Grandma's WiFi Router"]=20000,["The Almighty Printer"]=30000 }
Config.Mutations={Neon={Multiplier=2,Color=Color3.fromRGB(0,255,235)},Golden={Multiplier=3,Color=Color3.fromRGB(255,205,30)},Shadow={Multiplier=5,Color=Color3.fromRGB(75,30,125)}}
Config.Shop={ ["Base Lock"]={Price=100},["Giant Head"]={Price=500},["Banana Sword"]={Price=400},["Chicken Pet"]={Price=300},["Toilet Mount"]={Price=800},["Meme Face"]={Price=200},["Exploding Backpack"]={Price=350},["Funny Trail"]={Price=250},["Silly Animations"]={Price=300},Transformation={Price=150} }
Config.Pets={"Chicken","Banana","Potato","Toilet","Mini NPC","Giant Hamster","Dancing Frog","Floating Head"}
Config.PetPrices={Chicken=300,Banana=450,Potato=500,Toilet=800,["Mini NPC"]=900,["Giant Hamster"]=1200,["Dancing Frog"]=1000,["Floating Head"]=1500}
Config.Transformations={"Chicken","Banana","Toilet","Giant Baby","Tiny Human","Giant NPC","Potato","Frog","Traffic Cone"}
Config.CoinRewards={Event=25,Minigame=100,Secret=150,Banana=5}
return Config
