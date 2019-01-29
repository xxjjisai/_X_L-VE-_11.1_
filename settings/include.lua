_G.Include = Class:DeriveClass("Include");

package.path = ""
package.cpath = (os.getenv ("LUA_CLIBRARY_PATH") or ".") .. "/libs/?.dll"

function Include:RequireHandler(strDir,sPath)
    self:Trace(1,"do file: [",strDir..sPath,"]");
    require(strDir..sPath);
end

-- 加载场景配置文件专用
function Include:RequireSceneCfgHandler(strDir,sPath)
    self:Trace(1,"do file: [",strDir..sPath,"]");
    require(strDir..sPath);
    Option.nMaxSceneCount = Option.nMaxSceneCount + 1;
end

function Include:Import(pfn)
    self:GlobalConfig();
    self:ThirdPartyLibrary();
    self:GlobalManager();
    self:GlobalSystem();
    self:GlobalModel();
    self:Trace(1," *** Do File Complete! *** ");
    pfn(0,nil);
end

function Include:ThirdPartyLibrary()
    local strDir = "libs/";
    loader      	    = require(strDir..'love-loader');
    bump_debug      	= require(strDir..'bump_debug'); 
    bump      	        = require(strDir..'bump'); 
    splash      	    = require(strDir..'lovesplash');
    Timer               = require(strDir.."Timer")();
    Camera              = require(strDir.."Camera")();
    Blob                = require(strDir.."Blob");
    Utils               = require(strDir.."Utils");
    Katsudo             = require(strDir.."katsudo");
    nuklear             = require("nuklear");
    -- socket              = require("socket");
end

function Include:GlobalManager()
    local strDir = "scripts/majors/gmgr/";
    self:RequireHandler(strDir,"GameMgr");
    self:RequireHandler(strDir,"AssetsMgr");
    self:RequireHandler(strDir,"MenuMgr");
    self:RequireHandler(strDir,"GuoDuMgr");
    self:RequireHandler(strDir,"SceneMgr");
    self:RequireHandler(strDir,"ActorMgr");
    self:RequireHandler(strDir,"ContentMgr");
    self:RequireHandler(strDir,"StorageMgr");
    self:RequireHandler(strDir,"CameraMgr");
    self:RequireHandler(strDir,"PauseMgr");
    self:RequireHandler(strDir,"OverMgr");
end 

function Include:GlobalConfig()
    local strDir = "configs/";

    local assetsCfgStrDir = strDir.."assetscfgs/";
    self:RequireHandler(assetsCfgStrDir,"AssetsFontCfg");
    self:RequireHandler(assetsCfgStrDir,"AssetsTextureCfg");
    self:RequireHandler(assetsCfgStrDir,"AssetsVoiceCfg");

    local gamesCfgStrDir = strDir.."gamecfgs/";
    self:RequireHandler(gamesCfgStrDir,"GameTypeCfg");
    self:RequireHandler(gamesCfgStrDir,"GameTextCfg");

    local sceneCfgStrDir = strDir.."scenecfgs/";
    self:RequireSceneCfgHandler(sceneCfgStrDir,"Scene_1");
end

function Include:GlobalSystem()
    local strCommonDir = "scripts/systems/common/";
    self:RequireHandler(strCommonDir,"RectangleRenderSystem");
    self:RequireHandler(strCommonDir,"LayerSortSystem");
    self:RequireHandler(strCommonDir,"SpriteRenderSystem");
    self:RequireHandler(strCommonDir,"UISystem");
    self:RequireHandler(strCommonDir,"AnimationSystem");
    self:RequireHandler(strCommonDir,"UserInterfaceSystem");
    self:RequireHandler(strCommonDir,"GameChainSystem");

    local strMysystemDir = "scripts/systems/mysystem/";
    self:RequireHandler(strMysystemDir,"PlayMechanism1");
    self:RequireHandler(strMysystemDir,"PlayMechanism2");

end

function Include:GlobalModel()
    local strDir = "scripts/models/";
    self:RequireHandler(strDir,"PlayerModel");
end