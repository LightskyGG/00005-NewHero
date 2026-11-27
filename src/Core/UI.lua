local addonName, ns = ...

local applyButton
local setsForm
local actionBarsForm
local selectedLayoutKey
local isSetupFlow

StaticPopupDialogs["NEWHERO_SETUP"] = {
	text = "NewHero installed. Review its settings, then click Apply Settings on each character.",
	button1 = "Open Settings",
	button2 = CLOSE,
	OnAccept = ns.OpenSettings,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["NEWHERO_RELOAD"] = {
	text = "Settings applied. Reload UI now?",
	button1 = "Reload",
	button2 = NO,
	OnAccept = ReloadUI,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

local function ShowReloadPrompt()
	StaticPopup_Show("NEWHERO_RELOAD")
end

local function CreateForm(frameName, title, labelText, onContinue)
	local form = CreateFrame("Frame", frameName, UIParent, "BasicFrameTemplateWithInset")
	form:SetSize(ns.Layout.formWidth, ns.Layout.formHeight)
	form:SetPoint("CENTER")
	form:SetFrameStrata("DIALOG")
	form:SetClampedToScreen(true)
	form.TitleText:SetText(title)

	local label = form:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	label:SetPoint("TOP", 0, -40)
	label:SetText(labelText)

	form.dropdown = CreateFrame("DropdownButton", nil, form, "WowStyle1DropdownTemplate")
	form.dropdown:SetWidth(ns.Layout.dropdownWidth)
	form.dropdown:SetPoint("TOP", label, "BOTTOM", 0, -8)
	form.dropdown:SetDefaultText(NONE)

	form.continueButton = CreateFrame("Button", nil, form, "UIPanelButtonTemplate")
	form.continueButton:SetSize(ns.Layout.buttonWidth, ns.Layout.buttonHeight)
	form.continueButton:SetPoint("BOTTOM", 0, 16)
	form.continueButton:SetText(CONTINUE)
	form.continueButton:SetScript("OnClick", onContinue)

	tinsert(UISpecialFrames, frameName)
	return form
end

local function IsLayoutSelected(key)
	return selectedLayoutKey == key
end

local function SelectLayout(key)
	selectedLayoutKey = key
end

local function OnLoadClick()
	if InCombatLockdown() then
		ns.Print("Unavailable in combat.")
		return
	end

	if selectedLayoutKey then
		ns.LoadActionBars(selectedLayoutKey)
	end
	actionBarsForm:Hide()
end

local function OnActionBarsFormHide()
	if isSetupFlow then
		isSetupFlow = false
		ShowReloadPrompt()
	end
end

local function CreateActionBarsForm()
	local form = CreateForm("NewHeroActionBarsForm", "Action Bars", "Replace current bars with:", OnLoadClick)
	form.dropdown:SetupMenu(function(_, rootDescription)
		rootDescription:CreateRadio(NONE, IsLayoutSelected, SelectLayout, nil)
		for _, layout in ipairs(ns.GetClassLayouts() or {}) do
			rootDescription:CreateRadio(layout.name, IsLayoutSelected, SelectLayout, layout.key)
		end
	end)
	form:SetScript("OnHide", OnActionBarsFormHide)
	return form
end

local function ShowActionBarsForm()
	local key = ns.GetLayoutKey()
	selectedLayoutKey = ns.db.actionBarLayouts[key] and key or nil

	actionBarsForm = actionBarsForm or CreateActionBarsForm()
	actionBarsForm.continueButton:SetText(isSetupFlow and CONTINUE or "Load")
	actionBarsForm.dropdown:GenerateMenu()
	actionBarsForm:Show()
end

local function ContinueToActionBars()
	if ns.GetClassLayouts() then
		isSetupFlow = true
		ShowActionBarsForm()
	else
		ShowReloadPrompt()
	end
end

function ns.OpenActionBars()
	if InCombatLockdown() then
		ns.Print("Unavailable in combat.")
		return
	end

	if not ns.GetClassLayouts() then
		ns.Print("No saved action bars for this class.")
		return
	end

	isSetupFlow = false
	ShowActionBarsForm()
end

local function IsSetSelected(key)
	return ns.config.addonSets[key] == true
end

local function ToggleSet(key)
	ns.config.addonSets[key] = not ns.config.addonSets[key] or nil
end

local function OnSetsContinueClick()
	ns.LoadAddonSets()
	setsForm:Hide()
end

local function CreateSetsForm()
	local form = CreateForm("NewHeroSetsForm", "Addon Sets", "Sets to load:", OnSetsContinueClick)
	form.dropdown:SetupMenu(function(_, rootDescription)
		for _, set in ipairs(ns.GetAddonSets() or {}) do
			rootDescription:CreateCheckbox(set.name, IsSetSelected, ToggleSet, set.key)
		end
	end)
	form:SetScript("OnHide", ContinueToActionBars)
	return form
end

local function ShowSetsForm()
	setsForm = setsForm or CreateSetsForm()
	setsForm:Show()
end

local function OnApplyClick(button)
	if InCombatLockdown() then
		ns.Print("Unavailable in combat.")
		return
	end

	ns.ApplySettings()
	ns.db.completed[UnitGUID("player")] = true
	button:Hide()

	if ns.GetAddonSets() then
		ShowSetsForm()
	else
		ContinueToActionBars()
	end
end

local function CreateApplyButton()
	local button = CreateFrame("Button", "NewHeroApplyButton", UIParent, "UIPanelButtonTemplate")
	button:SetSize(ns.Layout.buttonWidth, ns.Layout.buttonHeight)
	button:SetPoint("CENTER")
	button:SetText("Apply Settings")
	button:SetMovable(true)
	button:SetClampedToScreen(true)
	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart", button.StartMoving)
	button:SetScript("OnDragStop", button.StopMovingOrSizing)
	button:SetScript("OnClick", OnApplyClick)
	return button
end

local function ShowApplyButton()
	applyButton = applyButton or CreateApplyButton()
	applyButton:Show()
end

function ns.ResetCharacter()
	ns.db.completed[UnitGUID("player")] = nil
	ShowApplyButton()
	ns.Print("Apply Settings restored for this character.")
end

function ns.InitUI()
	if not ns.config.isSetupPrompted then
		ns.config.isSetupPrompted = true
		StaticPopup_Show("NEWHERO_SETUP")
	end

	if not ns.db.completed[UnitGUID("player")] then
		ShowApplyButton()
	end
end
