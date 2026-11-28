local addonName, ns = ...

local slotCount = ns.IsRetail and ns.ActionSlotCount.Retail or ns.ActionSlotCount.Forever
local PickupItemByID = C_Item and C_Item.PickupItem
local GetSpellName = C_Spell.GetSpellName or GetSpellInfo

local function GetSpecInfo()
	if not ns.IsRetail then return end
	local specIndex = GetSpecialization()
	if not specIndex then return end
	local specID, specName = GetSpecializationInfo(specIndex)
	if specID and specID > 0 and specName and specName ~= "" then
		return specID, specName
	end
end

function ns.GetLayoutKey()
	local _, classFile = UnitClass("player")
	local specID = GetSpecInfo()
	return specID and (classFile .. ":" .. specID) or classFile
end

local function GetLayoutName()
	local className = UnitClass("player")
	local _, specName = GetSpecInfo()
	return specName and format("%s - %s", className, specName) or className
end

local currentSlots

local function CaptureSlot(slot)
	local actionType, id = GetActionInfo(slot)
	if actionType == "macro" then
		id = GetActionText(slot)
	end

	if id and (actionType == "spell" or actionType == "item" or actionType == "macro") then
		currentSlots[slot] = { actionType = actionType, id = id }
	else
		currentSlots[slot] = nil
	end
end

function ns.CaptureActionBars()
	currentSlots = {}
	for slot = 1, slotCount do
		CaptureSlot(slot)
	end
end

function ns.OnActionSlotChanged(slot)
	if not currentSlots then return end

	if slot == 0 then
		ns.CaptureActionBars()
	elseif slot <= slotCount then
		CaptureSlot(slot)
	end
end

local function CaptureMacros()
	local macros = {}
	local _, characterMacroCount = GetNumMacros()
	for i = 1, characterMacroCount do
		local name, icon, body = GetMacroInfo(ns.AccountMacroCount + i)
		if name then
			macros[#macros + 1] = { name = name, icon = icon, body = body }
		end
	end
	return macros
end

function ns.SaveActionBars()
	if not currentSlots or not ns.db.completed[UnitGUID("player")] then return end
	if ns.IsRetail and not GetSpecInfo() then return end

	local layoutKey = ns.GetLayoutKey()
	local savedLayout = ns.db.actionBarLayouts[layoutKey]
	local playerLevel = UnitLevel("player")
	if savedLayout and (savedLayout.isPinned or playerLevel < savedLayout.level) then return end

	local _, classFile = UnitClass("player")
	ns.db.actionBarLayouts[layoutKey] = {
		name = GetLayoutName(),
		classFile = classFile,
		source = UnitName("player"),
		level = playerLevel,
		isPinned = false,
		slots = currentSlots,
		macros = CaptureMacros(),
	}
end

local function FindCharacterMacro(name)
	local _, characterMacroCount = GetNumMacros()
	for index = ns.AccountMacroCount + 1, ns.AccountMacroCount + characterMacroCount do
		if GetMacroInfo(index) == name then
			return index
		end
	end
end

local function RestoreMacros(macros)
	for _, macro in ipairs(macros) do
		local index = FindCharacterMacro(macro.name)
		if index then
			EditMacro(index, macro.name, macro.icon, macro.body)
		elseif not pcall(CreateMacro, macro.name, macro.icon, macro.body, true) then
			ns.Print("Character macro limit reached; some macros were skipped.")
			break
		end
	end

	-- Character macros are sorted by name, so indexes are only stable once all exist.
	local macroIndexes = {}
	for _, macro in ipairs(macros) do
		macroIndexes[macro.name] = FindCharacterMacro(macro.name)
	end
	return macroIndexes
end

local function PickupEntry(entry, macroIndexes)
	if entry.actionType == "spell" then
		C_Spell.PickupSpell(entry.id)
		if not GetCursorInfo() then
			local spellName = GetSpellName(entry.id)
			if spellName then
				C_Spell.PickupSpell(spellName)
			end
		end
	elseif entry.actionType == "macro" then
		local index = macroIndexes[entry.id] or GetMacroIndexByName(entry.id)
		if index > 0 then
			PickupMacro(index)
		end
	elseif PickupItemByID then
		PickupItemByID(entry.id)
	end
end

function ns.LoadActionBars(key)
	local layout = ns.db.actionBarLayouts[key]
	if not layout then return end

	local macroIndexes = RestoreMacros(layout.macros)
	ClearCursor()

	for slot = 1, slotCount do
		local entry = layout.slots[slot]
		if entry then
			PickupEntry(entry, macroIndexes)
		end

		if GetCursorInfo() then
			PlaceAction(slot)
		elseif HasAction(slot) then
			PickupAction(slot)
		end
		ClearCursor()
	end

	ns.Print(format("Loaded \"%s\".", layout.name))
end

local function CompareLayouts(layoutA, layoutB)
	return layoutA.name < layoutB.name
end

function ns.GetClassLayouts()
	local _, classFile = UnitClass("player")
	local layouts = {}
	for key, layout in pairs(ns.db.actionBarLayouts) do
		if layout.classFile == classFile then
			layouts[#layouts + 1] = { key = key, name = layout.name }
		end
	end

	if #layouts == 0 then return end
	table.sort(layouts, CompareLayouts)
	return layouts
end
