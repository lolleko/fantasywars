/*function GM:RenderScreenspaceEffects()
    local ply = LocalPlayer()
    if SERVER then
	    if ply:HasWarrior() then
	    	print( "player has warrior")
		    for k,_ in pairs(ply:GetStatusTable()) do
		    	print( k )
		    	if(ply:GetStatusScreeneffect( k ) == "Blur") then
		    		print("Blur")
		    		ply:SetNWString( "screeneffect", "Blur")
					--DrawMotionBlur( 0.1, 0.79, 0.05)
				end
			end
		end
	end
	if ply:GetNWString("screeneffect" , "noeffectset") != "noeffectset" then
		print( ply:GetNWString("screeneffect" , "noeffectset"))
	end
end*/

net.Receive('FW_SetScreenEffect', function(length)
	function Blur ()
		DrawMotionBlur( 0.4, 0.79, 0.01 )
	end
	if net.ReadString() == "Blur" then
		hook.Add( "RenderScreenspaceEffects", "ScreenEffectBlur", Blur )
	end
end)

net.Receive('FW_RemoveScreenEffect', function(length)
	if net.ReadString() == "Blur" then
		hook.Remove( "RenderScreenspaceEffects", "ScreenEffectBlur" )
	end
end)