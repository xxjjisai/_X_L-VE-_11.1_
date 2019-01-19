_G.Origin = {};

Origin.nUniqueID = 0;

function Origin:SetUniqueID()
    self.nUniqueID = self.nUniqueID + 1; 
    return self.nUniqueID;
end 

function Origin:GetUniqueID()
    return self.nUniqueID;
end 

function Origin:ResetUniqueID()
    self.nUniqueID = 0;
end 
