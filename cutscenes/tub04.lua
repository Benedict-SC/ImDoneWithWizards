scriptools.recenterCamera(1,{x=0,y=20});
local newConv = Convo("phase3/tubSeen");
newConv.ownerName = "tub";
game.room.thingLookup["tub"].actionConvo = newConv;