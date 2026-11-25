local addonName, ns = ...

local function ApplyCVar(cvar, value)
	if C_CVar.GetCVar(cvar) ~= nil then
		C_CVar.SetCVar(cvar, value)
	end
end

local function ApplyCVars()
	for cvar, value in pairs(ns.FixedCVars) do
		ApplyCVar(cvar, value)
	end

	for _, group in ipairs(ns.CVarGroups) do
		for _, entry in ipairs(group.cvars) do
			local value = ns.config.cvars[entry.cvar]
			if type(value) == "boolean" then
				value = value and "1" or "0"
			end
			ApplyCVar(entry.cvar, value)
		end
	end
end

local function ApplyAddonVariables()
	for variable, value in pairs(ns.AddonVariables) do
		_G[variable] = value
	end
end

local function ApplyEditModeLayout()
	local layoutName = ns.config.editModeLayout
	if layoutName == "" then return end

	for index, layout in ipairs(C_EditMode.GetLayouts().layouts) do
		if layout.layoutName == layoutName then
			C_EditMode.SetActiveLayout(index + ns.EditModePresetCount)
			return
		end
	end
	ns.Print(format("Layout \"%s\" not found on this character.", layoutName))
end

function ns.ApplySettings()
	ApplyCVars()
	ApplyAddonVariables()
	ApplyEditModeLayout()
end
