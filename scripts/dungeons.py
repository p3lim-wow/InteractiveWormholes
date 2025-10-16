#!/usr/bin/env python3

import sys
import util

SPELL_FACTION = {
  # SpellMisc should contain this data, but it's flaky, so we gotta do this shit
  467555: 'Horde',
  467553: 'Alliance',
  464256: 'Horde',
  445418: 'Alliance',
}

spellNames = {}
dungeonSpells = {}

# the SpellCategory 1407 ("Challenger's Path") covers all challenge mode and m+ spells, but not raid ones
for row in util.dbc('spell'):
  if len(str(row.NameSubtext_lang)) > 0 and str(row.Description_lang).startswith('Teleport to the entrance'):
    spellNames[row.ID] = False

    dungeonName = row.NameSubtext_lang
    if row.ID == 1237215:
      # data is broken
      dungeonName = "Eco-Dome Al'dani"

    if not dungeonName in dungeonSpells:
      dungeonSpells[dungeonName] = []
    dungeonSpells[dungeonName].append(row.ID)

for row in util.dbc('spellname'):
  if row.ID in spellNames:
    spellNames[row.ID] = row.Name_lang

dungeons = {}
for row in util.dbc('journalinstance'):
  if row.Name_lang in dungeonSpells:

    dungeons[row.ID] = {}
    dungeons[row.ID]['dungeonID'] = row.ID
    dungeons[row.ID]['dungeonName'] = row.Name_lang

    spells = dungeonSpells[row.Name_lang]
    if len(spells) > 1:
      # this ugly mess because Blizzard gave faction-specific spells to both factions
      factionSpells = []
      for spellID in spells:
        if spellID in SPELL_FACTION:
          if SPELL_FACTION[spellID] == 'Horde':
            factionSpells.insert(0, spellID)
          elif SPELL_FACTION[spellID] == 'Alliance':
            factionSpells.insert(1, spellID)
      if len(factionSpells) > 0:
        dungeons[row.ID]['spellID'] = f'H and {factionSpells[0]} or {factionSpells[1]}'
      else:
        print('ERROR: there are more than 1 spell in the data set without a faction:', file=sys.stderr)
        print(spells, file=sys.stderr)
        sys.exit(1)
    else:
      dungeons[row.ID]['spellID'] = spells[0]

    for spellID in spells:
      if 'spellName' not in dungeons[row.ID]:
        dungeons[row.ID]['spellName'] = spellNames[spellID]
      elif spellNames[spellID] != dungeons[row.ID]['spellName']:
        print(f'\033[93mERROR: dungeonID {row.ID} has multiple spells with mismatching names!\033[0m', file=sys.stderr)
        sys.exit(1)

# this logic is not great, it will be messed up for pandas picking a faction
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
