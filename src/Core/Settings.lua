local addonName, ns = ...

local settingsCategory

BINDING_HEADER_NEWHERO = addonName
BINDING_NAME_NEWHERO_LOAD_ACTION_BARS = "Load Action Bars"

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

local function CompareLayoutKeys(keyA, keyB)
	return ns.db.actionBarLayouts[keyA].name < ns.db.actionBarLayouts[keyB].name
end

local function OnLoadButtonClick()
	HideUIPanel(SettingsPanel)
	ns.OpenActionBars()
end

local function CreateActionBarsCategory(parentCategory)
	local category, layout = Settings.RegisterVerticalLayoutSubcategory(parentCategory, "Action Bars")
	layout:AddInitializer(CreateSettingsButtonInitializer("Load Action Bars", "Load", OnLoadButtonClick, "Load a saved layout onto this character.", true))

	local keys = {}
	for key in pairs(ns.db.actionBarLayouts) do
		keys[#keys + 1] = key
	end
	table.sort(keys, CompareLayoutKeys)

	for _, key in ipairs(keys) do
		local savedLayout = ns.db.actionBarLayouts[key]
		local setting = Settings.RegisterAddOnSetting(
			category,
			"NEWHERO_PIN_" .. key,
			"isPinned",
			savedLayout,
			Settings.VarType.Boolean,
			"Pin: " .. savedLayout.name,
			false
		)
		Settings.CreateCheckbox(category, setting, format("Saved from %s (level %d). Pinned layouts aren't updated on logout.", savedLayout.source, savedLayout.level))
	end
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

	Settings.RegisterAddOnCategory(category)
	CreateActionBarsCategory(category)

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

function NewHero_OpenActionBars()
	ns.OpenActionBars()
end
