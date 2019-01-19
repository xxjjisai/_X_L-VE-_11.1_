-- LOVE2D 颜色在转换器，适用于11.x及以上
function ColorTransformForLove11(r,g,b)
    local colorx = function (r,g,b)
        return r/255,g/255,b/255
    end 
    str = string.format("%.2f,%.2f,%.2f",colorx(r,g,b));
    print(str)
    return str
end

ColorTransformForLove11(255,255,255)