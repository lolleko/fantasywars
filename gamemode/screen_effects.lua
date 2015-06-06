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