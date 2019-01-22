-- 玩家数据模型
_G.PlayerModel = Model:DeriveClass("PlayerModel");

function PlayerModel:Init()
    self:SetDataValue("name","zhaokai");
    self:SetDataValue("age",19);
end