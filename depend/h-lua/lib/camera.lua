hcamera = {}

--- 重置镜头
---@param whichPlayer userdata
---@param during number
---@return void
function hcamera.reset(whichPlayer, during)
    if (whichPlayer == nil or hplayer.loc() == whichPlayer) then
        cj.ResetToGameCamera(during)
    end
end

--- 应用镜头
---@param whichPlayer userdata
---@param during number
---@param cameraSetup userdata
---@return void
function hcamera.apply(whichPlayer, during, cameraSetup)
    if (whichPlayer == nil or hplayer.loc() == whichPlayer) then
        cj.CameraSetupApplyForceDuration(cameraSetup, true, during)
    end
end

--- 移动到XY
---@param whichPlayer userdata
---@param during number
---@param x number
---@param y number
---@return void
function hcamera.toXY(whichPlayer, during, x, y)
    if (whichPlayer == nil or hplayer.loc() == whichPlayer) then
        cj.PanCameraToTimed(x, y, during)
    end
end

--- 移动到单位位置
---@param whichPlayer userdata
---@param during number
---@param whichUnit userdata
---@return void
function hcamera.toUnit(whichPlayer, during, whichUnit)
    if (whichUnit == nil) then
        return
    end
    if (whichPlayer == nil or hplayer.loc() == whichPlayer) then
        cj.PanCameraToTimed(hunit.x(whichUnit), hunit.y(whichUnit), during)
    end
end

--- 锁定镜头
---@param whichPlayer userdata
---@param whichUnit userdata
---@return void
function hcamera.lock(whichPlayer, whichUnit)
    if (whichPlayer ~= nil or hplayer.loc() == whichPlayer) then
        if (hunit.isAlive(whichUnit) == true) then
            cj.SetCameraTargetController(whichUnit, 0, 0, false)
        else
            hcamera.reset(whichPlayer, 0)
        end
    end
end

--- 更改镜头距离
---@param whichPlayer userdata
---@param diffDistance number
---@return void
function hcamera.changeDistance(whichPlayer, diffDistance)
    if (type(diffDistance) ~= "number") then
        diffDistance = 0
    end
    if (diffDistance ~= 0 and whichPlayer ~= nil and hplayer.loc() == whichPlayer) then
        local oldDistance = cj.GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)
        local toDistance = math.floor(oldDistance + diffDistance)
        if (toDistance < 500) then
            toDistance = 500
        elseif (toDistance > 5000) then
            toDistance = 5000
        end
        echo("视距已设定为：" .. toDistance, whichPlayer)
        if (oldDistance == toDistance) then
            return
        else
            cj.SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, toDistance, 0)
        end
    end
end

--- 玩家镜头震动，震动包括两种
---@param whichPlayer userdata 玩家
---@param whichType string | "'shake'" | "'quake'"
---@param during number 持续时间
---@param scale number 振幅
---@return void
function hcamera.shock(whichPlayer, whichType, during, scale)
    if (whichPlayer == nil) then
        return
    end
    if (whichType ~= "shake" or whichType ~= "quake") then
        return
    end
    if (during == nil) then
        during = 0.10 -- 假如没有设置时间，默认0.10秒意思意思一下
    end
    if (scale == nil) then
        scale = 5.00 -- 假如没有振幅，默认5.00意思意思一下
    end
    -- 镜头动作降噪
    if (hplayer.getIsShocking(whichPlayer) == true) then
        return
    end
    hplayer.setIsShocking(whichPlayer, true)
    if (whichType == "shake") then
        cj.CameraSetTargetNoiseForPlayer(whichPlayer, scale, 1.00)
        htime.setTimeout(during, function(t)
            t.destroy()
            hplayer.setIsShocking(whichPlayer, false)
            if (hplayer.loc() == whichPlayer) then
                cj.CameraSetTargetNoise(0, 0)
            end
        end)
    elseif (whichType == "quake") then
        cj.CameraSetEQNoiseForPlayer(whichPlayer, scale)
        htime.setTimeout(during, function(t)
            t.destroy()
            hplayer.setIsShocking(whichPlayer, false)
            if (hplayer.loc() == whichPlayer) then
                cj.CameraClearNoiseForPlayer(0, 0)
            end
        end)
    end
end
