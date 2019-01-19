local Player = {};
function Player:Create(sClassName)
   local obj = Actor:DeriveClass(sClassName);
   return obj;
end
return Player;