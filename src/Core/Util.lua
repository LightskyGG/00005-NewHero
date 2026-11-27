local addonName, ns = ...

ns.IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

function ns.Print(...)
	print("|cff33ff99NewHero:|r", ...)
end
