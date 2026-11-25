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
eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent(event)
		ns.InitUI()
		return
	end

	if loadedAddon ~= addonName then return end
	self:UnregisterEvent(event)

	InitializeConfig()
	ns.InitSettings()
end)
