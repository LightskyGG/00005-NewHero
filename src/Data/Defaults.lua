local addonName, ns = ...

ns.Defaults = {
	isSetupPrompted = false,
	editModeLayout = "",
	cooldownManagerProfile = "CMC by Wildu",
	cvars = {},
}

ns.DataDefaults = {
	completed = {},
}

ns.Layout = {
	buttonWidth = 140,
	buttonHeight = 30,
}

-- Blizzard's Modern and Classic presets precede custom layouts in layout indexes.
ns.EditModePresetCount = 2
