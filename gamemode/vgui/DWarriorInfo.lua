local WINFO = {}

function WINFO:Init()
end

function WINFO:SetData(data)
	local DLabel = vgui.Create( "DLabel", self.Frame )
	DLabel:SetPos( ScrW()/1.5, 40 )
	DLabel:SetText( data.Name )

end

vgui.Register('DWarriorInfo', WINFO)