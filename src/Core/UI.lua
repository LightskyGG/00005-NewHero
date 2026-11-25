local addonName, ns = ...

local applyButton
local setsForm

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

local function IsSetSelected(key)
	return ns.config.addonSets[key] == true
end

local function ToggleSet(key)
	ns.config.addonSets[key] = not ns.config.addonSets[key] or nil
end

local function OnContinueClick()
	ns.LoadAddonSets()
	setsForm:Hide()
end

local function CreateSetsForm()
	local form = CreateFrame("Frame", "NewHeroSetsForm", UIParent, "BasicFrameTemplateWithInset")
	form:SetSize(ns.Layout.formWidth, ns.Layout.formHeight)
	form:SetPoint("CENTER")
	form:SetFrameStrata("DIALOG")
	form:SetClampedToScreen(true)
	form.TitleText:SetText("Addon Sets")

	local label = form:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	label:SetPoint("TOP", 0, -40)
	label:SetText("Sets to load:")

	local dropdown = CreateFrame("DropdownButton", nil, form, "WowStyle1DropdownTemplate")
	dropdown:SetWidth(ns.Layout.dropdownWidth)
	dropdown:SetPoint("TOP", label, "BOTTOM", 0, -8)
	dropdown:SetDefaultText(NONE)
	dropdown:SetupMenu(function(_, rootDescription)
		for _, set in ipairs(ns.GetAddonSets() or {}) do
			rootDescription:CreateCheckbox(set.name, IsSetSelected, ToggleSet, set.key)
		end
	end)

	local continueButton = CreateFrame("Button", nil, form, "UIPanelButtonTemplate")
	continueButton:SetSize(ns.Layout.buttonWidth, ns.Layout.buttonHeight)
	continueButton:SetPoint("BOTTOM", 0, 16)
	continueButton:SetText(CONTINUE)
	continueButton:SetScript("OnClick", OnContinueClick)

	form:SetScript("OnHide", ShowReloadPrompt)
	tinsert(UISpecialFrames, "NewHeroSetsForm")
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
		ShowReloadPrompt()
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
