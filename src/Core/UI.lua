local addonName, ns = ...

local applyButton

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

local function OnApplyClick(button)
	if InCombatLockdown() then
		ns.Print("Unavailable in combat.")
		return
	end

	ns.ApplySettings()
	ns.db.completed[UnitGUID("player")] = true
	button:Hide()
	StaticPopup_Show("NEWHERO_RELOAD")
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
