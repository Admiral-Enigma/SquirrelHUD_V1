--Base
local function Base()
	draw.RoundedBox(5, 10, ScrH() -200 - 10, 400, 200, Color(40,40,40,250))

	draw.RoundedBox(0, 20, ScrH() - 90 ,400-20, 30, Color(60,60,60,230))

	local DrawHealth = LocalPlayer():Health() or 0
    local EchoHealth = LocalPlayer():Health() or 0

    if DrawHealth > 100 then
    	DrawHealth = 100
    end

    --HealthBox
    if DrawHealth != 0 then
    	draw.RoundedBox(0, 20, ScrH() - 90 + 2, (400-20) * DrawHealth / 100, 30-4, Color(255,0,0,255))
    end

    if EchoHealth > 100 then
    	EchoHealth = 100
    end
    --HealthText
    if EchoHealth != 0 then
       draw.DrawText("Health: "..EchoHealth, "Trebuchet24", 155, ScrH() - 90 + 3, Color(255,255,255))
    end

    --Armor
    local DrawArmor = LocalPlayer():Armor() or 0
    local EchoArmor = LocalPlayer():Armor() or 0


    if DrawArmor > 100 then
    	DrawArmor = 100
    end

    if EchoArmor > 100 then
    	EchoArmor = 100
    end

    draw.RoundedBox(0, 20, ScrH() - 50 ,400-20, 29, Color(60,60,60,230))

    --ArmorBox
    if DrawArmor != 0 then
    	draw.RoundedBox(0, 20, ScrH() - 50 + 2, (400-20) * DrawArmor / 100, 30-4, Color(0,0,255,255))
    end

    --ArmorText
    if EchoArmor >= 0 then
      draw.DrawText("Armor: "..EchoArmor, "Trebuchet24", 155, ScrH() - 50 + 3, Color(255,255,255))
    end

    --NameText
    draw.DrawText(LocalPlayer():Nick(), "DermaLarge", 30, ScrH() - 200 + 3, Color(255,255,255))

    --SalaryText
    draw.DrawText("Salary: "..LocalPlayer():getDarkRPVar("salary"), "DermaLarge", 30, ScrH() - 130 + 3, Color(255,255,255))

    --MoneyText
    draw.DrawText("$"..LocalPlayer():getDarkRPVar("money"), "DermaLarge", 200, ScrH() - 130 + 3, Color(255,255,255))

    --JobText
    draw.DrawText("Job: "..LocalPlayer():getDarkRPVar("job"), "Trebuchet24", 30, ScrH() - 160 + 3, Color(255,255,255))
end

--Hide
local hideHUDElements = {
	["DarkRP_LocalPlayerHUD"] = true,

}

hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", hideHUDElements)




-- Default Stuff
local function Agenda()
	local agenda = LocalPlayer():getAgendaTable()
	if not agenda then return end

	draw.RoundedBox(10, 10, 10, 460, 110, Color(0, 0, 0, 155))
	draw.RoundedBox(10, 12, 12, 456, 106, Color(51, 58, 51,100))
	draw.RoundedBox(10, 12, 12, 456, 20, Color(0, 0, 70, 100))

	draw.DrawNonParsedText(agenda.Title, "DarkRPHUD1", 30, 12, Color(255, 0, 0, 255), 0)

	local text = LocalPlayer():getDarkRPVar("agenda") or ""

	text = text:gsub("//", "\n"):gsub("\\n", "\n")
	text = DarkRP.textWrap(text, "DarkRPHUD1", 440)
	draw.DrawNonParsedText(text, "DarkRPHUD1", 30, 35, Color(255, 255, 255, 255), 0)
end

local VoiceChatTexture = surface.GetTextureID("voice/icntlk_pl")
local function DrawVoiceChat()
	if LocalPlayer().DRPIsTalking then
		local chbxX, chboxY = chat.GetChatBoxPos()

		local Rotating = math.sin(CurTime()*3)
		local backwards = 0
		if Rotating < 0 then
			Rotating = 1-(1+Rotating)
			backwards = 180
		end
		surface.SetTexture(VoiceChatTexture)
		surface.SetDrawColor(Color(140,0,0,180))
		surface.DrawTexturedRectRotated(ScrW() - 100, chboxY, Rotating*96, 96, backwards)
	end
end

CreateConVar("DarkRP_LockDown", 0, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
local function LockDown()
	local chbxX, chboxY = chat.GetChatBoxPos()
	if util.tobool(GetConVarNumber("DarkRP_LockDown")) then
		local cin = (math.sin(CurTime()) + 1) / 2
		local chatBoxSize = math.floor(ScrH() / 4)
		draw.DrawNonParsedText(DarkRP.getPhrase("lockdown_started"), "ScoreboardSubtitle", chbxX, chboxY + chatBoxSize, Color(cin * 255, 0, 255 - (cin * 255), 255), TEXT_ALIGN_LEFT)
	end
end

local Arrested = function() end

usermessage.Hook("GotArrested", function(msg)
	local StartArrested = CurTime()
	local ArrestedUntil = msg:ReadFloat()

	Arrested = function()
		if CurTime() - StartArrested <= ArrestedUntil and LocalPlayer():getDarkRPVar("Arrested") then
		draw.DrawNonParsedText(DarkRP.getPhrase("youre_arrested", math.ceil(ArrestedUntil - (CurTime() - StartArrested))), "DarkRPHUD1", ScrW()/2, ScrH() - ScrH()/12, Color(255,255,255,255), 1)
		elseif not LocalPlayer():getDarkRPVar("Arrested") then
			Arrested = function() end
		end
	end
end)

local AdminTell = function() end

usermessage.Hook("AdminTell", function(msg)
	timer.Destroy("DarkRP_AdminTell")
	local Message = msg:ReadString()

	AdminTell = function()
		draw.RoundedBox(4, 10, 10, ScrW() - 20, 100, Color(0, 0, 0, 200))
		draw.DrawNonParsedText(DarkRP.getPhrase("listen_up"), "GModToolName", ScrW() / 2 + 10, 10, Color(255, 255, 255, 255), 1)
		draw.DrawNonParsedText(Message, "ChatFont", ScrW() / 2 + 10, 80, Color(200, 30, 30, 255), 1)
	end

	timer.Create("DarkRP_AdminTell", 10, 1, function()
		AdminTell = function() end
	end)
end)

local function DrawPlayerInfo(ply)
	local pos = ply:EyePos()

	pos.z = pos.z + 10 -- The position we want is a bit above the position of the eyes
	pos = pos:ToScreen()
	pos.y = pos.y - 50 -- Move the text up a few pixels to compensate for the height of the text

	if GAMEMODE.Config.showname and not ply:getDarkRPVar("wanted") then
		draw.DrawNonParsedText(ply:Nick(), "DarkRPHUD2", pos.x + 1, pos.y + 1, Color(0,0,0,255), 1)
		draw.DrawNonParsedText(ply:Nick(), "DarkRPHUD2", pos.x, pos.y, team.GetColor(ply:Team()), 1)
	end

	if GAMEMODE.Config.showhealth and not ply:getDarkRPVar("wanted") then
		draw.DrawNonParsedText(DarkRP.getPhrase("health", ply:Health()), "DarkRPHUD2", pos.x + 1, pos.y + 21, Color(0,0,0,255), 1)
		draw.DrawNonParsedText(DarkRP.getPhrase("health", ply:Health()), "DarkRPHUD2", pos.x, pos.y + 20, Color(255,255,255,255), 1)
	end

	if GAMEMODE.Config.showjob then
		local teamname = team.GetName(ply:Team())
		draw.DrawNonParsedText(ply:getDarkRPVar("job") or teamname, "DarkRPHUD2", pos.x + 1, pos.y + 41, Color(0,0,0,255), 1)
		draw.DrawNonParsedText(ply:getDarkRPVar("job") or teamname, "DarkRPHUD2", pos.x, pos.y + 40, Color(255,255,255,255), 1)
	end

	if ply:getDarkRPVar("HasGunlicense") then
		surface.SetMaterial(Page)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(pos.x-16, pos.y + 60, 32, 32)
	end
end

local function DrawWantedInfo(ply)
	if not ply:Alive() then return end

	local pos = ply:EyePos()
	if not pos:isInSight({LocalPlayer(), ply}) then return end

	pos.z = pos.z + 14
	pos = pos:ToScreen()

	if GAMEMODE.Config.showname then
		draw.DrawNonParsedText(ply:Nick(), "DarkRPHUD2", pos.x + 1, pos.y + 1, Color(0,0,0,255), 1)
		draw.DrawNonParsedText(ply:Nick(), "DarkRPHUD2", pos.x, pos.y, team.GetColor(ply:Team()), 1)
	end

	local wantedText = DarkRP.getPhrase("wanted", tostring(ply:getDarkRPVar("wantedReason")))

	draw.DrawNonParsedText(wantedText, "DarkRPHUD2", pos.x, pos.y - 40, Color(0,0,0,255), 1)
	draw.DrawNonParsedText(wantedText, "DarkRPHUD2", pos.x + 1, pos.y - 41, Color(255,0,0,255), 1)
end


local function DrawEntityDisplay()
	local shootPos = LocalPlayer():GetShootPos()
	local aimVec = LocalPlayer():GetAimVector()

	for k, ply in pairs(players or player.GetAll()) do
		if not ply:Alive() or ply == LocalPlayer() then continue end
		local hisPos = ply:GetShootPos()
		if ply:getDarkRPVar("wanted") then DrawWantedInfo(ply) end

		if GAMEMODE.Config.globalshow then
			DrawPlayerInfo(ply)
		-- Draw when you're (almost) looking at him
		elseif not GAMEMODE.Config.globalshow and hisPos:DistToSqr(shootPos) < 160000 then
			local pos = hisPos - shootPos
			local unitPos = pos:GetNormalized()
			if unitPos:Dot(aimVec) > 0.95 then
				local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
				if trace.Hit and trace.Entity ~= ply then return end
				DrawPlayerInfo(ply)
			end
		end
	end

	local tr = LocalPlayer():GetEyeTrace()

	if IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
		tr.Entity:drawOwnableInfo()
	end
end

function GAMEMODE:DrawDeathNotice(x, y)
	if not GAMEMODE.Config.showdeaths then return end
	self.BaseClass:DrawDeathNotice(x, y)
end

local function DisplayNotify(msg)
	local txt = msg:ReadString()
	GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
	surface.PlaySound("buttons/lightswitch2.wav")

	-- Log to client console
	print(txt)
end
usermessage.Hook("_Notify", DisplayNotify)

function DisableDrawInfo()
	return false
end
hook.Add("HUDDrawTargetID", "DisableDrawInfo", DisableDrawInfo)


function GM:HUDShouldDraw(name)
	if name == "CHudHealth" or
		name == "CHudBattery" or
		name == "CHudSuitPower" or
		(HelpToggled and name == "CHudChat") then
			return false
	else
		return true
	end
end


local function DrawSHud()

	-- Custom
	Base()

	-- Default
	Agenda()
	DrawVoiceChat()
	LockDown()
	
	Arrested()
	AdminTell()
	
	DrawEntityDisplay()

end
hook.Add("HUDPaint", "DrawSHud", DrawSHud)
