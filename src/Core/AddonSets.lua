local addonName, ns = ...

local function CompareSets(setA, setB)
	local isNumberA = type(setA.key) == "number"
	if isNumberA ~= (type(setB.key) == "number") then
		return isNumberA
	end
	return setA.key < setB.key
end

function ns.GetAddonSets()
	if not (C_AddOns.IsAddOnLoaded("ACP") and ACP and ACP_Data and ACP_Data.AddonSet) then return end

	local sets = {}
	for key, addonSet in pairs(ACP_Data.AddonSet) do
		if #addonSet > 0 then
			sets[#sets + 1] = { key = key, name = ACP:GetSetName(key) }
		end
	end

	if #sets == 0 then return end
	table.sort(sets, CompareSets)
	return sets
end

function ns.LoadAddonSets()
	local sets = ns.GetAddonSets()
	if not sets then return end

	local isCleared
	for _, set in ipairs(sets) do
		if ns.config.addonSets[set.key] then
			if not isCleared then
				ACP:DisableAllAddons()
				isCleared = true
			end
			ACP:LoadSet(set.key)
		end
	end
end
