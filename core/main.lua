﻿local Addon = {
	Name 			= "EsoRP",
	Version 		= "Alpha 5.2.2",
	Author			= "Connor",
	SavedVars		= "",
	PanelData		= "",
	OptionsTable    = "",
	HoldReticle		= false,
	Debug			= false,
	LoadOK			= false
}

function EsoRPInitialized()
	EsoRP:SetHidden(true)
	ZO_CreateStringId("SI_BINDING_NAME_HIDE_SHOW", "Show/Hide the editor")
	
	if db ~= nil then
		LoadOK = true
		Addon.SavedVars = ZO_SavedVars:New("EsoRPdatabase", 1, nil, defaults)
		
		if Addon.SavedVars.posX ~= nil then
			EsoRP:SetSimpleAnchorParent(Addon.SavedVars.posX, Addon.SavedVars.posY)
		end
		
		if Addon.SavedVars.language == nil then
			if GetCVar("language.2") == "fr" then
				Addon.SavedVars.language = "Français"
			elseif GetCVar("language.2") == "de" then
				Addon.SavedVars.language = "Deutsch"
			else
				Addon.SavedVars.language = "English"
			end
			EsoRPMsgTextBox:SetText("Welcome to EsoRP !\nFist of all, you must define a key to Show/Hide the editor.\nAfter that, press that key to show the EsoRP editor, allowing you to write a little about your character. Other users will be allowed to view this infos in the bottom-right box !\nHave fun ;)")
			EsoRPMsg:SetHidden(false)
		end
		
		Addon.SavedVars.server = GetWorldName()
		
		if Addon.SavedVars.race == nil then
			if db[GetUnitName('player')]  ~= nil then
				Addon.SavedVars.race = db[GetUnitName('player')].race
			else
				Addon.SavedVars.race = GetUnitRace('player')
			end
		end
		
		if Addon.SavedVars.class == nil then
			if db[GetUnitName('player')]  ~= nil then
				Addon.SavedVars.class = db[GetUnitName('player')].class
			else
				Addon.SavedVars.class = GetUnitClass('player')
			end
		end
		
		if Addon.SavedVars.lore == nil then
			if db[GetUnitName('player')]  ~= nil then
				Addon.SavedVars.lore = db[GetUnitName('player')].lore
			else
				Addon.SavedVars.lore = ""
			end		
		end
		
		EsoRPEditorEditBox:SetText(Addon.SavedVars.lore)
	else
		EsoRPMsgTextBox:SetText("EsoRP Error:\nImpossible to load the database. You must launch TESO via \"EsoRP Upadter.exe\" or via the shortcut on the desktop.\n If you launched the game via the EsoRP Updater or the shortcut ESORP on the desktop, please report the problem to the creator for a fast fix ! ;)")
		EsoRPMsg:SetHidden(false)
	end
end

function EsoRPTargetChanged()
	if db ~= nil then
		if not HoldReticle then
			EsoRPInfo:SetText('')
			EsoRP:SetHidden(true)
			
			if db[GetUnitName('reticleover')] ~= nil then
			--IsUnitPlayer('reticleover')
				EsoRPInfo:SetText("["..db[GetUnitName('reticleover')].language.."] - "..zo_strformat("<<C:1>>", db[GetUnitName('reticleover')].race).." "..zo_strformat("<<c:1>>", db[GetUnitName('reticleover')].class).."\n\n"..db[GetUnitName('reticleover')].lore)
				EsoRP:SetHidden(false)
			end
		end
	end
end

function EsoRPReticule(eventCode, hidden)
	if db ~= nil then
		HoldReticle = hidden
		EsoRP:SetHidden(not hidden)
	end
end

function EsoRPMove()
	if db ~= nil then
		local centerX, centerY = EsoRP:GetCenter()
		local width, height = EsoRP:GetDimensions()
		
		Addon.SavedVars.posX = centerX - width/2
		Addon.SavedVars.posY = centerY - height/2
	end
end

function EsoRPHideShowEditor()
	if db ~= nil then
		EsoRPEditor:SetHidden(not EsoRPEditor:IsHidden())
		SetGameCameraUIMode(not EsoRPEditor:IsHidden())
		EsoRPEditorEditBox:TakeFocus()
		Addon.SavedVars.lore = EsoRPEditorEditBox:GetText()
	end
end

EVENT_MANAGER:RegisterForEvent("EsoRP", EVENT_ADD_ON_LOADED, EsoRPInitialized)
EVENT_MANAGER:RegisterForEvent("EsoRP",  EVENT_RETICLE_TARGET_CHANGED, EsoRPTargetChanged)
EVENT_MANAGER:RegisterForEvent("EsoRP",  EVENT_RETICLE_HIDDEN_UPDATE, EsoRPReticule)