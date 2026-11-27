local addonName, ns = ...

local function ApplyDefaults(saved, defaults)
	for key, value in pairs(defaults) do
		if type(value) == "table" then
			if type(saved[key]) ~= "table" then
				saved[key] = {}
			end
		elseif saved[key] == nil then
			saved[key] = value
		end
	end
	return saved
end

local function ApplyCVarDefaults(cvarValues)
	for _, group in ipairs(ns.CVarGroups) do
		for _, entry in ipairs(group.cvars) do
			if cvarValues[entry.cvar] == nil then
				cvarValues[entry.cvar] = entry.default
			end
		end
	end
end

local function InitializeConfig()
	NEWHERO_CONFIG = ApplyDefaults(NEWHERO_CONFIG or {}, ns.Defaults)
	NEWHERO_DATA = ApplyDefaults(NEWHERO_DATA or {}, ns.DataDefaults)
	NEWHERO_CONFIG.cooldownManagerProfile = nil
	ApplyCVarDefaults(NEWHERO_CONFIG.cvars)
	ns.config = NEWHERO_CONFIG
	ns.db = NEWHERO_DATA
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
eventFrame:RegisterEvent("PLAYER_LOGOUT")
if ns.IsRetail then
	eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end
eventFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ACTIONBAR_SLOT_CHANGED" then
		ns.OnActionSlotChanged(arg1)
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent(event)
		ns.CaptureActionBars()
	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		if arg1 == "player" then
			ns.CaptureActionBars()
		end
	elseif event == "PLAYER_LOGOUT" then
		ns.SaveActionBars()
	elseif event == "PLAYER_LOGIN" then
		self:UnregisterEvent(event)
		ns.InitUI()
	elseif arg1 == addonName then
		self:UnregisterEvent(event)
		InitializeConfig()
		ns.InitSettings()
	end
end)
