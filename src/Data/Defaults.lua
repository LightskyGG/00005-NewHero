local addonName, ns = ...

ns.Defaults = {
	isSetupPrompted = false,
	editModeLayout = "",
	addonSets = {},
	cvars = {},
}

ns.DataDefaults = {
	completed = {},
	actionBarLayouts = {},
}

ns.Layout = {
	buttonWidth = 140,
	buttonHeight = 30,
	formWidth = 300,
	formHeight = 140,
	dropdownWidth = 240,
}

-- Blizzard's Modern and Classic presets precede custom layouts in layout indexes.
ns.EditModePresetCount = 2

ns.ActionSlotCount = {
	Retail = 180,
	Forever = 120,
}

-- Character macros are indexed after the account macro range.
ns.AccountMacroCount = 120
