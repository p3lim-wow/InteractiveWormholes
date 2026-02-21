#!/usr/bin/env python3

import util

flyouts = []
for row in util.dbc('spellflyout'):
  if row.Name_lang.startswith("Hero's Path:"):
    flyouts.append(row.ID)

flyoutSpells = []
for row in util.dbc('spellflyoutitem'):
  if row.SpellFlyoutID in flyouts:
    flyoutSpells.append(row.SpellID)

spellNames = {}
for row in util.dbc('spellname'):
  if row.ID in flyoutSpells:
    spellNames[row.ID] = row.Name_lang

spellFaction = {}
# BUG: missing faction data for Siege of Boralus
spellFaction[464256] = 'Horde'
spellFaction[445418] = 'Alliance'

for row in util.dbc('spellmisc'):
  if row.SpellID in flyoutSpells:
    if (row.Attributes_7 & 0x100) != 0:
      spellFaction[row.SpellID] = 'Horde'
    elif (row.Attributes_7 & 0x200) != 0:
      spellFaction[row.SpellID] = 'Alliance'

dungeonSpells = {}
for row in util.dbc('spell'):
  if row.ID in flyoutSpells:
    dungeonName = row.NameSubtext_lang
    if row.ID == 1237215:
      # BUG: data is broken for this dungeon
      dungeonName = "Eco-Dome Al'dani"

    spellID = row.ID
    if spellID in spellFaction:
      faction = spellFaction[spellID]
      if not dungeonName in dungeonSpells:
        dungeonSpells[dungeonName] = {}
      dungeonSpells[dungeonName][faction] = spellID
    elif dungeonName in dungeonSpells:
      # this shouldn't happen, but it can
      if not isinstance(dungeonSpells[dungeonName], 'list'):
        # convert to list
        dungeonSpells[dungeonName] = [dungeonSpells[dungeonName]]
      dungeonSpells[dungeonName].append(spellID)
    elif not dungeonName in dungeonSpells:
      dungeonSpells[dungeonName] = row.ID
    else:
      util.bail(f'ERROR: something went wrong for row "{row.ID}" for dungeon "{dungeonName}"')

dungeons = {}
for row in util.dbc('journalinstance'):
  if row.ID == 249:
    # need to ignore the old Magister's Terrace
    continue

  dungeonName = row.Name_lang
  if dungeonName in dungeonSpells:
    spellID = dungeonSpells[dungeonName]
    if isinstance(spellID, dict):
      spellName = spellNames[spellID['Horde']]
      spellID = f'H and {spellID["Horde"]} or {spellID["Alliance"]}'
    elif isinstance(spellID, list):
      spellID.sort() # to avoid updates when API returns random orders
      spellName = spellNames[spellID[0]] # just pick the first one
      spellID = f'{{{",".join(map(str, spellID))}}}' # turn into Lua table
    else:
      spellName = spellNames[spellID]

    dungeons[row.ID] = {
      'dungeonID': row.ID,
      'dungeonName': dungeonName,
      'spellID': spellID,
      'spellName': spellName,
      'mapID': row.MapID,
    }

# ISSUE: this won't work for new pandaren after picking a faction
prefix = '''
local _, addon = ...
local H = UnitFactionGroup('player') == 'Horde'
'''

util.templateLuaTable(
  prefix.strip(),
  'addon.dungeons',
  '\t[{dungeonID}] = {spellID}, -- {spellName} ({dungeonName})',
  dungeons
)
