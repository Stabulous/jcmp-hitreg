damage = {[2] = .11, [4] = .3, [6] = .17, [13] = .25, [11] = .1, [14] = .3334, [26] = .5, [28] = .2, [43] = 0.00001, [100] = .15, [103] = .2, [129] = .3}
boneModifier = {["ragdoll_Head"] = 3}
function Shoot(args, player)
    distance = Vector3.Distance(args.target:GetPosition(), player:GetPosition())*.01
    myWeapon = args.weapon
	if damage[myWeapon] == nil then damage[myWeapon] = 0 end
	if args.closestbone == nil then args.closestbone = "nil" end
	if boneModifier[args.closestbone] == nil then boneModifier[args.closestbone] = 1 end
	args.target:SetHealth(args.target:GetHealth()- ((1-distance)*(damage[myWeapon])) * boneModifier[args.closestbone])  
end
     
Network:Subscribe("Shoot", Shoot)

