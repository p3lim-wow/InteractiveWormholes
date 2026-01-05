#!/usr/bin/env python3

import util

# BUG: blizzard forgets they already have spells for dungeons and adds new ones
DUPLICATES = {
  'Skyreach': [
    159898, # the original spell added in WoD
    1254557, # new spell added in Midnight
  ]
}

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
    elif dungeonName in DUPLICATES:
      if not dungeonName in dungeonSpells:
        dungeonSpells[dungeonName] = []
      if spellID in DUPLICATES[dungeonName]:
        dungeonSpells[dungeonName].append(spellID)
      else:
        util.bail(f'ERROR: duplicate dungeon spell "{row.ID}" for dungeon "{dungeonName}" not accounted for')
    elif not dungeonName in dungeonSpells:
      dungeonSpells[dungeonName] = row.ID
    else:
      util.bail(f'ERROR: duplicate dungeon spell "{row.ID}" for dungeon "{dungeonName}"')

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
