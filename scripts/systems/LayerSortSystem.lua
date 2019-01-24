_G.LayerSortSystem = System:DeriveClass("LayerSortSystem");

LayerSortSystem:SetRegisterCompo{
   "RenderLayer","Position","Size"
}

function LayerSortSystem:Update(dt)
    local iScene = self:GetCurScene();
    for nLayer,tbLayer in pairs(iScene:GetRenderList()) do
        if nLayer == RenderLayerType.nPlayer then 
            table.sort(tbLayer, function(a,b)
                if a ~= nil and b ~= nil then 
                    return a:GetiCompo("Position").y + a:GetiCompo("Size").h < b:GetiCompo("Position").y + b:GetiCompo("Size").h
                end
            end)
        end
    end 
end