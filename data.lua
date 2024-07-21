local _, addon = ...
addon.data = {}

--[[ data structure:

required:
- mapID
- x
- y

optional:
- atlas
- atlasSize
- highlightAtlas
- highlightAdd (uses 'ADD' blending mode instead of 'BLEND')
- tooltip (custom tooltip text)
- tooltipMap (uses map name by mapID)
- tooltipQuest (uses quest name by questID)
- isTaxi (will use a pre-defined atlas, and render lines between pin and source)
- taxiIndex (used to define order of taxi routes for lines)
- taxiSourceIndex (index of the source pin instead of defaulting to the player)
- isQuest (will use a pre-defined atlas)
- parent (used to reference parent data object, will be selected before the child, see special.children)
- displayExtra (exactly the same as all of the above, sans parent, for displaying the option on additional maps/locations)
- noArrow (don't display bouncing arrow above pin)

special:
- children (exclusive with everything else, will iterate through objects in the data structure instead of itself)

--]]
