#!/usr/bin/env python3

import sys
from utils import *

spell = dbc('spell')
spellName = dbc('spellname')
journalInstance = dbc('journalinstance')

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
for row in spell:
  if len(str(row.NameSubtext_lang)) > 0 and str(row.Description_lang).startswith('Teleport to the entrance'):
    spellNames[row.ID] = False

    if not row.NameSubtext_lang in dungeonSpells:
      dungeonSpells[row.NameSubtext_lang] = []
    dungeonSpells[row.NameSubtext_lang].append(row.ID)

for row in spellName:
  if row.ID in spellNames:
    spellNames[row.ID] = row.Name_lang

dungeons = {}
for row in journalInstance:
  if row.Name_lang in dungeonSpells:

    dungeons[row.ID] = {}
    dungeons[row.ID]['dungeonID'] = row.ID
    dungeons[row.ID]['dungeonName'] = row.Name_lang
    dungeons[row.ID]['spellIDs'] = dungeonSpells[row.Name_lang]

    for spellID in dungeonSpells[row.Name_lang]:
      if 'spellName' not in dungeons[row.ID]:
        dungeons[row.ID]['spellName'] = spellNames[spellID]
      elif spellNames[spellID] != dungeons[row.ID]['spellName']:
        print(f'\033[93mWARNING: dungeonID {row.ID} has multiple spells with mismatching names!\033[0m', file=sys.stderr)


print('-- this file is auto-generated')
print('local _, addon = ...')
print('local HORDE_PLAYER = UnitFactionGroup(\'player\') == \'Horde\'')
print('addon.dungeons = {')

for dungeonID, data in dungeons.items():
  if len(data["spellIDs"]) > 1:
    # this ugly mess because Blizzard gave faction-specific spells to both factions
    orderedSpells = []
    for spellID in data['spellIDs']:
      if SPELL_FACTION[spellID] == 'Horde':
        orderedSpells.insert(0, spellID)
      elif SPELL_FACTION[spellID] == 'Alliance':
        orderedSpells.insert(1, spellID)

    print(f'\t[{dungeonID}] = HORDE_PLAYER and {orderedSpells[0]} or {orderedSpells[1]}, -- {data["spellName"]} ({data["dungeonName"]})')
  else:
    print(f'\t[{dungeonID}] = {data["spellIDs"][0]}, -- {data["spellName"]} ({data["dungeonName"]})')

print('}')
