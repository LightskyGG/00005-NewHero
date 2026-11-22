local addonName, ns = ...

ns.CVarGroups = {
	{
		name = "Combat",
		cvars = {
			{ cvar = "assistedCombatHighlight", label = "Assisted Combat Highlight", default = true },
			{ cvar = "assistedCombatHighlightRPE", label = "Assisted Highlight (RPE)", default = true },
			{ cvar = "CAAEnabled", label = "Combat Audio Alerts", default = true },
			{ cvar = "CAADebuffSelfAlert", label = "Debuff Self Alert", default = true },
			{ cvar = "enableFloatingCombatText", label = "Floating Combat Text", default = true },
		},
	},
	{
		name = "Cooldowns",
		cvars = {
			{ cvar = "cooldownViewerEnabled", label = "Cooldown Manager", default = true },
			{ cvar = "countdownForCooldowns", label = "Cooldown Numbers", default = true },
			{ cvar = "displaySpellActivationOverlays", label = "Spell Activation Overlays", default = true },
			{ cvar = "AutoPushSpellToActionBar", label = "Auto-Add Spells to Action Bar", default = true },
		},
	},
	{
		name = "Encounters",
		cvars = {
			{ cvar = "encounterTimelineEnabled", label = "Encounter Timeline", default = true },
			{ cvar = "encounterTimelineHideForOtherRoles", label = "Hide Other Roles' Events", default = false },
			{ cvar = "encounterTimelineHideLongCountdowns", label = "Hide Long Countdowns", default = true },
			{ cvar = "encounterTimelineHideQueuedCountdowns", label = "Hide Queued Countdowns", default = true },
			{ cvar = "encounterWarningsHideIfNotTargetingPlayer", label = "Hide Warnings Not Targeting You", default = true },
		},
	},
	{
		name = "Find Yourself",
		cvars = {
			{ cvar = "findYourselfAnywhereOnlyInCombat", label = "Anywhere: Only in Combat", default = true },
			{ cvar = "findYourselfInBG", label = "Battlegrounds", default = false },
			{ cvar = "findYourselfInBGOnlyInCombat", label = "Battlegrounds: Only in Combat", default = true },
			{ cvar = "findYourselfInRaid", label = "Raids", default = false },
			{ cvar = "findYourselfInRaidOnlyInCombat", label = "Raids: Only in Combat", default = true },
			{ cvar = "findYourselfModeOutline", label = "Outline", default = true },
		},
	},
	{
		name = "Camera & Visuals",
		cvars = {
			{ cvar = "cameraDistanceMaxZoomFactor", label = "Max Zoom Factor", default = 2.6, min = 1, max = 2.6, step = 0.1 },
			{ cvar = "cameraWaterCollision", label = "Water Collision", default = true },
			{ cvar = "DisableAdvancedFlyingFullScreenEffects", label = "Disable Skyriding Screen Effects", default = true },
			{ cvar = "DisableAdvancedFlyingVelocityVFX", label = "Disable Skyriding Speed VFX", default = true },
			{ cvar = "occludedSilhouettePlayer", label = "Player Silhouette", default = true },
			{ cvar = "arachnophobiaMode", label = "Arachnophobia Mode", default = true },
			{ cvar = "movieSubtitle", label = "Movie Subtitles", default = false },
		},
	},
	{
		name = "Frames",
		cvars = {
			{ cvar = "chatBubblesParty", label = "Party Chat Bubbles", default = false },
			{ cvar = "colorChatNamesByClass", label = "Class-Colored Chat Names", default = true },
			{ cvar = "pvpFramesDisplayClassColor", label = "Class Colors: PvP Frames", default = true },
			{ cvar = "raidFramesDisplayClassColor", label = "Class Colors: Raid Frames", default = true },
			{ cvar = "raidFramesDisplayOnlyDispellableDebuffs", label = "Raid: Only Dispellable Debuffs", default = true },
			{ cvar = "showDispelDebuffs", label = "Show Dispel Debuffs", default = true },
		},
	},
	{
		name = "Loot & Items",
		cvars = {
			{ cvar = "alwaysCompareItems", label = "Always Compare Items", default = true },
			{ cvar = "autoLootDefault", label = "Auto Loot", default = true },
			{ cvar = "bankAutoDepositReagents", label = "Auto-Deposit Reagents", default = false },
			{ cvar = "bankConfirmTabCleanUp", label = "Confirm Tab Clean Up", default = false },
		},
	},
	{
		name = "Mounts & Interaction",
		cvars = {
			{ cvar = "autoDismount", label = "Auto Dismount", default = true },
			{ cvar = "autoDismountFlying", label = "Auto Dismount While Flying", default = false },
			{ cvar = "autoInteract", label = "Auto Interact", default = true },
			{ cvar = "softTargettingInteractKeySound", label = "Interact Key Sound", default = true },
		},
	},
	{
		name = "Quests",
		cvars = {
			{ cvar = "autoQuestProgress", label = "Auto Quest Progress", default = true },
			{ cvar = "autoQuestWatch", label = "Auto Quest Tracking", default = true },
		},
	},
	{
		name = "Calendar",
		cvars = {
			{ cvar = "calendarShowBattlegrounds", label = "Show Battlegrounds", default = false },
			{ cvar = "calendarShowLockouts", label = "Show Lockouts", default = false },
			{ cvar = "calendarShowResets", label = "Show Resets", default = false },
		},
	},
	{
		name = "Damage Meter",
		cvars = {
			{ cvar = "damageMeterEnabled", label = "Damage Meter", default = true },
			{ cvar = "damageMeterResetOnNewInstance", label = "Reset on New Instance", default = true },
		},
	},
	{
		name = "Social & Misc",
		cvars = {
			{ cvar = "breakUpLargeNumbers", label = "Break Up Large Numbers", default = true },
			{ cvar = "discordClientEnabled", label = "Discord Integration", default = true },
			{ cvar = "profanityFilter", label = "Profanity Filter", default = false },
			{ cvar = "showTutorials", label = "Show Tutorials", default = false },
		},
	},
}

-- Applied as-is; valid ranges are unverified, so these have no settings.
ns.FixedCVars = {
	["encounterWarningsLevel"] = "0",
	["findYourselfMode"] = "2",
	["EJDungeonDifficulty"] = "1",
	["EJLootClass"] = "1",
	["EJLootSpec"] = "1",
	["EJRaidDifficulty"] = "1",
	["EJSelectedTier"] = "1",
	["discordDisplayName"] = "LightskyGG",
}

-- Global SavedVariables forced to a fixed value (addon profiles).
ns.AddonVariables = {
	BAGANATOR_CURRENT_PROFILE = "Luxthos",
	PLATYNATOR_CURRENT_PROFILE = "Luxthos",
}
