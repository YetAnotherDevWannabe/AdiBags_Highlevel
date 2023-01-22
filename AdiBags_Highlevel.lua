--[[
AdiBags_Highlevel - Adds Highlevel filters to AdiBags.
Copyright 2023 Ashginger-Hyjal EU
All rights reserved.
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

-- The filter itself

local setFilter = addon:RegisterFilter("Highlevel", 85, 'ABEvent-1.0')
setFilter.uiName = L['Highlevel']
setFilter.uiDesc = L['Put High level items in their own sections.']

function setFilter:OnInitialize()
	self.db = addon.db:RegisterNamespace('Highlevel', {
		profile = { enable = true, level = 800 },
		char = {  },
	})
end

function setFilter:Update()
	self:SendMessage('AdiBags_FiltersChanged')
end

function setFilter:OnEnable()
	addon:UpdateFilters()
end

function setFilter:OnDisable()
	addon:UpdateFilters()
end

local setNames = {}

function setFilter:Filter(slotData)
	if not self.db.profile.enable or not slotData.equipSlot then
		return nil
	end
	
	local item = Item:CreateFromBagAndSlot(slotData.bag, slotData.slot)
	local itemLevel = item and item:GetCurrentItemLevel() or 0
	if slotData.equipSlot ~= "" and itemLevel >= self.db.profile.level then
		return "High level"
	end
	return nil
end

function setFilter:GetOptions()
	return {
		enable = {
			name = L['Enable Highlevel'],
			desc = L['Check this if you want a section for Highlevel items.'],
			type = 'toggle',
			order = 10,
		},
		level = {
			name = L['Item level'],
			desc = L['Minimum item level matched'],
			type = 'range',
			min = 0,
			max = 1000,
			step = 1,
			order = 20,
		},
	}, addon:GetOptionHandler(self, false, function() return self:Update() end)
end