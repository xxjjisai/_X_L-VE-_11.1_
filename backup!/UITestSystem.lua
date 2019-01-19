_G.UITestSystem = System:DeriveClass("UITestSystem");

function UITestSystem:Start()

    local btn = UIMgr:CreateUI("ShapeButton",{sName="隐藏",x=50,y=50,w=70,h=50,style = {
        bShape = true;
        color = {1,1,1,1},
        sFill = "line",
        nFontSize = 182;
        bHoverColor = {0.5,0.5,1,1},
    },onClick=function ()
        self:Trace(1,"ShapeButton onClick 1")
    end})

    local btn2 = UIMgr:CreateUI("ShapeProgressBarButton",{sName="显示",x=150,y=50,w=100,h=50,style = {
        bShape = true;
        color = {1,1,1,1},
        sFill = "line",
        nFontSize = 242;
        bHoverColor = {0.5,0.5,0.5,1},
    },onClick=function ()
        self:Trace(1,"ShapeButton onClick 2")
    end})

    local tbName = 
    {
        "金币",
        "铜币",
        "小刀",
        "钥匙",
        "衣服",
        "战靴",
        "指环",
        "胶水",
        "速度",
    }

    local gridx = 100;
    local gridy = 100;
    local gridItemSize = 50;
    local nItemLength = 4;
    local nItemCount = nItemLength * nItemLength
    local grid = UIMgr:CreateUI("ShapeGrid",{x = gridx, y= gridy, w = nItemLength * gridItemSize,h = nItemLength * gridItemSize,nItemLength = nItemLength,gridItemSize= gridItemSize})
    for i = 1,nItemLength*nItemLength do 
        if i > nItemCount then 
            break;
        end 
        local button = UIMgr:CreateUI("ShapeButton",{sName=tbName[i],w=gridItemSize,h=gridItemSize})
        grid:AddItem(button);
        button:SetAttr("onClick",function ()
            self:Trace(1,button.sClassName)
            grid:DeleteItem(button.sClassName)
        end)
    end

    btn:SetAttr("onHover",function ()
        grid:HideItem();
    end)

    btn2:SetAttr("onHover",function ()
        grid:ShowItem();
    end)

    btn2:SetAttr("onClick",function ()
        local button = UIMgr:CreateUI("ShapeButton",{sName="韭菜",x=100,y=350,w=gridItemSize,h=gridItemSize})
        grid:AddItem(button);
        button:SetAttr("onClick",function ()
            self:Trace(1,button.sClassName)
            grid:DeleteItem(button.sClassName)
        end)
        button:SetAttr("onHover",function ()
            button:SetAttr("sName","你好")
        end)
    end)
   
end

