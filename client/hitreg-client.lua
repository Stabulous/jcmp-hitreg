cooldownTable = {[2] = 400, [4] = 2000, [5] = 10, [6] = 1500, [11] = 250, [13] = 1750, [14] = 6500, [26] = 250, [28] = 150, [43] = 15, [100] = 250, [103] = 1000, [129] = 250}
continuousFireTable = {[11] = true, [5] = true, [26] = true, [43] = true, [28] = true}
hitMark = Image.Create(AssetLocation.Game, "hud_icon_objective_dif.dds")
hitMark:SetPosition(Render.Size/2 - hitMark:GetSize()/2 )
  
myTimer = Timer()
animTimer = Timer()
hitMarkTimer = Timer()
 
function Fire()
    myWeapon = LocalPlayer:GetEquippedWeapon()
    cooldownTime = cooldownTable[myWeapon.id]
    if cooldownTime == nil then
        cooldownTime = 1000
    end
    local results = LocalPlayer:GetAimTarget()
    if myTimer:GetMilliseconds() > cooldownTime then
        animTimer:Restart()
        myTimer:Restart()
        if results.entity then	
			if results.entity.__type == "Vehicle" or entityType == "Player" then
				if myWeapon.ammo_clip > 0 and myWeapon.ammo_clip < 20 then
					hitMarkTimer:Restart()
					local args = {}
						args.weapon = myWeapon.id
						args.target = results.entity
						args.aimPosition = results.position
						args.closest = 1
					if entityType == "Player" then
						for boneName, bone in pairs(results.entity:GetBones()) do
							if Vector3.Distance(args.aimPosition, bone.position) < args.closest then
								args.closest = Vector3.Distance(args.aimPosition, bone.position)
								args.closestbone = boneName
							end
						end
					end
					Network:Send("Shoot", args)
				end
			end
		end
	end
end
 
playFireAnimation = function()
    if animTimer:GetMilliseconds() < 100 and Game:GetState() == 4 then
        Input:SetValue(Action.FireRight, 1.0, false)
    end
end
 
blockdamage = function()
    return false
end
 
MouseDown = function(args)
     if args.button == 1 then
        if continuousFireTable[LocalPlayer:GetEquippedWeapon().id] == true then
            firing = true
        else
            Fire()
        end
    end
end
 
MouseUp = function(args)
    if args.button == 1 then
		if continuousFireTable[LocalPlayer:GetEquippedWeapon().id] == true then
			firing = false
        end
	end
end
 
function Tick()
    if hitMarkTimer:GetMilliseconds() < 1000 then hitMark:Draw() end
    if firing == true then Fire() end
end
 
function blockFire(args)
        if action == Action.FireRight then return false end
end
			
Events:Subscribe("LocalPlayerInput", blockFire)
Events:Subscribe("LocalPlayerBulletHit", blockdamage)
Events:Subscribe("MouseDown", MouseDown)
Events:Subscribe("MouseUp", MouseUp)
Events:Subscribe("Render", Tick)
Events:Subscribe("InputPoll", playFireAnimation)