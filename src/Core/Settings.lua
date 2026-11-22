local addonName, ns = ...

local settingsCategory

local function FormatSliderValue(value)
	return format("%.1f", value)
end

local function GetLayoutOptions()
	local container = Settings.CreateControlTextContainer()
	container:Add("", NONE)
	for _, layout in ipairs(C_EditMode.GetLayouts().layouts) do
		container:Add(layout.layoutName, layout.layoutName)
	end
	return container:GetData()
end

local function GetProfileOptions()
	local profileNames = { ns.config.cooldownManagerProfile }
	local savedProfiles = CooldownManagerCenteredDB and CooldownManagerCenteredDB.profiles
	if savedProfiles then
		profileNames = {}
		for profileName in pairs(savedProfiles) do
			profileNames[#profileNames + 1] = profileName
		end
		table.sort(profileNames)
	end

	local container = Settings.CreateControlTextContainer()
	for _, profileName in ipairs(profileNames) do
		container:Add(profileName, profileName)
	end
	return container:GetData()
end

local function CreateCVarControl(category, entry)
	local isCheckbox = type(entry.default) == "boolean"
	local setting = Settings.RegisterAddOnSetting(
		category,
		"NEWHERO_" .. entry.cvar,
		entry.cvar,
		ns.config.cvars,
		isCheckbox and Settings.VarType.Boolean or Settings.VarType.Number,
		entry.label,
		entry.default
	)

	if isCheckbox then
		Settings.CreateCheckbox(category, setting, entry.cvar)
		return
	end

	local options = Settings.CreateSliderOptions(entry.min, entry.max, entry.step)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, FormatSliderValue)
	Settings.CreateSlider(category, setting, options, entry.cvar)
end

function ns.InitSettings()
	local category = Settings.RegisterVerticalLayoutCategory(addonName)

	local layoutSetting = Settings.RegisterAddOnSetting(
		category,
		"NEWHERO_EDIT_MODE_LAYOUT",
		"editModeLayout",
		ns.config,
		Settings.VarType.String,
		"Edit Mode Layout",
		ns.Defaults.editModeLayout
	)
	Settings.CreateDropdown(category, layoutSetting, GetLayoutOptions, "Layout activated on each character. Skipped if the character lacks it.")

	local profileSetting = Settings.RegisterAddOnSetting(
		category,
		"NEWHERO_COOLDOWN_MANAGER_PROFILE",
		"cooldownManagerProfile",
		ns.config,
		Settings.VarType.String,
		"Cooldown Manager Profile",
		ns.Defaults.cooldownManagerProfile
	)
	Settings.CreateDropdown(category, profileSetting, GetProfileOptions, "Cooldown Manager Centered profile assigned to each character.")

	Settings.RegisterAddOnCategory(category)

	for _, group in ipairs(ns.CVarGroups) do
		local subcategory = Settings.RegisterVerticalLayoutSubcategory(category, group.name)
		for _, entry in ipairs(group.cvars) do
			CreateCVarControl(subcategory, entry)
		end
	end

	settingsCategory = category
end

function ns.OpenSettings()
	if settingsCategory then
		Settings.OpenToCategory(settingsCategory:GetID())
	end
end

function NewHero_AddonCompartmentCallback(_, buttonName)
	if buttonName == "RightButton" then
		ns.ResetCharacter()
	else
		ns.OpenSettings()
	end
end
