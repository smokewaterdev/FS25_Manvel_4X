-- Author: Aslan
-- Name: SplineToolkit
-- Namespace: local
-- Description: Toolkit for work with Splines
-- Icon: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAAJWGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDggNzkuMTY0MDM2LCAyMDE5LzA4LzEzLTAxOjA2OjU3ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjEuMCAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDI2LTAyLTIyVDIyOjM0OjUwKzAxOjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDI2LTAyLTIyVDIyOjM0OjUwKzAxOjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyNi0wMi0yMlQyMjozNDo1MCswMTowMCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo4ZGU4NDAxNS00NWQyLTA1NDEtOWEyZi01MDFlZTEyMTQyMDUiIHhtcE1NOkRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDozNDk4MmEwZi0wNjBkLTQ5NDktODNmYS01NDExNzkyMTU1MGQiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoyYzI0MDc2Zi1jNzJmLTU4NGItOThkNy0zYjkxMWU2MDQ3YjYiIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIj4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDoyYzI0MDc2Zi1jNzJmLTU4NGItOThkNy0zYjkxMWU2MDQ3YjYiIHN0RXZ0OndoZW49IjIwMjYtMDItMjJUMjI6MzQ6NTArMDE6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyMS4wIChXaW5kb3dzKSIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6OGRlODQwMTUtNDVkMi0wNTQxLTlhMmYtNTAxZWUxMjE0MjA1IiBzdEV2dDp3aGVuPSIyMDI2LTAyLTIyVDIyOjM0OjUwKzAxOjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgMjEuMCAoV2luZG93cykiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDxwaG90b3Nob3A6RG9jdW1lbnRBbmNlc3RvcnM+IDxyZGY6QmFnPiA8cmRmOmxpPjBGQkIwM0ExNjI0QUVERDg0N0I0QUZDQzg0MzBGRjkwPC9yZGY6bGk+IDxyZGY6bGk+MURDNzRGOURDMTdBODg0MkNEODdGNjM5NDAwMjI0NUE8L3JkZjpsaT4gPHJkZjpsaT4yNzQ0RkFDNUJCN0Y0RjBBRDdEMTZDMUFBRTY4RUQyMzwvcmRmOmxpPiA8cmRmOmxpPjUwMDkxQ0Y2QjBFMjAxQzY4RTMxMDMyMTU4QzRCNTA4PC9yZGY6bGk+IDxyZGY6bGk+QzFBOEM3N0VENTE1MzIxQ0MyQzgyRkFEMkFENDgxRTc8L3JkZjpsaT4gPHJkZjpsaT5DNTZDNUM3NzU3MzI3QjQ0NzA3M0I0Qzc2QzAzRTIxRTwvcmRmOmxpPiA8cmRmOmxpPkRERkEwMjkzMTI1MDAxMDREMjgyMjVDRkY0QzA5MEUzPC9yZGY6bGk+IDxyZGY6bGk+RUFDNzZFOTczQjI3Q0M2MTk5RDc2N0EzREI1Q0Q2RUU8L3JkZjpsaT4gPHJkZjpsaT5GMDlBMDEyQTFBQTdFNDlBMzVCODBGQTYzNDc3MzAzNTwvcmRmOmxpPiA8cmRmOmxpPmFkb2JlOmRvY2lkOnBob3Rvc2hvcDozMThkYmMwNS0yYzg3LTFiNGEtYmY1Mi03MWY3ZjA5YmQzZTM8L3JkZjpsaT4gPHJkZjpsaT5hZG9iZTpkb2NpZDpwaG90b3Nob3A6NDY4MjA4NzQtODRiMS1kMDQxLTlkNGQtMzRiZjk5OTg1NWViPC9yZGY6bGk+IDxyZGY6bGk+YWRvYmU6ZG9jaWQ6cGhvdG9zaG9wOjdmYzJlNTU0LTc5MjgtZmY0NC04YTI2LTYwZjg3YzY5OWVmYzwvcmRmOmxpPiA8cmRmOmxpPmFkb2JlOmRvY2lkOnBob3Rvc2hvcDo5ZmIwNzczNi00MjBiLTMzNGUtODU5OS1hMjhhODc5YjExNWU8L3JkZjpsaT4gPHJkZjpsaT5hZG9iZTpkb2NpZDpwaG90b3Nob3A6ZTU3NjBlZWUtYzlmMS1iZjQwLWJhMzYtZGZmYWUyMzAxYTBmPC9yZGY6bGk+IDwvcmRmOkJhZz4gPC9waG90b3Nob3A6RG9jdW1lbnRBbmNlc3RvcnM+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8++nrl+wAAAzVJREFUOBEFwdtrHFUAwOHfmTmz2Uw2e0l2k123NhfRphViekErQVpf1GrBB4v4oFIiKFr1DxDRor6IN/ShLfgmCEKxeCmo7UuKlQTBRpIQkibtmmza3LrZS7I7uzNzzvH75PrP7w3UC1fPp/cw4rWU5TqC0HEJA0AAxoA2oA0oAWgQWtdLzHTuP/WmDDYmL/Q/Vn9qaruPqeRL1GoFTnd/TybZAhEBbYFvwBfggWkqhIGudKx37fYvF6RrLR66VRR8qs6SHX2UH+ehOBFydmgaraoIXUKyg6SGE9HYMoauG6ymh2yWh6WjG2q90sPFuZBIYxO/tMOceZK2Ex+DBhE0wdsg3JzDW7kKW5eJx8sIE0W0PCVbgc1w7h6jS9/w138nsRurHM3+xtRXXxO6eeyuQaK9D5F58BDdT5+A9bepXjtNyp3Fshxk0NCkEw4/PPM7V/4ZJzsQcmw4ABHQ2m3SWDZU/oWl72xWj7zO4++cw+sbw7/1BoY4klBBWbDnPoex1Da6KfBUitDOYyUzdOYyJDoH2BsbIvrAceoBrM5NcMABow3ShBqaLarbNn7mRaIjz+PkDuIk8minHWWD70O9UqZw8wabf35IX/MSzr42TCtEojSN7RbBI+dJPjHGWnGVewsz7KxeJiytEJaLiFoR2VghJTc4mNWk9rqoXYVuGiRK4TWjRA+cJGzscPvcK1AYpysGnR3gutDRDTIPlVKMVqMDr1qhwzGgHKQJwVa7TF/8jP0vf8SxT/4guDuLvz5DuLWAri4TtNYo3lgjdfh94mWP4rUv6Dt6E7REhi1IxCOkl77k7w+u4468QGJolOT9z+E+/CptUYG2wL/yGtmffgWlsWcj3MkJ4kmQKI32DAN5h3Rlkq2JSbbHJVt2GtXeg+nIohK9lBYmsOZrxNpdpvwqhyOABtnwtG0BOoBEZ4RkwmC0QakNwmCdwJ8mqEBhWHC9EiGo1xg4EtKfg8WCsuSOHJxdLswfz+YjaANCAUIgLImMghMVoGE4bsj1KPwAMgkoLisq1uCCzD777pnipc+/vTu1vM+WCIMAQAgAAIMAjAEhQAhYu2OMiu5d7D/11pn/AWm5hR5lZHbjAAAAAElFTkSuQmCC
-- Hide: no
-- AlwaysLoaded: no

source("editorUtils.lua")
source("ui/ProgressDialog.lua")
source("ui/MessageBox.lua")
source("ui/YesNoDialog.lua")

local gamePath = EditorUtils.getGameBasePath()
if gamePath == nil then
    return
end
local scenePath = getSceneFilename():match("(.*/)")

source(gamePath .. "dataS/scripts/std.lua")
source(gamePath .. "dataS/scripts/shared/class.lua")
source(gamePath .. "dataS/scripts/misc/Logging.lua")
source(gamePath .. "dataS/scripts/xml/XMLFile.lua")
source(gamePath .. "dataS/scripts/xml/XMLManager.lua")
source("dataS/scripts/i3d/I3DUtil.lua")
source("dataS/scripts/utils/MathUtil.lua")

SplineToolkit = {}

SplineToolkit.VERSION = "v2.0.1"

-- Terrain Grid/Pixel size in meters used by setTerrainHeight.
SplineToolkit.TERRAIN_METER_PER_PIXEL_LOAD_FROM_MAP = true
SplineToolkit.TERRAIN_METER_PER_PIXEL_CUSTOM = 0.5	-- Used if LOAD_FROM_MAP = false

SplineToolkit.FENCE_RAW_IMG_PATH = "imgFence/"
SplineToolkit.ROAD_RAW_IMG_PATH = "imgRoads/"
SplineToolkit.GERMANY_EASTER_EGG = false

SplineToolkit.WINDOW_WIDTH = 450
SplineToolkit.SETTINGS_PATH = getAppDataPath() .. "settingsSplineToolkit.xml"

local function getScriptEnvironment()
    local ok, err = pcall(function() error("!") end)
    if not ok and err then
        local scriptPath = err:match("^(.+%.lua):%d+:")
        if scriptPath then
            local base = scriptPath:match("^(.*[/\\])[^/\\]+$")
            if base then
                -- print("[SplineToolkit] Script base resolved via error: " .. base)
                return base
            end
        end
    end
	
    local candidates = {
        getAppDataPath(),
        getEditorDirectory(),
    }
    for _, base in ipairs(candidates) do
        local dir = base .. "scripts/"
        if folderExists(dir) and fileExists(dir .. "SplineToolkit.lua") then
            print("[SplineToolkit] Script dir resolved via fileExists: " .. dir)
            return dir
        end
    end
    local fallback = getAppDataPath() .. "scripts/"
    print("[SplineToolkit] Script dir fallback: " .. fallback)
    return fallback
end

local scriptBase = getScriptEnvironment()
SplineToolkit.FENCE_IMG_PATH = scriptBase .. SplineToolkit.FENCE_RAW_IMG_PATH
SplineToolkit.FENCE_CALLBACK_ANIMATION_FILENAME =  scenePath .. "config/animatedMapFences.xml"

SplineToolkit.ROAD_IMG_PATH = scriptBase .. SplineToolkit.ROAD_RAW_IMG_PATH

-- Debug draw colors (0-255 per channel). Use dc() helper to convert for draw calls.
SplineToolkit.DRAW_COLORS = {
    -- Shared
    POINT_SAMPLE        = {255, 255,   0, 255},  -- yellow: sampled / exported points
    LINE_PATH           = {  0, 255,   0, 255},  -- green: path / wireframe lines
    LINE_EDGE           = {255,   0,   0, 255},  -- red: boundary edge lines

    -- setTerrainHeight
    TERRAIN_SMOOTH_ZONE = {102, 179, 255,  64},  -- blue: outer smooth falloff zone
    TERRAIN_CENTER      = { 51, 255,  51,  89},  -- green: center raised strip

    -- paintTerrain
    PAINT_FILL          = {235,  51, 242,  38},  -- violet: paint area fill

    -- setFoliage
    FOLIAGE_FILL        = { 51, 230,  77,  38},  -- green: foliage area fill

    -- placeObject (normal)
    PLACE_LEFT          = { 77, 153, 255,  51},  -- blue: left zone
    PLACE_CENTER        = { 77, 255, 102,  51},  -- green: center zone
    PLACE_RIGHT         = {255, 179,  51,  51},  -- orange: right zone

    -- placeObject (easter egg)
    PLACE_EGG_LEFT      = { 13,  13,  13, 153},
    PLACE_EGG_CENTER    = {230,  13,  13,  77},
    PLACE_EGG_RIGHT     = {255, 191,   0,  77},

    -- street preview
    STREET_WIRE         = {255,   0, 255, 255},  -- magenta: wireframe
    STREET_FILL         = { 26,  26,  26, 153},  -- dark gray: fill
}

local function getMapModPath()
    local scenePath = getSceneFilename()
    if not scenePath or scenePath == "" then
        printError("[SplineToolkit] getMapModPath: No scene loaded.")
        return nil
    end

    local dir = scenePath:match("^(.*[/\\])")
    if not dir then
        printError("[SplineToolkit] getMapModPath: Could not parse scene path.")
        return nil
    end

    dir = dir:gsub("[/\\]$", "")

    for _ = 1, 5 do
        if fileExists(dir .. "/modDesc.xml") then
            return dir .. "/"
        end
        local parent = dir:match("^(.*[/\\])")
        if not parent then break end
        dir = parent:gsub("[/\\]$", "")
    end

    printError("[SplineToolkit] getMapModPath: modDesc.xml not found within 5 parent directories.")
    return nil
end

local function getSceneDirRelativeToMod()
    local modRoot = getMapModPath()
    if not modRoot then return nil end

    local scenePath = getSceneFilename()
    if not scenePath or scenePath == "" then return nil end

    local sceneDir = scenePath:match("^(.*[/\\])")
    if not sceneDir then return nil end

    modRoot  = modRoot:gsub("\\", "/")
    sceneDir = sceneDir:gsub("\\", "/")

    if sceneDir:sub(1, #modRoot) ~= modRoot then
        printError("[SplineToolkit] getSceneDirRelativeToMod: Scene is not under mod root.")
        return nil
    end

    return sceneDir:sub(#modRoot + 1)  -- e.g. "map/"
end

function SplineToolkit:getOrCreateAnimationMapObjectsFile()
    local fullPath = SplineToolkit.FENCE_CALLBACK_ANIMATION_FILENAME
    if not fullPath then
        printError("[SplineToolkit] FENCE_CALLBACK_ANIMATION_FILENAME not set.")
        return nil
    end

    if not fileExists(fullPath) then
        local xmlFile = XMLFile.create("AnimMapObjects", fullPath, "animatedObjects")
        if not xmlFile then
            printError("[SplineToolkit] Could not create animatedMapObjects.xml at: " .. fullPath)
            return nil
        end
        xmlFile:save()
        xmlFile:delete()
    end

    local modRoot = getMapModPath()
    if not modRoot then return nil end

    local normalized = fullPath:gsub("\\", "/")
    modRoot = modRoot:gsub("\\", "/")

    if normalized:sub(1, #modRoot) == modRoot then
        return normalized:sub(#modRoot + 1)  -- relative path from mod root
    end

    return fullPath  -- fallback: absolute path
end

local function getTerrainUnitsPerPixel()
    local scenePath = getSceneFilename()
    if not scenePath or scenePath == "" then return nil end

    local xmlFile = XMLFile.loadIfExists("TerrainI3D", scenePath)
    if not xmlFile then return nil end

    local value = xmlFile:getFloat("i3D.Scene.TerrainTransformGroup#unitsPerPixel")
    xmlFile:delete()
    return value
end

function SplineToolkit.new()
    local self = setmetatable({}, { __index = SplineToolkit })
	self.currentTab = nil
	self.tabNames = {"Base Tools", "Place Object", "Place Fence", "Export .OBJ", "Gen. Street"}

	self.preview = {
		active = false,
		mode = nil,
		state = {},
		buttons = {},
		colors = {
			off      = {0.9, 0.5, 0.5, 1.0},
			preview  = {1.0, 0.9, 0.53, 1.0},
			dimmed   = {0.6, 1.0, 0.55, 1.0}
		}
	}

	self.foliageLayers = {
		options = {},
		states = {},
		channels = {},
		offsets = {}
	}

    self.panels = {}
    self.subPanels = {}
    self.subPanelRefs = {}
	
	self.values = {
		base = {
			setOnTerrain = { heightOffset = 0.0 },
			setOffset = { sideOffset = 0.0, heightOffset = 0.0 },
			setTerrainHeight = { terrainHeight = 0.0, terrainWidth = 3.0, smoothDistance = 1.0 },
			paintTerrain = { textureLayers = {}, widthLeft = 3.0, widthRight = 3.0 },
			setFoliage = { widthLeft = 3.0, widthRight = 3.0 },
			resampleSpline = { numPoints = 15 },
		},
		
		objectPlacement = {
			activeModeIndex = 1,
			sideOffset = 0.0,
			objDistanceType = {"Fixed", "Random"},
			objectFixDistance = 5.0,
			objectMinDistance = 1.0,
			objectMaxDistance = 10.0,
			setHeightType = {"On Spline", "On Spline + Follow Axis", "On Terrain", "On Terrain + Normals", "On Terrain + Follow Axis", "Fix Value"},
			setOnTerrainNormals = {"False", "True"},
			objectHeight = 0.0,
			objectRotate = 0.0,
			setRandomRotate = {"False", "True"},
			
			areaChoiceOptions = {"Enable", "Disable"},
			areaMinDistBetween = 5.0,
			areaMaxDistBetween = 15.0,
			areaWidthLeft = 3.0,
			areaWidthCenter = 3.0,
			areaWidthRight = 3.0,
		},

		fencePlacement = {
			imgPath = SplineToolkit.FENCE_IMG_PATH,
			defaultImage = "defaultIcon.png",
			fenceTable = {
				{ name = "AS Fence 01", xmlFile = "$data/placeables/brandless/fences/AS/fence01/fence01.xml", imgFile = "AS_fence01.png"},
				{ name = "AS Fence 02", xmlFile = "$data/placeables/brandless/fences/AS/fence02/fence02.xml", imgFile = "AS_fence02.png"},
				{ name = "AS Fence 03", xmlFile = "$data/placeables/brandless/fences/AS/fence03/fence03.xml", imgFile = "AS_fence03.png"},
				{ name = "AS Fence 04", xmlFile = "$data/placeables/brandless/fences/AS/fence04/fence04.xml", imgFile = "AS_fence04.png"},
				{ name = "AS Fence 05", xmlFile = "$data/placeables/brandless/fences/AS/fence05/fence05.xml", imgFile = "AS_fence05.png"},
				{ name = "AS Fence 06", xmlFile = "$data/placeables/brandless/fences/AS/fence06/fence06.xml", imgFile = "AS_fence06.png"},
				{ name = "AS Fence 07", xmlFile = "$data/placeables/brandless/fences/AS/fence07/fence07.xml", imgFile = "AS_fence07.png"},
				{ name = "AS Fence 08", xmlFile = "$data/placeables/brandless/fences/AS/fence08/fence08.xml", imgFile = "AS_fence08.png"},
				{ name = "AS Fence 09", xmlFile = "$data/placeables/brandless/fences/AS/fence09/fence09.xml", imgFile = "AS_fence09.png"},
				{ name = "AS Fence 10", xmlFile = "$data/placeables/brandless/fences/AS/fence10/fence10.xml", imgFile = "AS_fence10.png"},
				{ name = "AS Fence 12", xmlFile = "$data/placeables/brandless/fences/AS/fence12/fence12.xml", imgFile = "AS_fence12.png"},
				{ name = "AS Fence 13", xmlFile = "$data/placeables/brandless/fences/AS/fence13/fence13.xml", imgFile = "AS_fence13.png"},
				{ name = "AS Fence 14", xmlFile = "$data/placeables/brandless/fences/AS/fence14/fence14.xml", imgFile = "AS_fence14.png"},
				{ name = "AS Fence 15", xmlFile = "$data/placeables/brandless/fences/AS/fence15/fence15.xml", imgFile = "AS_fence15.png"},
				{ name = "AS Fence 16", xmlFile = "$data/placeables/brandless/fences/AS/fence16/fence16.xml", imgFile = "AS_fence16.png"},
				{ name = "AS Fence 17", xmlFile = "$data/placeables/brandless/fences/AS/fence17/fence17.xml", imgFile = "AS_fence17.png"},
				
				{ name = "EU Fence 01", xmlFile = "$data/placeables/brandless/fences/EU/fence01/fence01.xml", imgFile = "EU_fence01.png"},
				{ name = "EU Fence 02", xmlFile = "$data/placeables/brandless/fences/EU/fence02/fence02.xml", imgFile = "EU_fence02.png"},
				{ name = "EU Fence 03", xmlFile = "$data/placeables/brandless/fences/EU/fence03/fence03.xml", imgFile = "EU_fence03.png"},
				{ name = "EU Fence 04", xmlFile = "$data/placeables/brandless/fences/EU/fence04/fence04.xml", imgFile = "EU_fence04.png"},
				{ name = "EU Fence 05", xmlFile = "$data/placeables/brandless/fences/EU/fence05/fence05.xml", imgFile = "EU_fence05.png"},
				{ name = "EU Fence 06", xmlFile = "$data/placeables/brandless/fences/EU/fence06/fence06.xml", imgFile = "EU_fence06.png"},
				{ name = "EU Fence 07", xmlFile = "$data/placeables/brandless/fences/EU/fence07/fence07.xml", imgFile = "EU_fence07.png"},
				{ name = "EU Fence 08", xmlFile = "$data/placeables/brandless/fences/EU/fence08/fence08.xml", imgFile = "EU_fence08.png"},
				{ name = "EU Fence 09", xmlFile = "$data/placeables/brandless/fences/EU/fence09/fence09.xml", imgFile = "EU_fence09.png"},
				{ name = "EU Fence 10", xmlFile = "$data/placeables/brandless/fences/EU/fence10/fence10.xml", imgFile = "EU_fence10.png"},
				{ name = "EU Fence 11", xmlFile = "$data/placeables/brandless/fences/EU/fence11/fence11.xml", imgFile = "EU_fence11.png"},
				{ name = "EU Fence 12", xmlFile = "$data/placeables/brandless/fences/EU/fence12/fence12.xml", imgFile = "EU_fence12.png"},
				{ name = "EU Fence 13", xmlFile = "$data/placeables/brandless/fences/EU/fence13/fence13.xml", imgFile = "EU_fence13.png"},
				{ name = "EU Fence 14", xmlFile = "$data/placeables/brandless/fences/EU/fence14/fence14.xml", imgFile = "EU_fence14.png"},
				{ name = "EU Fence 15", xmlFile = "$data/placeables/brandless/fences/EU/fence15/fence15.xml", imgFile = "EU_fence15.png"},
				{ name = "EU Fence 16", xmlFile = "$data/placeables/brandless/fences/EU/fence16/fence16.xml", imgFile = "EU_fence16.png"},
				{ name = "EU Fence 17", xmlFile = "$data/placeables/brandless/fences/EU/fence17/fence17.xml", imgFile = "EU_fence17.png"},
				{ name = "EU Fence 18", xmlFile = "$data/placeables/brandless/fences/EU/fence18/fence18.xml", imgFile = "EU_fence18.png"},
				{ name = "EU Fence 19", xmlFile = "$data/placeables/brandless/fences/EU/fence19/fence19.xml", imgFile = "EU_fence19.png"},
				{ name = "EU Fence 20", xmlFile = "$data/placeables/brandless/fences/EU/fence20/fence20.xml", imgFile = "EU_fence20.png"},
				
				{ name = "US Fence 01", xmlFile = "$data/placeables/brandless/fences/US/fence01/fence01.xml", imgFile = "US_fence01.png"},
				{ name = "US Fence 02", xmlFile = "$data/placeables/brandless/fences/US/fence02/fence02.xml", imgFile = "US_fence02.png"},
				{ name = "US Fence 03", xmlFile = "$data/placeables/brandless/fences/US/fence03/fence03.xml", imgFile = "US_fence03.png"},
				{ name = "US Fence 04", xmlFile = "$data/placeables/brandless/fences/US/fence04/fence04.xml", imgFile = "US_fence04.png"},
				{ name = "US Fence 05", xmlFile = "$data/placeables/brandless/fences/US/fence05/fence05.xml", imgFile = "US_fence05.png"},
				{ name = "US Fence 06", xmlFile = "$data/placeables/brandless/fences/US/fence06/fence06.xml", imgFile = "US_fence06.png"},
				{ name = "US Fence 07", xmlFile = "$data/placeables/brandless/fences/US/fence07/fence07.xml", imgFile = "US_fence07.png"},
				{ name = "US Fence 07 Metal", xmlFile = "$data/placeables/brandless/fences/US/fence07/fenceMetal07.xml", imgFile = "US_fence07Metal.png"},
				{ name = "US Fence 08", xmlFile = "$data/placeables/brandless/fences/US/fence08/fence08.xml", imgFile = "US_fence08.png"},
				{ name = "US Fence 09", xmlFile = "$data/placeables/brandless/fences/US/fence09/fence09.xml", imgFile = "US_fence09.png"},
				{ name = "US Fence 10", xmlFile = "$data/placeables/brandless/fences/US/fence10/fence10.xml", imgFile = "US_fence10.png"},
				{ name = "US Fence 11", xmlFile = "$data/placeables/brandless/fences/US/fence11/fence11.xml", imgFile = "US_fence11.png"},
				{ name = "US Fence 12", xmlFile = "$data/placeables/brandless/fences/US/fence12/fence12.xml", imgFile = "US_fence12.png"},
				{ name = "US Fence 13", xmlFile = "$data/placeables/brandless/fences/US/fence13/fence13.xml", imgFile = "US_fence13.png"},
				{ name = "US Fence 14", xmlFile = "$data/placeables/brandless/fences/US/fence14/fence14.xml", imgFile = "US_fence14.png"},
				{ name = "US Fence 15", xmlFile = "$data/placeables/brandless/fences/US/fence15/fence15.xml", imgFile = "US_fence15.png"},
				{ name = "US Fence 16", xmlFile = "$data/placeables/brandless/fences/US/fence16/fence16.xml", imgFile = "US_fence16.png"},
				{ name = "US Fence 17", xmlFile = "$data/placeables/brandless/fences/US/fence17/fence17.xml", imgFile = "US_fence17.png"},
				
				{ name = "Husbandries 01", xmlFile = "$data/placeables/brandless/fences/husbandries/level01/fencesFarmLevel01.xml", imgFile = "HUS_fencesFarmLevel01.png"},
				{ name = "Husbandries 02", xmlFile = "$data/placeables/brandless/fences/husbandries/level02/fencesFarmLevel02.xml", imgFile = "HUS_fencesFarmLevel02.png"},
				{ name = "Husbandries 03", xmlFile = "$data/placeables/brandless/fences/husbandries/level03/fencesFarmLevel03.xml", imgFile = "HUS_fencesFarmLevel03.png"},
				{ name = "Husbandries 04", xmlFile = "$data/placeables/brandless/fences/husbandries/level04/fencesFarmLevel04.xml", imgFile = "HUS_fencesFarmLevel04.png"},
				{ name = "Husbandries 05", xmlFile = "$data/placeables/brandless/fences/husbandries/level05/fencesFarmLevel05.xml", imgFile = "HUS_fencesFarmLevel05.png"},
				{ name = "Husbandries Chicken", xmlFile = "$data/placeables/brandless/fences/husbandries/chickenNetFence/chickenNetFence.xml", imgFile = "HUS_chickenNetFence.png"},
				{ name = "Husbandries Cow", xmlFile = "$data/placeables/brandless/fences/husbandries/cowFence/cowFence.xml", imgFile = "HUS_cowFence.png"},
				{ name = "Husbandries Sheep", xmlFile = "$data/placeables/brandless/fences/husbandries/sheepNetFence/sheepNetFence.xml", imgFile = "HUS_sheepNetFence.png"},
			},
			placeType = {"Cubic", "Linear"},
			useYOffset = {"True", "False"},
			placeStartPole = {"True", "False"},
			placeEndPole = {"True", "False"},
			mirrorFence = {"False", "True"},
			fenceGateChoice = {},
			
			-- animXMLPath = basePath .. "/config/animationMapObjects.xml",
			animXMLPath = "",
		},
		
		exportObject = {
			exportPath = scenePath,
			useCustomFilename = false,
			defaultFileName = "SplineExport",
			customFileName = "",
			createMeshType = {"only Vertex", "as Spline"},
			distanceType = {"Fixed", "Variable"},
			vertexDistance = 2,
			vertexMinDistance = 0.5,
			vertexMinAngle = 5,
		},
		
		roadMesh = {
			exportPath = scenePath,
			-- Texture
			imgPath = SplineToolkit.ROAD_IMG_PATH,
			defaultImage = "defaultIcon.png",
			mirrorAtCenter = {"True", "False"},
			textureDistance = 10.0,
			sliceStart = 0.0,
			sliceEnd = 25.0,
			
			textureTable = {
				-- AS ROADS
				{	name = "AS Main Road", imgFile = "AS_mainRoad.png", shaderVar = "alphaNoise_customParallax_alphaMap",
					textures = {
						["diffuse"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoad_diffuse.dds",
						["specular"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoad_specular.dds",
						["normal"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoad_normal.dds",
						["height"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoad_height.dds",
						["alpha"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoad_alpha.dds",
					},
				},
				{	name = "AS Secondary Road", imgFile = "AS_secondaryRoad.png", shaderVar = "alphaNoise_customParallax_alphaMap",
					textures = {
						["diffuse"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoadSecondary_diffuse.dds",
						["specular"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoadSecondary_specular.dds",
						["normal"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoadSecondary_normal.dds",
						["height"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoadSecondary_height.dds",
						["alpha"] = "$data/maps/mapAS/textures/buildings/infrastructure/mainRoadSecondary_alpha.dds",
					},
				},
				{	name = "AS Village Road", imgFile = "AS_villageRoad.png", shaderVar = "alphaNoise_customParallax_alphaMap",
					textures = {
						["diffuse"] = "$data/maps/mapAS/textures/buildings/infrastructure/villageRoad_diffuse.dds",
						["specular"] = "$data/maps/mapAS/textures/buildings/infrastructure/villageRoad_specular.dds",
						["normal"] = "$data/maps/mapAS/textures/buildings/infrastructure/villageRoad_normal.dds",
						["height"] = "$data/maps/mapAS/textures/buildings/infrastructure/villageRoad_height.dds",
						["alpha"] = "",
					},
				},
				{	name = "AS Dirt Road", imgFile = "AS_dirtRoad.png", shaderVar = "alphaNoise_terrainFormat_customParallax",
					textures = {
						["diffuse"] = "$data/maps/mapAS/textures/buildings/infrastructure/dirtRoad_diffuse.dds",
						["specular"] = "$data/maps/mapAS/textures/buildings/infrastructure/dirtRoad_specular.dds",
						["normal"] = "$data/maps/mapAS/textures/buildings/infrastructure/dirtRoad_normal.dds",
						["height"] = "$data/maps/mapAS/textures/buildings/infrastructure/dirtRoad_height.dds",
						["alpha"] = "",
					},
				},
				-- EU ROADS
				{	name = "EU Main Road", imgFile = "EU_mainRoad.png", shaderVar = "alphaNoise_customParallax_alphaMap",
					textures = {
						["diffuse"] = "$data/maps/mapEU/textures/buildings/infrastructure/roads_diffuse.dds",
						["specular"] = "$data/maps/mapEU/textures/buildings/infrastructure/roads_specular.dds",
						["normal"] = "$data/maps/mapEU/textures/buildings/infrastructure/roads_normal.dds",
						["height"] = "",
						["alpha"] = "",
					},
				},
				{	name = "EU Secondary Road", imgFile = "EU_secondaryRoad.png", shaderVar = "alphaNoise_terrainFormat_customParallax",
					textures = {
						["diffuse"] = "$data/maps/mapEU/textures/buildings/infrastructure/sideRoads_diffuse.dds",
						["specular"] = "$data/maps/mapEU/textures/buildings/infrastructure/sideRoads_specular.dds",
						["normal"] = "$data/maps/mapEU/textures/buildings/infrastructure/sideRoads_normal.dds",
						["height"] = "",
						["alpha"] = "",
					},
				},
				{	name = "EU Dirt Road 01", imgFile = "EU_dirtRoad01.png", shaderVar = "alphaNoise_terrainFormat_customParallax",
					textures = {
						["diffuse"] = "$data/maps/mapEU/textures/buildings/infrastructure/dirtRoad01_diffuse.dds",
						["specular"] = "$data/maps/mapEU/textures/buildings/infrastructure/dirtRoad_specular.dds",
						["normal"] = "$data/maps/mapEU/textures/buildings/infrastructure/dirtRoad_normal.dds",
						["height"] = "",
						["alpha"] = "",
					},
				},
                {	name = "EU Dirt Road 02", imgFile = "EU_dirtRoad02.png", shaderVar = "alphaNoise_terrainFormat_customParallax",
					textures = {
						["diffuse"] = "$data/maps/mapEU/textures/buildings/infrastructure/dirtRoad02_diffuse.dds",
						["specular"] = "$data/maps/mapEU/textures/buildings/infrastructure/dirtRoad_specular.dds",
						["normal"] = "$data/maps/mapEU/textures/buildings/infrastructure/dirtRoad_normal.dds",
						["height"] = "",
						["alpha"] = "",
					},
				},
				
				-- US ROADS
				{	name = "US Main Road", imgFile = "US_mainRoad.png", shaderVar = "alphaNoise_customParallax_alphaMap",
					textures = {
						["diffuse"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoad_diffuse.dds",
						["specular"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoad_specular.dds",
						["normal"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoad_normal.dds",
						["height"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoad_height.dds",
						["alpha"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoad_alpha.dds",
					},
				},
				{	name = "US Secondary Road", imgFile = "US_secondaryRoad.png", shaderVar = "alphaNoise_customParallax_alphaMap",
					textures = {
						["diffuse"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoadSecondary_diffuse.dds",
						["specular"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoadSecondary_specular.dds",
						["normal"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoadSecondary_normal.dds",
						["height"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoadSecondary_height.dds",
						["alpha"] = "$data/maps/mapUS/textures/buildings/infrastructure/mainRoadSecondary_alpha.dds",
					},
				},
				{	name = "US Gravel Road", imgFile = "US_gravelRoad.png", shaderVar = "alphaNoise_terrainFormat_customParallax",
					textures = {
						["diffuse"] = "$data/maps/mapUS/textures/buildings/infrastructure/gravelRoad_diffuse.dds",
						["specular"] = "$data/maps/mapUS/textures/buildings/infrastructure/gravelRoad_specular.dds",
						["normal"] = "$data/maps/mapUS/textures/buildings/infrastructure/gravelRoad_normal.dds",
						["height"] = "$data/maps/mapUS/textures/buildings/infrastructure/gravelRoad_height.dds",
						["alpha"] = "",
					},
				},
                {	name = "US Dirt Road", imgFile = "US_dirtRoad.png", shaderVar = "alphaNoise_terrainFormat_customParallax",
					textures = {
						["diffuse"] = "$data/maps/mapUS/textures/buildings/infrastructure/dirtRoad_diffuse.dds",
						["specular"] = "$data/maps/mapUS/textures/buildings/infrastructure/dirtRoad_specular.dds",
						["normal"] = "$data/maps/mapUS/textures/buildings/infrastructure/dirtRoad_normal.dds",
						["height"] = "$data/maps/mapUS/textures/buildings/infrastructure/dirtRoad_height.dds",
						["alpha"] = "",
					},
				},
                {	name = "US Dirt Gravel Road", imgFile = "US_dirtGravelRoad.png", shaderVar = "alphaNoise_terrainFormat_customParallax",
					textures = {
						["diffuse"] = "$data/maps/mapUS/textures/buildings/infrastructure/dirtGravelRoad02_diffuse.dds",
						["specular"] = "$data/maps/mapUS/textures/buildings/infrastructure/dirtGravelRoad_specular.dds",
						["normal"] = "$data/maps/mapUS/textures/buildings/infrastructure/dirtGravelRoad_normal.dds",
						["height"] = "$data/maps/mapUS/textures/buildings/infrastructure/dirtGravelRoad_height.dds",
						["alpha"] = "",
					},
				},
			},
			-- Mesh
			roadName = "",
			width = 7.0,
			minSegmentLength = 2.5,
			maxAngle = 1.25,
			alignEdgesOnTerrain = {"False", "True"},
			terrainDecal = {"True", "False"},
			-- Traffic
			trafficCenter = {"False", "True"},
			trafficLeft = {"False", "True"},
			trafficRight = {"False", "True"},
			leftPercent = 50,
			rightPercent = 50,
			maxSpeedScale = 1,
			speedLimit = 80,
		}
	}

    if not self:isMap() then
        printError("[SplineToolkit] This is not a Map!")
        return
    end

	self:setTerrainTextureLayers()
	self:loadFoliageLayers()
    self:generateUI()
	
	
    return self
end

function SplineToolkit:createRadioButtonGroup(parentSizer, buttonDefs, defaultIndex)
    defaultIndex = defaultIndex or 1

    local group = {
        buttons = {},
        activeIndex = defaultIndex,
        activeColor = {0.1, 0.77, 0.99, 1.0},
        inactiveColor = {0.9, 0.9, 0.9, 1.0},
		disabledColor = {0.7, 0.7, 0.7, 1.0},
    }

    function group:getActiveIndex()
        return self.activeIndex
    end

    function group:getActiveButton()
        return self.buttons[self.activeIndex]
    end

    function group:setActive(index)
        if index < 1 or index > #self.buttons then return end
        self.activeIndex = index
        for i, btn in ipairs(self.buttons) do
            if i == index then
                btn:setBackgroundColor(self.activeColor[1], self.activeColor[2], self.activeColor[3], self.activeColor[4])
            else
                btn:setBackgroundColor(self.inactiveColor[1], self.inactiveColor[2], self.inactiveColor[3], self.inactiveColor[4])
            end
        end
    end

    function group:setEnabled(enabled)
        for _, btn in ipairs(self.buttons) do
            btn:setEnabled(enabled)
        end
        if not enabled then
            for _, btn in ipairs(self.buttons) do
                btn:setBackgroundColor(self.disabledColor[1], self.disabledColor[2], self.disabledColor[3], self.disabledColor[4])
            end
        else
            self:setActive(self.activeIndex)
        end
    end

    for i, def in ipairs(buttonDefs) do
        local idx = i
        local btn = UIButton.new(parentSizer, def.label, function()
            group:setActive(idx)
            if def.callback then def.callback() end
        end, nil, -1, -1, 1, -1, BorderDirection.RIGHT, 5, 1)
        table.insert(group.buttons, btn)
    end

    group:setActive(defaultIndex)

    return group
end

function SplineToolkit:isMap()
    local rootNode = getRootNode()
    if rootNode == nil or rootNode == 0 then
        return false
    end

    for i = 0, getNumOfChildren(rootNode) - 1 do
        local child = getChildAt(rootNode, i)
        if child ~= nil and child ~= 0 and getName(child) == "terrain" then
            return true
        end
    end

    return false
end

function SplineToolkit:onUpdate(dt)
	if self.currentTab == self.tabNames[3] then
		self:updateFenceGenerateButtonState()
		self:updateGateImportButtonState()
		self:updateGatePositionSliderState()
		self:updateSplineModeButtonState()
	end
end

function SplineToolkit:togglePlayingState(state)
    local shouldPlay
    if state ~= nil then
        shouldPlay = state
    else
        shouldPlay = not getIsUpdateLoopPlaying()
    end

    if shouldPlay and not getIsUpdateLoopPlaying() then
        startUpdateLoop()
    elseif not shouldPlay and getIsUpdateLoopPlaying() then
        stopUpdateLoop()
    end
end

function SplineToolkit:onChangeTab(tabName, isOpenWnd)
	if not isOpenWnd then
		self:disableAllPreviews()
		self:saveSettings(self.currentTab)
		
		if self.uiListFence then
			self:clearFenceList()
		end
		if self.uiListRoad then
			self:clearRoadTextureList()
		end
	end
	
	self:togglePlayingState(false)
	
	self:onDeleteSubPanels()
	
	if self.panels then
		for _, panel in ipairs(self.panels) do
			if panel ~= nil then
				panel:destroy()
			end
		end
	end
		
    self.panels = {}

	self.uiGateAnimationXMLPreview = nil
	self.placeObjectLastMode = nil
	self.gateUIActive = false
	self.gateUIPendingCreate = false

	self.currentTab = tabName

	self:loadSettings(self.currentTab)

    if tabName == self.tabNames[1] then
        self:genBaseUI()
    elseif tabName == self.tabNames[2] then
        self:genPlaceObjectUI()
		self:buildPlaceObjectSettingsUI()
    elseif tabName == self.tabNames[3] then
        self:genPlaceFenceUI()
		self:setFenceList()
		self:togglePlayingState(true)
    elseif tabName == self.tabNames[4] then
        self:genExportUI()
    elseif tabName == self.tabNames[5] then
		self:genRoadUI()
		self:setRoadTextureList()
    end
	
	self:updateChoicesFromSettings(self.currentTab)
	
    self.window:fit()
end

function SplineToolkit:onDeleteSubPanels()
	if self.subPanels then
		for i, subPanel in ipairs(self.subPanels) do
			if subPanel ~= nil then
				subPanel:destroy()
			end
		end
	end
    self.subPanels = {}

	self.window:refresh()
    self.window:fit()
end

function SplineToolkit:updateChoicesFromSettings(tabName)
	if not self.loadSettingChoiceList then return end
	for _, entry in ipairs(self.loadSettingChoiceList) do
		local uiElement = self[entry.uiKey]
		if uiElement and entry.options and entry.selected then
			local ok, err = pcall(self.setChoiceFromString, self, uiElement, entry.options, entry.selected)
			if not ok then
				print("[SplineToolkit] updateChoicesFromSettings skipped " .. tostring(entry.uiKey) .. ": " .. tostring(err))
			end
		end
	end

    if tabName == self.tabNames[2] and self.values.objectPlacement.activeModeIndex ~= 2 then
		self:setPlaceObjectDistanceType()
		self:setPlaceObjectHeightType()
		self:setPlaceObjectRotateType()
    -- elseif tabName == self.tabNames[3] then
    elseif tabName == self.tabNames[4] then
		self:setUseCustomFilename()
		self:setExportChoice()
    elseif tabName == self.tabNames[5] then
		self:setRoadTrafficChoice()
    end

	self.loadSettingChoiceList = nil
end

function SplineToolkit:generateUI()
    self.uiFrameRowSizer = UIRowLayoutSizer.new()
    self.window = UIWindow.new(self.uiFrameRowSizer, "SplineToolkit by Aslan (" .. SplineToolkit.VERSION .. ")", false, false, -1, -1, -1, -1)
    
	self.uiBorderSizer = UIRowLayoutSizer.new()
    UIPanel.new(self.uiFrameRowSizer, self.uiBorderSizer, -1, -1, SplineToolkit.WINDOW_WIDTH, -1, BorderDirection.NONE, 0, 1)

    self.uiRowSizer = UIRowLayoutSizer.new()
    self.uiPanelSizer = UIPanel.new(self.uiBorderSizer, self.uiRowSizer, -1, -1, -1, -1, BorderDirection.ALL, 8, 1)

	self.uiNoteBook = UINotebook.new(self.uiRowSizer)	
	self.uiNoteBook:setOnTabChangeCallback(function(tabName) self:onChangeTab(tabName) end)
	
    self.uiBaseRowSizer = UIRowLayoutSizer.new()
	self.uiNoteBook:addTab(self.tabNames[1], self.uiBaseRowSizer)
    self.uiPlaceObjectRowSizer = UIRowLayoutSizer.new()
	self.uiNoteBook:addTab(self.tabNames[2], self.uiPlaceObjectRowSizer)
    self.uiPlaceFenceRowSizer = UIRowLayoutSizer.new()
	self.uiNoteBook:addTab(self.tabNames[3], self.uiPlaceFenceRowSizer)
    self.uiExportRowSizer = UIRowLayoutSizer.new()
	self.uiNoteBook:addTab(self.tabNames[4], self.uiExportRowSizer)
    self.uiRoadRowSizer = UIRowLayoutSizer.new()
	self.uiNoteBook:addTab(self.tabNames[5], self.uiRoadRowSizer)
	
	self:onChangeTab(self.tabNames[1], true)

    self.window:showWindow()
	self.updateListener = addUpdateListener("onUpdate", self)
	self.selectionListener = addEventListener(HookType.ON_SELECTION_CHANGED, function(nodeId, isSelected)
		self:onSelectionChangedGate(nodeId, isSelected)
	end)
	self.window:setOnCloseCallback(function()
		self:disableAllPreviews()
		self:saveSettings(self.currentTab)
		if self.updateListener ~= nil then
			removeUpdateListener(self.updateListener)
			self.updateListener = nil
		end
		if self.selectionListener ~= nil then
			removeEventListener(HookType.ON_SELECTION_CHANGED, self.selectionListener)
			self.selectionListener = nil
		end
	end)
end

function SplineToolkit:genBaseUI()
	local values = self.values.base
	
    local rowSizer = UIRowLayoutSizer.new()
	self.uiBasePanel = UIPanel.new(self.uiBaseRowSizer, rowSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	table.insert(self.panels, self.uiBasePanel)
    ----------------------------------------------------------------
    -- SET ON TERRAIN
    ----------------------------------------------------------------
	UILabel.new(rowSizer, "Set Spline on Terrain", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)

    local gridSizer =  UIGridSizer.new(2, 2, 5, 5)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)

    UITextArea.new(gridSizer, "Height Offset (m)", TextAlignment.CENTER, true, false)
    self.uiTerrainHeightOffset = UIFloatSlider.new(gridSizer, values.setOnTerrain.heightOffset, -10.0, 10.0)

    UILabel.new(gridSizer, "")
    UIButton.new(gridSizer, "Apply Height", function() self:setSplineOnTerrain() end) :setBackgroundColor(0.6, 1.0, 0.55, 1.0)

    ----------------------------------------------------------------
    -- SET OFFSET
    ----------------------------------------------------------------
	UIHorizontalLine.new(rowSizer)
	
	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.NONE, 0)
	UILabel.new(columnSizer, "Set Offset", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)
    self.preview.buttons["setOffset"] = UIButton.new(columnSizer, "👁️", function() self:togglePreview("setOffset") end, nil, -1, -1, 25, -1) 
	self.preview.buttons["setOffset"]:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
	
    local gridSizer =  UIGridSizer.new(3, 2, 5, 5)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)

    UITextArea.new(gridSizer, "Side Offset (m)", TextAlignment.CENTER, true, false)
    self.uiOffsetSideOffset = UIFloatSlider.new(gridSizer, values.setOffset.sideOffset, -20.0, 20.0)

    UITextArea.new(gridSizer, "Height Offset (m)", TextAlignment.CENTER, true, false)
    self.uiOffsetHeightOffset = UIFloatSlider.new(gridSizer, values.setOffset.heightOffset, -20.0, 20.0)

    UILabel.new(gridSizer, "")
    UIButton.new(gridSizer, "Apply Offset", function() self:setSplineOffset() end) :setBackgroundColor(0.6, 1.0, 0.55, 1.0)

    ----------------------------------------------------------------
    -- SET TERRAIN HEIGHT
    ----------------------------------------------------------------
	UIHorizontalLine.new(rowSizer)
	
	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.NONE, 0)
	UILabel.new(columnSizer, "Set Terrain Height", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)
    self.preview.buttons["setTerrainHeight"] = UIButton.new(columnSizer, "👁️", function() self:togglePreview("setTerrainHeight") end, nil, -1, -1, 25, -1) 
	self.preview.buttons["setTerrainHeight"]:setBackgroundColor(0.9, 0.5, 0.5, 1.0)

    local gridSizer =  UIGridSizer.new(4, 2, 5, 5)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)

    UITextArea.new(gridSizer, "Height Offset (m)", TextAlignment.CENTER, true, false)
    self.uiTerrainHeightHeightOffset = UIFloatSlider.new(gridSizer, values.setTerrainHeight.terrainHeight, -25.0, 25.0)

    UITextArea.new(gridSizer, "Width (m)", TextAlignment.CENTER, true, false)
    self.uiTerrainHeightWidth = UIFloatSlider.new(gridSizer, values.setTerrainHeight.terrainWidth, 0.1, 25.0)

    UITextArea.new(gridSizer, "Smooth Distance", TextAlignment.CENTER, true, false)
    self.uiTerrainHeightSmoothDist = UIFloatSlider.new(gridSizer, values.setTerrainHeight.smoothDistance, 0.0, 25.0)

    UILabel.new(gridSizer, "")
    UIButton.new(gridSizer, "Generate", function()
        self:setTerrainHeight(self.uiTerrainHeightHeightOffset:getValue(), (self.uiTerrainHeightWidth:getValue() / 2), self.uiTerrainHeightSmoothDist:getValue())
    end) :setBackgroundColor(0.6, 1.0, 0.55, 1.0)
    ----------------------------------------------------------------
    -- PAINT TERRAIN
    ----------------------------------------------------------------
	UIHorizontalLine.new(rowSizer)
	
	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.NONE, 0)
	UILabel.new(columnSizer, "Paint Terrain", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)
    self.preview.buttons["paintTerrain"] = UIButton.new(columnSizer, "👁️", function() self:togglePreview("paintTerrain") end, nil, -1, -1, 25, -1) 
	self.preview.buttons["paintTerrain"]:setBackgroundColor(0.9, 0.5, 0.5, 1.0)

    local gridSizer =  UIGridSizer.new(4, 2, 5, 5)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
    
	UITextArea.new(gridSizer, "Terrain Layer", TextAlignment.CENTER, true, false)
	self.uiPaintTerrainLayer = UIChoice.new(gridSizer, values.paintTerrain.textureLayers, 0, -1, -1, 50)
	
	UITextArea.new(gridSizer, "Width Total (m)", TextAlignment.CENTER, true, false)
    self.uiPaintWidth = UIFloatSlider.new(gridSizer, values.paintTerrain.widthLeft + values.paintTerrain.widthRight, 0.1, 50.0)
	
	UITextArea.new(gridSizer, "Width Left/Right (m)", TextAlignment.CENTER, true, false)
    local gridSizer2 =  UIGridSizer.new(1, 2, 5, 5)
    UIPanel.new(gridSizer, gridSizer2, -1, -1, -1, -1, BorderDirection.NONE, 0)
    self.uiPaintWidthLeft = UIFloatSlider.new(gridSizer2, values.paintTerrain.widthLeft, 0.01, 25.0)
    self.uiPaintWidthRight = UIFloatSlider.new(gridSizer2, values.paintTerrain.widthRight, 0.01, 25.0)
	
	self.uiPaintWidth:setOnChangeCallback(function() self:onChangePaintWidth("total") end)
	self.uiPaintWidthLeft:setOnChangeCallback(function() self:onChangePaintWidth("left") end)
	self.uiPaintWidthRight:setOnChangeCallback(function() self:onChangePaintWidth("right") end)
    
	UILabel.new(gridSizer, "")
    UIButton.new(gridSizer, "Paint Terrain", function() self:paintTerrainBySpline() end) :setBackgroundColor(0.6, 1.0, 0.55, 1.0)
    ----------------------------------------------------------------
    -- PAINT TERRAIN
    ----------------------------------------------------------------
	UIHorizontalLine.new(rowSizer)
	
	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.NONE, 0)
	UILabel.new(columnSizer, "Set Foliage", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)
    self.preview.buttons["setFoliage"] = UIButton.new(columnSizer, "👁️", function() self:togglePreview("setFoliage") end, nil, -1, -1, 25, -1) 
	self.preview.buttons["setFoliage"]:setBackgroundColor(0.9, 0.5, 0.5, 1.0)

    local gridSizer =  UIGridSizer.new(4, 2, 5, 5)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
    
	UITextArea.new(gridSizer, "Foliage Layer", TextAlignment.CENTER, true, false)
	self.uiFoliageLayer = UIChoice.new(gridSizer, self.foliageLayers.options, 0, -1, -1, 50)
	self.uiFoliageLayer:setOnChangeCallback(function(idx)
		local states = self.foliageLayers.states[idx] or {}
		self.uiFoliageLayerState:setChoices(states, 0)
	end)
    
	UITextArea.new(gridSizer, "Layer State", TextAlignment.CENTER, true, false)
	self.uiFoliageLayerState = UIChoice.new(gridSizer, self.foliageLayers.states[1], 0, -1, -1, 50)
	self.uiFoliageLayerState:setChoices(self.foliageLayers.states[1], 0)
	
	UITextArea.new(gridSizer, "Width Total (m)", TextAlignment.CENTER, true, false)
    self.uiFoliageWidth = UIFloatSlider.new(gridSizer, values.setFoliage.widthLeft + values.setFoliage.widthRight, 0.1, 50.0)
	
	UITextArea.new(gridSizer, "Width Left/Right (m)", TextAlignment.CENTER, true, false)
    local gridSizer2 =  UIGridSizer.new(1, 2, 5, 5)
    UIPanel.new(gridSizer, gridSizer2, -1, -1, -1, -1, BorderDirection.NONE, 0)
    self.uiFoliageWidthLeft = UIFloatSlider.new(gridSizer2, values.setFoliage.widthLeft, 0.01, 25.0)
    self.uiFoliageWidthRight = UIFloatSlider.new(gridSizer2, values.setFoliage.widthRight, 0.01, 25.0)
	
	self.uiFoliageWidth:setOnChangeCallback(function() self:onChangeFoliageWidth("total") end)
	self.uiFoliageWidthLeft:setOnChangeCallback(function() self:onChangeFoliageWidth("left") end)
	self.uiFoliageWidthRight:setOnChangeCallback(function() self:onChangeFoliageWidth("right") end)
    
    UIButton.new(gridSizer, "Clear Foliage", function() self:setFoliageBySpline(true) end) :setBackgroundColor(1.0, 0.9, 0.53, 1.0)
    UIButton.new(gridSizer, "Set Foliage", function() self:setFoliageBySpline(false) end) :setBackgroundColor(0.6, 1.0, 0.55, 1.0)
    ----------------------------------------------------------------
    -- CUT SPLINE BETWEEN POINTS
    ----------------------------------------------------------------
	UIHorizontalLine.new(rowSizer)
	
	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.NONE, 0)
	UILabel.new(columnSizer, "Resample Spline", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)
    self.preview.buttons["resampleSpline"] = UIButton.new(columnSizer, "👁️", function() self:togglePreview("resampleSpline") end, nil, -1, -1, 25, -1) 
	self.preview.buttons["resampleSpline"]:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
	
    local gridSizer =  UIGridSizer.new(2, 2, 5, 5)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	
	UITextArea.new(gridSizer, "Number of Points", TextAlignment.CENTER, true, false)
    self.uiNumOfPoints = UIIntSlider.new(gridSizer, values.resampleSpline.numPoints, 2, 100)
	
	UILabel.new(gridSizer, "")
    UIButton.new(gridSizer, "Resample Spline", function() self:resampleSpline() end) :setBackgroundColor(0.6, 1.0, 0.55, 1.0)
end

function SplineToolkit:genPlaceObjectUI()
	local values = self.values.objectPlacement
	
    self.uiPlaceObjectInnerRowSizer = UIRowLayoutSizer.new()
	self.uiPlaceObjectPanel = UIPanel.new(self.uiPlaceObjectRowSizer, self.uiPlaceObjectInnerRowSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	table.insert(self.panels, self.uiPlaceObjectPanel)

	local gridSizer = UIGridSizer.new(1, 2, 5, 5)
	UIPanel.new(self.uiPlaceObjectInnerRowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	UIButton.new(gridSizer, "Create Transformgroup", function() self:getOrCreatePlaceObjectsTransformgroups() end) :setBackgroundColor(1.0, 0.9, 0.53, 1.0)
	
    local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(gridSizer, columnSizer)
	UILabel.new(columnSizer, "", false, TextAlignment.LEFT, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.NONE, 0, 1)
    self.preview.buttons["placeObject"] = UIButton.new(columnSizer, "👁️", function() self:togglePreview("placeObject") end, nil, -1, -1, 25, -1) 
	self.preview.buttons["placeObject"]:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
	self.preview.buttons["placeObject"]:setVisible(false)
	
	UIHorizontalLine.new(self.uiPlaceObjectInnerRowSizer)
	
    local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(self.uiPlaceObjectInnerRowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
    self.uiPlaceObjectModeGroup = self:createRadioButtonGroup(columnSizer, {
        { label = "Straight", callback = function() self:onPlaceObjectModeChanged() end },
        { label = "Area", callback = function() self:onPlaceObjectModeChanged() end },
    }, self.values.objectPlacement.activeModeIndex or 1)
	
	UIHorizontalLine.new(self.uiPlaceObjectInnerRowSizer)
end

function SplineToolkit:onPlaceObjectModeChanged()
	local activeIndex = self.uiPlaceObjectModeGroup and self.uiPlaceObjectModeGroup:getActiveIndex() or 1
	local isArea = (activeIndex == 2)
	local wasArea = (self.placeObjectLastMode == "area")
	
	self:saveSettings(self.currentTab)
	
	self.values.objectPlacement.activeModeIndex = self.uiPlaceObjectModeGroup:getActiveIndex()

	self:loadSettings(self.currentTab)

	if isArea ~= wasArea then
		self:buildPlaceObjectSettingsUI()
	end
end

function SplineToolkit:buildPlaceObjectSettingsUI()
	
	self:onDeleteSubPanels()
	
	self.placeObjectMode = self.uiPlaceObjectModeGroup:getActiveIndex()

	if self.placeObjectMode == 2 then
		self.placeObjectLastMode = "area"
		self.preview.buttons["placeObject"]:setVisible(true)
		self:genPlaceObjectOnAreaUI()
	else
		self.placeObjectLastMode = "spline"
		self:disableAllPreviews()
		self.preview.buttons["placeObject"]:setVisible(false)
		self:genPlaceObjectOnSplineUI()
	end

	self.window:refresh()
	self.window:fit()
end

function SplineToolkit:genPlaceObjectOnSplineUI()
	local values = self.values.objectPlacement

    local rowSizer = UIRowLayoutSizer.new()
	self.uiPlaceObjectSettingsPanel = UIPanel.new(self.uiPlaceObjectInnerRowSizer, rowSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	table.insert(self.subPanels, self.uiPlaceObjectSettingsPanel)
	
	local gridSizer = UIGridSizer.new(1, 2, 5, 5)
	UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	UITextArea.new(gridSizer, "Placetype", TextAlignment.LEFT, true, false)
	self.uiObjectPlaceType = UIChoice.new(gridSizer, {"Sequential", "Random"}, 0)
	
	UITextArea.new(gridSizer, "Offset (m)", TextAlignment.LEFT, true, false)
	self.uiPlaceOffsetSide = UIFloatSlider.new(gridSizer, values.sideOffset, -50.0, 50.0)

	UIHorizontalLine.new(rowSizer)

	local gridSizer = UIGridSizer.new(2, 2, 5, 5)
	UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	UITextArea.new(gridSizer, "Object Distance Type", TextAlignment.LEFT, true, false)
	self.uiObjectDistanceType = UIChoice.new(gridSizer, values.objDistanceType, 0)
	self.uiObjectDistanceType:setOnChangeCallback(function(state)
		self:setPlaceObjectDistanceType(state)
	end)

	UITextArea.new(gridSizer, "Distance Fix (m)", TextAlignment.LEFT, true, false)
	self.uiObjectFixDistance = UIFloatSlider.new(gridSizer, values.objectFixDistance, 0.1, 100.0)

	UITextArea.new(gridSizer, "Distance Min/Max (m)", TextAlignment.LEFT, true, false)
    local gridSizer2 =  UIGridSizer.new(1, 2, 5, 5)
    UIPanel.new(gridSizer, gridSizer2, -1, -1, -1, -1, BorderDirection.NONE, 0)
	self.uiObjectMinDistance = UIFloatSlider.new(gridSizer2, values.objectMinDistance, 0.1, 100.0)
	self.uiObjectMaxDistance = UIFloatSlider.new(gridSizer2, values.objectMaxDistance, 0.1, 100.0)
	self:clampMinMaxSlider(self.uiObjectMinDistance, self.uiObjectMaxDistance, 0.1)

	UIHorizontalLine.new(rowSizer)

	local gridSizer = UIGridSizer.new(2, 2, 5, 5)
	UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)

	UITextArea.new(gridSizer, "Set Height Type", TextAlignment.LEFT, true, false)
	self.uiSetHeightType = UIChoice.new(gridSizer, values.setHeightType, 0)
	self.uiSetHeightType:setOnChangeCallback(function()
		self:setPlaceObjectHeightType()
	end)

	UITextArea.new(gridSizer, "Height (Trans. Y)", TextAlignment.LEFT, true, false)
	self.uiObjectHeight = UIFloatSlider.new(gridSizer, values.objectHeight, -100.0, 100.0)

	UIHorizontalLine.new(rowSizer)

	local gridSizer = UIGridSizer.new(2, 2, 5, 5)
	UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)

	UITextArea.new(gridSizer, "Random Rotate", TextAlignment.LEFT, true, false)
	self.uiRandomRotate = UIChoice.new(gridSizer, values.setRandomRotate, 0)
	self.uiRandomRotate:setOnChangeCallback(function()
		self:setPlaceObjectRotateType()
	end)

	UITextArea.new(gridSizer, "Object Rotate", TextAlignment.LEFT, true, false)
	self.uiObjectRotate = UIFloatSlider.new(gridSizer, values.objectRotate, -180.0, 180.0)
	
	self.uiBtnPlaceObjects = UIButton.new(rowSizer, "Generate", function() self:generateObjectsOnSpline() end, nil, -1, -1, -1, 25)
	self.uiBtnPlaceObjects:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
	self:updateChoicesFromSettings(self.currentTab)
end

function SplineToolkit:genPlaceObjectOnAreaUI()
	local values = self.values.objectPlacement

	local rowSizer = UIRowLayoutSizer.new()
	self.uiPlaceObjectSettingsPanel = UIPanel.new(self.uiPlaceObjectInnerRowSizer,  rowSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	table.insert(self.subPanels, self.uiPlaceObjectSettingsPanel)
	
	local gridSizer = UIGridSizer.new(2, 2, 5, 5)
	UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	UITextArea.new(gridSizer, "min. distance between Objects", TextAlignment.LEFT, true, false)
	self.uiAreaMinDist = UIFloatSlider.new(gridSizer, values.areaMinDistBetween, 0.1, 25.0)
	UITextArea.new(gridSizer, "max. distance between Objects", TextAlignment.LEFT, true, false)
	self.uiAreaMaxDist = UIFloatSlider.new(gridSizer, values.areaMaxDistBetween, 0.1, 25.0)
	self:clampMinMaxSlider(self.uiAreaMinDist, self.uiAreaMaxDist, 0.1)

	UIHorizontalLine.new(rowSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	
	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	
	local rowInColumnSizer = UIRowLayoutSizer.new()
	UIPanel.new(columnSizer, rowInColumnSizer, -1, -1, -1, -1, BorderDirection.RIGHT, 3, 1)
	UITextArea.new(rowInColumnSizer, "Left", TextAlignment.CENTER, true, false, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	self.uiAreaLeftEnabled = UIChoice.new(rowInColumnSizer, {"Enable", "Disable"}, 0, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	self.uiAreaWidthLeft = UIFloatSlider.new(rowInColumnSizer, values.areaWidthLeft, 0.01, 30.0, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

	local verticalLineSizer = UIRowLayoutSizer.new()
	UIPanel.new(columnSizer, verticalLineSizer, -1, -1, -1, -1, BorderDirection.RIGHT, 3)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
		
	local rowInColumnSizer = UIRowLayoutSizer.new()
	UIPanel.new(columnSizer, rowInColumnSizer, -1, -1, -1, -1, BorderDirection.RIGHT, 3, 1)
	UITextArea.new(rowInColumnSizer, "Center", TextAlignment.CENTER, true, false, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	self.uiAreaCenterEnabled = UIChoice.new(rowInColumnSizer, {"Enable", "Disable"}, 0, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	self.uiAreaWidthCenter = UIFloatSlider.new(rowInColumnSizer, values.areaWidthCenter, 0.01, 30.0, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

	local verticalLineSizer = UIRowLayoutSizer.new()
	UIPanel.new(columnSizer, verticalLineSizer, -1, -1, -1, -1, BorderDirection.RIGHT, 3)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
	UILabel.new(verticalLineSizer, "|"):setTextColor(0.6,0.6,0.6,1)
	
	local rowInColumnSizer = UIRowLayoutSizer.new()
	UIPanel.new(columnSizer, rowInColumnSizer,  -1, -1, -1, -1, BorderDirection.NONE, 0, 1)
	UITextArea.new(rowInColumnSizer, "Right", TextAlignment.CENTER, true, false, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	self.uiAreaRightEnabled = UIChoice.new(rowInColumnSizer, {"Enable", "Disable"}, 0, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	self.uiAreaWidthRight = UIFloatSlider.new(rowInColumnSizer, values.areaWidthRight, 0.01, 30.0, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	
	self.uiBtnPlaceObjects = UIButton.new(rowSizer, "Generate", function() self:generateObjectsOnSpline() end, nil, -1, -1, -1, 25)
	self.uiBtnPlaceObjects:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
	self:updateChoicesFromSettings(self.currentTab)
end

function SplineToolkit:genPlaceFenceUI()
	local values = self.values.fencePlacement
	
    self.uiPlaceFenceInnerRowSizer = UIRowLayoutSizer.new()
	self.uiPlaceFencePanel = UIPanel.new(self.uiPlaceFenceRowSizer, self.uiPlaceFenceInnerRowSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	table.insert(self.panels, self.uiPlaceFencePanel)
	
	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(self.uiPlaceFenceInnerRowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	UILabel.new(columnSizer, "Image Path:",  false, TextAlignment.LEFT, VerticalAlignment.CENTER, -1, -1, 70, -1, BorderDirection.RIGHT, 5)
	self.uiImgFencePath = UITextArea.new(columnSizer, values.imgPath, TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.RIGHT, 5, 1)
	self.uiImgFencePath:setToolTip(values.imgPath)
	self.uiImgFencePath:setOnFocusLostCallback(function() self:saveSettings(self.currentTab) end)
	UIButton.new(columnSizer, "🗁", function() self:onSelectFenceImgFolder() end, nil, -1, -1, 25, -1, BorderDirection.RIGHT, 5)

	UIHorizontalLine.new(self.uiPlaceFenceInnerRowSizer)
	
    local columnSizer = UIColumnLayoutSizer.new()
    UIPanel.new(self.uiPlaceFenceInnerRowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	
    local iconPanelSizer = UIRowLayoutSizer.new()
    UIPanel.new(columnSizer, iconPanelSizer, -1, -1, -1, -1, BorderDirection.RIGHT, 5)
	
	self.uiFenceIcon = UIButton.new(iconPanelSizer, "", function() end, nil, -1, -1, 185, 185)
    local rightPanelSizer = UIRowLayoutSizer.new()
    UIPanel.new(columnSizer, rightPanelSizer, -1, -1, -1, -1, BorderDirection.NONE, 5, 1)
	
	self.uiListFence = UIList.new(rightPanelSizer, -1, -1, -1, 158, BorderDirection.BOTTOM, 5)
    self.uiListFence:setOnChangeCallback(function(index) self:setFenceListItemCallback(index+1) end)
	
    local columnSizer2 = UIColumnLayoutSizer.new()
    UIPanel.new(rightPanelSizer, columnSizer2, -1, -1, -1, -1, BorderDirection.NONE, 0, -1)
	
	self.uiFenceAdd = UIButton.new(columnSizer2, "Add", function() self:onFenceAddBtn() end, nil, -1, -1, 20, 20, BorderDirection.NONE, 0, 1)
	self.uiFenceEdit = UIButton.new(columnSizer2, "Edit", function() self:onFenceEditBtn() end, nil, -1, -1, 20, 20, BorderDirection.NONE, 0, 1)
	self.uiiFenceDel = UIButton.new(columnSizer2, "Delete", function() self:onFenceDelBtn() end, nil, -1, -1, 20, 20, BorderDirection.NONE, 0, 1)
	self.uiFenceAdd:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
	self.uiFenceEdit:setBackgroundColor(1.0, 0.9, 0.53, 1.0)
	self.uiiFenceDel:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
	
	UIHorizontalLine.new(self.uiPlaceFenceInnerRowSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

    local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(self.uiPlaceFenceInnerRowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
    self.uiSplineModeGroup = self:createRadioButtonGroup(columnSizer, {
        { label = "Copy Spline to new fenceGroup" },
        { label = "Move Spline to new fenceGroup" },
    }, 1)
	
	UIHorizontalLine.new(self.uiPlaceFenceInnerRowSizer)

	local gridSizer = UIGridSizer.new(3, 2, 5, 5)
	UIPanel.new(self.uiPlaceFenceInnerRowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	
	UITextArea.new(gridSizer, "Use Y Offset", TextAlignment.LEFT, true, false)
	self.uiFencePlaceYOffset = UIChoice.new(gridSizer, values.useYOffset, 0)
	
	UITextArea.new(gridSizer, "Place Start Pole", TextAlignment.LEFT, true, false)
	self.uiFencePlaceStartPole = UIChoice.new(gridSizer, values.placeStartPole, 0)
	
	UITextArea.new(gridSizer, "Place End Pole", TextAlignment.LEFT, true, false)
	self.uiFencePlaceEndPole = UIChoice.new(gridSizer, values.placeEndPole, 0)
	
    local rowSizer = UIRowLayoutSizer.new()
    UIPanel.new(self.uiPlaceFenceInnerRowSizer, rowSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1)
	
	self.uiBtnPlaceFence = UIButton.new(rowSizer, "Generate", function() self:generateFenceOnSpline() end, nil, -1, -1, -1, 30)
	self.uiBtnPlaceFence:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
	
	UIHorizontalLine.new(self.uiPlaceFenceInnerRowSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

	local gridSizer = UIGridSizer.new(1, 3, 5, 5)
	UIPanel.new(self.uiPlaceFenceInnerRowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	
	UITextArea.new(gridSizer, "Import Gate", TextAlignment.LEFT, true, false)
	self.uiFenceGateChoice = UIChoice.new(gridSizer, values.fenceGateChoice, 0)
	self.uiBtnPlaceGate = UIButton.new(gridSizer, "Import", function() self:importFenceGate(self.uiFenceGateChoice:getValue()) end)
	self.uiBtnPlaceGate:setBackgroundColor(1.0, 0.9, 0.53, 1.0)
	self.uiBtnPlaceGate:setEnabled(false)
	
	-- Permanenter Wrapper für Gate Options — bleibt immer am Ende der Fence UI.
	-- Gate-Inhalte werden als Kind dieses Wrappers erstellt/zerstört.
	-- Ghosts akkumulieren im uiGateWrapperSizer (haben 0-Höhe) → uiPlaceFenceInnerRowSizer bleibt sauber.
	self.uiGateWrapperSizer = UIRowLayoutSizer.new()
	self.uiGateWrapperPanel = UIPanel.new(self.uiPlaceFenceInnerRowSizer, self.uiGateWrapperSizer, -1, -1, -1, -1, BorderDirection.NONE, 0)
	self.uiGateContentPanel = nil

end

function SplineToolkit:genPlaceFenceGateOptionsUI()
	local values = self.values.fencePlacement

	local rowSizer = UIRowLayoutSizer.new()
	self.uiPlaceFenceGateOptionsPanel = UIPanel.new(self.uiPlaceFenceInnerRowSizer, rowSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	table.insert(self.subPanels, self.uiPlaceFenceGateOptionsPanel)

	UIHorizontalLine.new(rowSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 2)
	UILabel.new(rowSizer, "Gate Options", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)

	local gridSizer = UIGridSizer.new(2, 1, 5, 5)
	UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	UITextArea.new(gridSizer, "Gate Position (%)", TextAlignment.CENTER, true, false)
	self.uiGatePositionSlider = UIFloatSlider.new(gridSizer, 0.0, 0.0, 100.0)
	self.uiGatePositionSlider:setOnChangeCallback(function() self:onGatePositionSliderChanged() end)

	UIHorizontalLine.new(rowSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 2)
	UILabel.new(rowSizer, "Animation", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)

	local btnStateText, btnStateColor = self:checkGateAnimState()
	UIButton.new(rowSizer, string.format(btnStateText), function() end, nil, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBackgroundColor(btnStateColor[1], btnStateColor[2], btnStateColor[3], 1.0)

	local gateXmlPreview = self:getGateAnimationXmlString() or ""
	UITextArea.new(rowSizer, gateXmlPreview, TextAlignment.LEFT, false, true, -1, -1, -1, 150, BorderDirection.BOTTOM, 5)

	UIButton.new(rowSizer, "Show XML", function() self:onClickOpenAnimationXMLFileViewer() end, nil, -1, -1, -1, -1, BorderDirection.BOTTOM, 5):setBackgroundColor(0.3, 0.7, 0.95, 1.0)

	self.window:fit()
	self.window:refresh()
end

function SplineToolkit:genExportUI()
	local values = self.values.exportObject

    local rowMainSizer = UIRowLayoutSizer.new()
    self.uiExportPanel = UIPanel.new(self.uiExportRowSizer, rowMainSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	table.insert(self.panels, self.uiExportPanel)

	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowMainSizer, columnSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1)
	UILabel.new(columnSizer, "Export Path",  false, TextAlignment.LEFT, VerticalAlignment.CENTER, -1, -1, 110, -1, BorderDirection.RIGHT, 5)
	self.uiExportOBJPath = UITextArea.new(columnSizer, values.exportPath, TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.RIGHT, 5, 1)
	self.uiExportOBJPath:setToolTip(values.exportPath)
	self.uiExportOBJPath:setOnFocusLostCallback(function() self:saveSettings(self.currentTab) end)
	UIButton.new(columnSizer, "🗁", function() self:onSelectExportFolder(values.exportPath, self.uiExportOBJPath) end, nil, -1, -1, 25, -1, BorderDirection.RIGHT, 5)
	
    local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowMainSizer, columnSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 0)
		
    self.uiExportUseCustomFilename = UICheckBox.new(columnSizer, "Custom Filename:", -1, -1, 110, -1, BorderDirection.RIGHT, 5)
	self.uiExportUseCustomFilename:setValue(values.useCustomFilename)
	self.uiExportUseCustomFilename:setOnChangeCallback(function()
		self:setUseCustomFilename()
	end)
    self.uiExportCustomFilename = UITextArea.new(columnSizer, "", TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.RIGHT, 2, 1)	
	self.uiExportCustomFilename:setOnFocusLostCallback(function()
		values.customFileName = self.uiExportCustomFilename:getValue()
	end)
	UILabel.new(columnSizer, ".obj", false, TextAlignment.LEFT, VerticalAlignment.CENTER, -1, -1, 27, -1, BorderDirection.RIGHT, 5)
	
    local rowSizer = UIRowLayoutSizer.new()
	UIPanel.new(rowMainSizer, rowSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	UIHorizontalLine.new(rowSizer)
	
	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.NONE, 0)
	UILabel.new(columnSizer, "Export Settings:", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)
    self.preview.buttons["export"] = UIButton.new(columnSizer, "👁️", function() self:togglePreview("export") end, nil, -1, -1, 25, -1) 
	self.preview.buttons["export"]:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
	
    local gridSizer = UIGridSizer.new(5, 2, 5, 5)
	UIPanel.new(rowMainSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)

    UITextArea.new(gridSizer, "Type", TextAlignment.CENTER, true, false)
    self.uiExportType = UIChoice.new(gridSizer, values.createMeshType, 0)
	self.uiExportType:setOnChangeCallback(function()
		self:setExportChoice()
	end)

    UITextArea.new(gridSizer, "Distance Type", TextAlignment.CENTER, true, false)
    self.uiExportDistanceType = UIChoice.new(gridSizer, values.distanceType, 0)
	self.uiExportDistanceType:setOnChangeCallback(function()
		self:setExportChoice()
	end)
	
    UITextArea.new(gridSizer, "Distance", TextAlignment.CENTER, true, false)
    self.uiExportDistance = UIFloatSlider.new(gridSizer, values.vertexDistance, 0.01, 20.0)
	
    UITextArea.new(gridSizer, "Min Distance", TextAlignment.CENTER, true, false)
    self.uiExportMinDistance = UIFloatSlider.new(gridSizer, values.vertexMinDistance, 0.01, 20.0)

    UITextArea.new(gridSizer, "Min Angle", TextAlignment.CENTER, true, false)
    self.uiExportMinAngle = UIFloatSlider.new(gridSizer, values.vertexMinAngle, 0.01, 90.0)

    -- UILabel.new(gridSizer, "")
    self.uiBtnExportOBJ = UIButton.new(self.uiExportRowSizer, "Create", function() self:exportSplineToObj() end) 
	self.uiBtnExportOBJ:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
	table.insert(self.panels, self.uiBtnExportOBJ)
end

function SplineToolkit:genRoadUI()
	local values = self.values.roadMesh
	
    local rowMainSizer = UIRowLayoutSizer.new()
	self.uiPanelRoad = UIPanel.new(self.uiRoadRowSizer, rowMainSizer, -1, -1, -1, 650, BorderDirection.ALL, 10)
	table.insert(self.panels, self.uiPanelRoad)

	local columnPathSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowMainSizer, columnPathSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	UILabel.new(columnPathSizer, "Export Path",  false, TextAlignment.CENTER, VerticalAlignment.CENTER, -1, -1, 75, -1, BorderDirection.RIGHT, 5):setBold(true)
	self.uiExportStreetPath = UITextArea.new(columnPathSizer, values.exportPath, TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.RIGHT, 5, 1)
	self.uiExportStreetPath:setToolTip(values.exportPath)
	self.uiExportStreetPath:setOnFocusLostCallback(function() self:saveSettings(self.currentTab) end)
	UIButton.new(columnPathSizer, "🗁", function() self:onSelectExportFolder(values.exportPath, self.uiExportStreetPath) end, nil, -1, -1, 25, -1, BorderDirection.RIGHT, 5)
	
    local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowMainSizer, columnSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	UILabel.new(columnSizer, "Road Name", false, TextAlignment.CENTER, VerticalAlignment.CENTER, -1, -1, 75, -1, BorderDirection.RIGHT, 5):setBold(true)
    self.uiRoadName = UITextArea.new(columnSizer, values.roadName, TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.NONE, 0, 1)
	
	
	UIHorizontalLine.new(rowMainSizer, -1, -1, -1, 5)

    local rowSizer = UIRowLayoutSizer.new()
	UIPanel.new(rowMainSizer, rowSizer, -1, -1, -1, -1, BorderDirection.NONE, 0, -1, true)
	
	-----------------------------------------------------------
	-- TEXTURE SETTINGS

	UILabel.new(rowSizer, "", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1)
	UILabel.new(rowSizer, "TEXTURE SETTINGS", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)
	
    local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

    UITextArea.new(columnSizer, "Road IMG Path:", TextAlignment.LEFT, true, false, -1, -1, -1, -1, BorderDirection.LEFT, 5)
    self.uiImgRoadPath = UITextArea.new(columnSizer, values.imgPath, TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.RIGHT, 5, 1)
    self.uiImgRoadPath:setToolTip(values.imgPath)
    self.uiImgRoadPath:setOnFocusLostCallback(function() self:saveSettings(self.currentTab) end)
    UIButton.new(columnSizer, "🗁", function() self:onSelectRoadImgFolder() end, nil, -1, -1, 25, -1, BorderDirection.RIGHT, 5)
	
    local columnSizer = UIColumnLayoutSizer.new()
    UIPanel.new(rowSizer, columnSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	
    local iconPanelSizer = UIRowLayoutSizer.new()
    UIPanel.new(columnSizer, iconPanelSizer, -1, -1, -1, -1, BorderDirection.RIGHT, 5)
	
	self.uiRoadIcon = UIButton.new(iconPanelSizer, "", function() end, nil, -1, -1, 190, 190)
	
    local rightPanelSizer = UIRowLayoutSizer.new()
    UIPanel.new(columnSizer, rightPanelSizer, -1, -1, -1, -1, BorderDirection.NONE, 5, -1)
	
	self.uiListRoad = UIList.new(rightPanelSizer, -1, -1, -1, 158, BorderDirection.BOTTOM, 5)
    self.uiListRoad:setOnChangeCallback(function(index) self:setRoadTextureListItemCallback(index+1) end)
	
    local columnSizer2 = UIColumnLayoutSizer.new()
    UIPanel.new(rightPanelSizer, columnSizer2, -1, -1, -1, -1, BorderDirection.NONE, 0, -1)
	
	self.uiRoadAdd = UIButton.new(columnSizer2, "Add", function() self:onRoadTextureAddBtn() end, nil, -1, -1, 20, 20, BorderDirection.BOTTOM, 5, 1)
	self.uiRoadEdit = UIButton.new(columnSizer2, "Edit", function() self:onRoadTextureEditBtn() end, nil, -1, -1, 20, 20, BorderDirection.BOTTOM, 5, 1)
	self.uiRoadDel = UIButton.new(columnSizer2, "Delete", function() self:onRoadTextureDelBtn() end, nil, -1, -1, 20, 20, BorderDirection.BOTTOM, 5, 1)
	self.uiRoadAdd:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
	self.uiRoadEdit:setBackgroundColor(1.0, 0.9, 0.53, 1.0)
	self.uiRoadDel:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
	UIHorizontalLine.new(rightPanelSizer)
	
    local gridSizer = UIGridSizer.new(1, 5, 2, 2)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
	self.uiRoadTextureHasDiffuse = UIButton.new(gridSizer, "Diffuse", function() end)
	self.uiRoadTextureHasSpecular = UIButton.new(gridSizer, "Specular", function() end)
	self.uiRoadTextureHasNormal = UIButton.new(gridSizer, "Normal", function() end)
	self.uiRoadTextureHasHeight = UIButton.new(gridSizer, "Height", function() end)
	self.uiRoadTextureHasAlpha = UIButton.new(gridSizer, "Alpha", function() end)
	
    local gridSizer = UIGridSizer.new(4, 2, 5, 5)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	
    UITextArea.new(gridSizer, "Mirror Texture at Center", TextAlignment.LEFT, true, false)
    self.uiMirrorAtCenter = UIChoice.new(gridSizer, values.mirrorAtCenter, 0)
	
    UITextArea.new(gridSizer, "Texture Distance (m)", TextAlignment.LEFT, true, false)
    self.uiTextureDistSlider = UIFloatSlider.new(gridSizer, values.textureDistance, 0.5, 25.0)
	
    UITextArea.new(gridSizer, "Slice Height Start (%)", TextAlignment.LEFT, true, false)
    self.uiTextureSliceStartSlider = UIFloatSlider.new(gridSizer, values.sliceStart, 0.0, 100.0)
	
    UITextArea.new(gridSizer, "Slice Height End (%)", TextAlignment.LEFT, true, false)
    self.uiTextureSliceEndSlider = UIFloatSlider.new(gridSizer, values.sliceEnd, 0.0, 100.0)
	
	-----------------------------------------------------------
	-- MESH SETTINGS
	
	UIHorizontalLine.new(rowSizer)
	UILabel.new(rowSizer, "MESH SETTINGS", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)
	
    local gridSizer = UIGridSizer.new(5, 2, 5, 5)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.ALL, 5)
	
    UITextArea.new(gridSizer, "Terrain Decal", TextAlignment.LEFT, true, false)
    self.uiTerrainDecal = UIChoice.new(gridSizer, values.terrainDecal, 0)
	
    UITextArea.new(gridSizer, "Street Width (m)", TextAlignment.LEFT, true, false)
    self.uiGenRoadWidthSlider = UIFloatSlider.new(gridSizer, values.width, 1.0, 20.0)
	
    UITextArea.new(gridSizer, "Min Segment Length (m)", TextAlignment.LEFT, true, false)
    self.uiGenRoadMinSegLenght = UIFloatSlider.new(gridSizer, values.minSegmentLength, 0.5, 10.0)
	
    UITextArea.new(gridSizer, "Min Angle (deg)", TextAlignment.LEFT, true, false)
    self.uiGenRoadMinAngle = UIFloatSlider.new(gridSizer, values.maxAngle, 0.1, 15.0)
	
    UITextArea.new(gridSizer, "Align Edges on Terrain", TextAlignment.LEFT, true, false)
    self.uiGenRoadAlignEdges = UIChoice.new(gridSizer, values.alignEdgesOnTerrain, 0)
	
	-----------------------------------------------------------
	-- TRAFFIC SETTINGS

	UIHorizontalLine.new(rowSizer)
	UILabel.new(rowSizer, "TRAFFIC SETTINGS", false, TextAlignment.CENTER, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1):setBold(true)
	
    local gridSizer = UIGridSizer.new(5, 3, 5, 5)
    UIPanel.new(rowSizer, gridSizer, -1, -1, -1, -1, BorderDirection.LEFT, 5)
	
    UITextArea.new(gridSizer, "Center", TextAlignment.LEFT, true, false)
    self.uiHasTrafficCenter = UIChoice.new(gridSizer, values.trafficCenter, 0)
	self.uiHasTrafficCenter:setOnChangeCallback(function()
		self:setRoadTrafficChoice()
	end)
    UILabel.new(gridSizer, "")
	
    UITextArea.new(gridSizer, "Left (%)", TextAlignment.LEFT, true, false)
    self.uiHasTrafficLeft = UIChoice.new(gridSizer, values.trafficLeft, 0)
	self.uiHasTrafficLeft:setOnChangeCallback(function()
		self:setRoadTrafficChoice()
	end)
    self.uiTrafficLeftPerc = UIFloatSlider.new(gridSizer, values.leftPercent, 0.0, 100.0)
	
    UITextArea.new(gridSizer, "Right (%)", TextAlignment.LEFT, true, false)
    self.uiHasTrafficRight = UIChoice.new(gridSizer, values.trafficRight, 0)
	self.uiHasTrafficRight:setOnChangeCallback(function()
		self:setRoadTrafficChoice()
	end)
    self.uiTrafficRightPerc = UIFloatSlider.new(gridSizer, values.rightPercent, 0.0, 100.0)
	
    UITextArea.new(gridSizer, "maxSpeedScale", TextAlignment.LEFT, true, false)
    self.uiMaxSpeedScale = UIIntSlider.new(gridSizer, values.maxSpeedScale, -20, 20)
    UILabel.new(gridSizer, "")
	
    UITextArea.new(gridSizer, "speedLimit", TextAlignment.LEFT, true, false)
    self.uiSpeedLimit = UIIntSlider.new(gridSizer, values.speedLimit, 0, 120)
    UILabel.new(gridSizer, "")

	-- UIHorizontalLine.new(rowMainSizer, -1, -1, -1, 5, BorderDirection.BOTTOM, 5)
	
	local columnSizer = UIColumnLayoutSizer.new()
	UIPanel.new(rowMainSizer, columnSizer, -1, -1, -1, -1, BorderDirection.NONE, 0)
    self.uiBtnGenRoad = UIButton.new(columnSizer, "Generate Street", function() self:generateRoad() end, nil, -1, -1, -1, 30, BorderDirection.NONE, 0, 1)
	self.uiBtnGenRoad:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
    self.preview.buttons["street"] = UIButton.new(columnSizer, "👁️", function() self:togglePreview("street") end, nil, -1, -1, 33, -1) 
	self.preview.buttons["street"]:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
end


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	UI FUNCTIONS		-////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-------------------------------------------------------------------------------------------------------------------------------------------------------
function SplineToolkit:validateExportPath(path)
    if path == nil or path == "" then
        printError("[SplineToolkit] Export path is empty.")
        return nil
    end

    path = path:gsub("\\", "/")
    if path:sub(-1) ~= "/" then
        path = path .. "/"
    end

    if not folderExists(path) then
        printError("[SplineToolkit] Export path does not exist: " .. path)
        return nil
    end

    return path
end

function SplineToolkit:onSelectExportFolder(tableKey, uiElement)
    local path = openDirDialog(tableKey)
    if path ~= nil and path ~= "" then
        path = path:gsub("\\", "/")
        if path:sub(-1) ~= "/" then
            path = path .. "/"
        end

        local validPath = self:validateExportPath(path)
        if not validPath then
            return
        end

        tableKey = validPath
        uiElement:setValue(validPath)
        uiElement:setToolTip(validPath)
        self:saveSettings(self.currentTab)
    end
end
-- ---------------------------------------------------------------
-- UI Functions - BASE
-- ---------------------------------------------------------------
function SplineToolkit:onChangePaintWidth(source)
    local left  = self.uiPaintWidthLeft:getValue()
    local right = self.uiPaintWidthRight:getValue()
    local total = self.uiPaintWidth:getValue()

    if source == "left" or source == "right" then
        local newTotal = left + right
        self.uiPaintWidth:setValue(newTotal)
    elseif source == "total" then
        local oldTotal = left + right

        if oldTotal <= 0.0001 then
            left = total * 0.5
            right = total * 0.5
        else
            local scale = total / oldTotal
            left  = left  * scale
            right = right * scale
        end

        self.uiPaintWidthLeft:setValue(left)
        self.uiPaintWidthRight:setValue(right)
    end
end

function SplineToolkit:onChangeFoliageWidth(source)
    local left  = self.uiFoliageWidthLeft:getValue()
    local right = self.uiFoliageWidthRight:getValue()
    local total = self.uiFoliageWidth:getValue()

    if source == "left" or source == "right" then
        local newTotal = left + right
        self.uiFoliageWidth:setValue(newTotal)
    elseif source == "total" then
        local oldTotal = left + right

        if oldTotal <= 0.0001 then
            left = total * 0.5
            right = total * 0.5
        else
            local scale = total / oldTotal
            left  = left  * scale
            right = right * scale
        end

        self.uiFoliageWidthLeft:setValue(left)
        self.uiFoliageWidthRight:setValue(right)
    end
end

function SplineToolkit:loadFoliageLayers()
    local foliage = self.foliageLayers
    foliage.options, foliage.states, foliage.channels, foliage.offsets = {}, {}, {}, {}

    local mapFile = getSceneFilename()
    local xml = loadXMLFile("map.i3d", mapFile)
    if xml == nil then
        printError("[SplineToolkit] Could not load map.i3d")
        return
    end

    local gamePath = getGameBasePath()
    local mapPath  = mapFile:match("(.*/)")
	
	local index = 1

    local foliageLayerPath = "i3D.Scene.TerrainTransformGroup.Layers.FoliageSystem.FoliageMultiLayer"
    local foliageStatePath = "foliageType.foliageLayer.foliageState"

    local function iter(handle, path, fn)
        local i = 0
        while true do
            local key = string.format("%s(%d)", path, i)
            if not hasXMLProperty(handle, key) then break end
            if fn(key, i) == false then break end
            i = i + 1
        end
    end

    iter(xml, foliageLayerPath, function(layerKey)
        iter(xml, layerKey .. ".FoliageType", function(typeKey)
            local name   = getXMLString(xml, typeKey .. "#name")
            local fileId = getXMLInt(xml, typeKey .. "#foliageXmlId")

            if name == nil or fileId == nil then return end

            foliage.options[index] = name
            foliage.states[index]  = {}

            local foliageXMLPath

            iter(xml, "i3D.Files.File", function(fileKey)
                if getXMLInt(xml, fileKey .. "#fileId") == fileId then
                    foliageXMLPath = getXMLString(xml, fileKey .. "#filename")
                    return false
                end
            end)

            if foliageXMLPath == nil then return end

            if foliageXMLPath:sub(1,5) == "$data" then
                foliageXMLPath = foliageXMLPath:gsub("$data", gamePath .. "data")
            else
                foliageXMLPath = mapPath .. foliageXMLPath
            end

            local foliageXML = loadXMLFile("foliage.xml", foliageXMLPath)
            if foliageXML == nil then return end

            foliage.channels[index] = getXMLInt(foliageXML, "foliageType.foliageLayer#numDensityMapChannels")
            foliage.offsets[index] = getXMLInt(foliageXML, "foliageType.foliageLayer#densityMapChannelOffset")

            local s = 1
            iter(foliageXML, foliageStatePath, function(stateKey)
                foliage.states[index][s] = getXMLString(foliageXML, stateKey .. "#name")
                s = s + 1
            end)

            delete(foliageXML)
            index = index + 1
        end)
    end)

    delete(xml)
end

-- ---------------------------------------------------------------
-- UI Functions - Place Objects
-- ---------------------------------------------------------------
function SplineToolkit:setPlaceObjecType()
	if not self.uiObjectPlaceType then return end
	if self.uiObjectPlaceType:getValue() == 1 then
		self.uiPlaceWidthTotal:setEnabled(false)
		self.uiPlaceWidthLeft:setEnabled(false)
		self.uiPlaceWidthRight:setEnabled(false)
	else
		self.uiPlaceWidthTotal:setEnabled(true)
		self.uiPlaceWidthLeft:setEnabled(true)
		self.uiPlaceWidthRight:setEnabled(true)
	end
end

function SplineToolkit:setPlaceObjectDistanceType()
	if not self.uiObjectDistanceType then return end
	if self.uiObjectDistanceType:getValue() == 1 then
		self.uiObjectFixDistance:setEnabled(true)
		self.uiObjectMinDistance:setEnabled(false)
		self.uiObjectMaxDistance:setEnabled(false)
	elseif self.uiObjectDistanceType:getValue() == 2 then
		self.uiObjectFixDistance:setEnabled(false)
		self.uiObjectMinDistance:setEnabled(true)
		self.uiObjectMaxDistance:setEnabled(true)
	end
end

function SplineToolkit:setPlaceObjectHeightType()
	if not self.uiSetHeightType then return end
	if self.uiSetHeightType:getValue() == 6 then
		self.uiObjectHeight:setEnabled(true)
	else
		self.uiObjectHeight:setEnabled(false)
	end
end

function SplineToolkit:setPlaceObjectRotateType()
	if not self.uiRandomRotate then return end
	if self.uiRandomRotate:getValue() == 1 then
		self.uiObjectRotate:setEnabled(true)
	else
		self.uiObjectRotate:setEnabled(false)
	end
end

function SplineToolkit:onChangePlaceObjectWidth(source)
    local left  = self.uiPlaceWidthLeft:getValue()
    local right = self.uiPlaceWidthRight:getValue()
    local total = self.uiPlaceWidthTotal:getValue()

    if source == "left" or source == "right" then
        local newTotal = left + right
        self.uiPlaceWidthTotal:setValue(newTotal)
    elseif source == "total" then
        local oldTotal = left + right

        if oldTotal <= 0.0001 then
            left = total * 0.5
            right = total * 0.5
        else
            local scale = total / oldTotal
            left  = left  * scale
            right = right * scale
        end

        self.uiPlaceWidthLeft:setValue(left)
        self.uiPlaceWidthRight:setValue(right)
    end
end

-- ---------------------------------------------------------------
-- UI Functions - Place Fence
-- ---------------------------------------------------------------
function SplineToolkit:onSelectFenceImgFolder()
	local values = self.values.fencePlacement
    local path = openDirDialog(values.imgPath)
    if path ~= nil and path ~= "" then
        path = string.gsub(path, "\\", "/")
        if string.sub(path, -1) ~= "/" then
            path = path .. "/"
        end
        values.imgPath = path
        self.uiImgFencePath:setValue(values.imgPath)
		self.uiImgFencePath:setToolTip(values.imgPath)
        self:saveSettings()
    end
end

function SplineToolkit:setFenceImage(img)
	local values = self.values.fencePlacement
	
	local function validatePath(path)
		if not path or path == "" then
			return nil
		end

		path = string.gsub(path, "^%s*(.-)%s*$", "%1")

		local fileName = string.match(path, "([^/\\]+)$")

		if fileName and string.match(fileName, "%.[^%.]+$") then
			printError("[SplineToolkit] Path must not contain a file extension: " .. fileName)
			return nil
		end

		return path
	end

	local rawPath = self.uiImgFencePath:getValue()
	local path = validatePath(rawPath)

	if not path then
		return
	end

	if not folderExists(path) then
		printError("[SplineToolkit] Fence image folder does not exist: " .. path)
		return
	end

	self.uiFenceIcon:setVisible(true)

	local filePath = path .. img
	local defaultFilePath = path .. values.defaultImage

	if fileExists(filePath) then
		self.uiFenceIcon:setImage(filePath)
		return
	end

	printWarning("[SplineToolkit] Fence icon not found, trying default: " .. filePath)

	if fileExists(defaultFilePath) then
		self.uiFenceIcon:setImage(defaultFilePath)
		return
	end

	printError("[SplineToolkit] Default fence icon not found: " .. defaultFilePath)
	self.uiFenceIcon:setVisible(false)
end

function SplineToolkit:setFenceList()
	local values = self.values.fencePlacement
	local fenceTable = values.fenceTable

    self.uiListFence:clear()

    if not fenceTable or #fenceTable == 0 then
        printWarning("[SplineToolkit] Fence table is empty.")
		self:setFenceImage(values.defaultImage)
        return
    end

    for i, fence in ipairs(fenceTable) do
        self.uiListFence:appendItem(fence.name or ("Fence " .. i))

        if fence.isCustom then
            self.uiListFence:setItemBackgroundColor(i - 1, 1, 1, 0.1, 1)
        end
    end

    if #fenceTable > 0 then
        self.uiListFence:setSelectedItem(0)
        self:setFenceListItemCallback(1)
    end
end

function SplineToolkit:clearFenceList()
    local values = self.values and self.values.fencePlacement
    if values == nil or values.fenceTable == nil then
        return
    end

    local fenceTable = values.fenceTable
    for i = #fenceTable, 1, -1 do
        if fenceTable[i] and fenceTable[i].isCustom then
            table.remove(fenceTable, i)
        end
    end

    if self.uiListFence then
        self.uiListFence:clear()
    end
end

function SplineToolkit:setFenceListItemCallback(index)
    local values = self.values.fencePlacement
    local fenceTable = values.fenceTable
	
	local fence = fenceTable[index]
	if not fence then
		self.uiFenceIcon:setImage(SplineToolkit.FENCE_IMG_PATH .. values.defaultImage)
		self:setFenceImage(values.defaultImage)
		return
	end

	self:setFenceImage(fence.imgFile)

	if fence.isCustom then
		self.uiFenceEdit:setEnabled(true)
		self.uiiFenceDel:setEnabled(true)
	else
		self.uiFenceEdit:setEnabled(false)
		self.uiiFenceDel:setEnabled(false)
	end

	self:loadFenceFromXML(index)
	self:setFenceGateList()
end

function SplineToolkit:setFenceGateList()
    if not self.uiFenceGateChoice then
        return
    end

    local gateNames = {}

    if not self.selFenceInfo or not self.selFenceInfo.gates or #self.selFenceInfo.gates == 0 then
        gateNames = { "No Gates" }
		self.uiFenceGateChoice:setEnabled(false)
		self.uiBtnPlaceGate:setEnabled(false)
    else
        for _, gate in ipairs(self.selFenceInfo.gates) do
            table.insert(gateNames, gate.id or "Gate")
        end
		self.uiFenceGateChoice:setEnabled(true)
		self.uiBtnPlaceGate:setEnabled(true)
    end

    self.uiFenceGateChoice:setChoices(gateNames, 0)
    self.foldPanelSavedText = nil
end

function SplineToolkit:onFenceAddBtn()
    self:genUINewFence(nil, function(result, data)

        if not result or not data then return end

        local fenceTable = self.values.fencePlacement.fenceTable

        table.insert(fenceTable, {
            name    = data.name or "",
            xmlFile = data.xmlFile or "",
            imgFile = data.imgFile or "",
            isCustom = true,
        })

		self:saveSettings(self.currentTab)
        self:setFenceList()
    end)
end

function SplineToolkit:onFenceEditBtn()
    local selected = self.uiListFence:getSelectedItem()
    if selected == nil or selected < 0 then
        printWarning("[SplineToolkit] No fence selected.")
        return
    end

    local index = selected + 1
    local fenceTable = self.values.fencePlacement.fenceTable
    local entry = fenceTable[index]
    if not entry then return end

    self:genUINewFence(index, function(result, data)

        if not result or not data then return end

        fenceTable[index] = {
            name    = data.name or "",
            xmlFile = data.xmlFile or "",
            imgFile = data.imgFile or "",
            isCustom = true,
        }

		self:saveSettings(self.currentTab)
        self:setFenceList()
    end, entry)
end

function SplineToolkit:onFenceDelBtn()
    local selected = self.uiListFence:getSelectedItem()
    if selected == nil or selected < 0 then
        printWarning("[SplineToolkit] No fence selected.")
        return
    end

    local index = selected + 1
    local fenceTable = self.values.fencePlacement.fenceTable

    table.remove(fenceTable, index)

	self:saveSettings(self.currentTab)
    self:setFenceList()
end


function SplineToolkit:updateSplineModeButtonState()
    if not self.uiSplineModeGroup then return end
    if getNumSelected() ~= 1 then
        self.uiSplineModeGroup:setEnabled(false)
        return
    end
    local selected = getSelection(0)
    if selected == nil or selected == 0 or not self:isSpline(selected) then
        self.uiSplineModeGroup:setEnabled(false)
        return
    end
    local isInGroup = self:selectedIsFenceGroup()
    self.uiSplineModeGroup:setEnabled(not isInGroup)
end

function SplineToolkit:canImportGate()
   self.uiBtnPlaceGate:setEnabled(false)
end

function SplineToolkit:updateGateImportButtonState()
	if not self.uiBtnPlaceGate then return end
    local hasGates = self.selFenceInfo and self.selFenceInfo.gates and #self.selFenceInfo.gates > 0
    self.uiBtnPlaceGate:setEnabled(self:canImportFence() and hasGates == true)
end

function SplineToolkit:genGatePlaceholder()
	-- Leerer 0-Höhe Slot damit der Sizer beim nächsten destroy+create sauber bleibt
	local emptySizer = UIRowLayoutSizer.new()
	local placeholder = UIPanel.new(self.uiPlaceFenceInnerRowSizer, emptySizer, -1, -1, -1, 0, BorderDirection.NONE, 0)
	table.insert(self.subPanels, placeholder)
end

function SplineToolkit:updateGatePositionSliderState()
	local selected = getNumSelected() == 1 and getSelection(0) or nil
	local isGate = selected ~= nil and getUserAttribute(selected, "isFenceGate") == true

	if isGate then
		if not self.gateUIActive then
			-- destroy (placeholder oder leer) + create gate UI — im gleichen Call wie Place Objects
			self.gateUIActive = true
			self.selectedGateNode = selected
			self:onDeleteSubPanels()
			self:genPlaceFenceGateOptionsUI()
			self:loadGatePositionFromAttribute(selected)
		elseif self.selectedGateNode ~= selected then
			self.gateUIActive = false
			self.selectedGateNode = nil
			self:onDeleteSubPanels()
			self:genGatePlaceholder()
			self.window:refresh()
			self.window:fit()
		end
	else
		if self.gateUIActive then
			-- destroy gate UI + sofort placeholder erstellen — im gleichen Call
			self.gateUIActive = false
			self.selectedGateNode = nil
			self:onDeleteSubPanels()
			self:genGatePlaceholder()
			self.window:refresh()
			self.window:fit()
		end
	end
end

function SplineToolkit:loadGatePositionFromAttribute(gateNode)
	local positionValue = getUserAttribute(gateNode, "position") or 0.0
	local clampedPosition = math.max(0.0, math.min(100.0, positionValue))

	self.uiGatePositionSlider:setValue(clampedPosition)

	local gateParent = getParent(gateNode)
	local fenceGroup = getParent(gateParent)

	if not fenceGroup or getUserAttribute(fenceGroup, "isFenceGroup") ~= true then
		return
	end

	local splineIDs = {}
	for i = 0, getNumOfChildren(fenceGroup) - 1 do
		local child = getChildAt(fenceGroup, i)
		if self:isSpline(child) then
			table.insert(splineIDs, child)
		end
	end

	if #splineIDs > 0 then
		local gateLength = getUserAttribute(gateNode, "gateLength") or 0.0
		self:positionGateOnSpline(gateNode, splineIDs[1], clampedPosition, gateLength)
		setUserAttribute(gateNode, "position", UserAttributeType.FLOAT, clampedPosition)
	end
end

function SplineToolkit:updateFenceGenerateButtonState()
    if not self.uiBtnPlaceFence then return end
    local hasSpline = false
    if getNumSelected() >= 1 then
        for i = 0, getNumSelected() - 1 do
            if self:isSpline(getSelection(i)) then
                hasSpline = true
                break
            end
        end
    end
    local isInGroup = self:selectedIsFenceGroup()
    self.uiBtnPlaceFence:setEnabled(hasSpline or isInGroup)
end

-- ---------------------------------------------------------------
-- UI Functions - Export Spline
-- ---------------------------------------------------------------
function SplineToolkit:setUseCustomFilename()
	if self.uiExportUseCustomFilename:getValue() == true then
		self.uiExportCustomFilename:setEnabled(true)
		self.uiExportCustomFilename:setValue(self.values.exportObject.customFileName)
	else
		self.uiExportCustomFilename:setEnabled(false)
		if self.uiExportCustomFilename:getValue() ~= "" then
			self.values.exportObject.customFileName = self.uiExportCustomFilename:getValue()
		end
		self.uiExportCustomFilename:setValue(self.values.exportObject.defaultFileName)
	end
end

function SplineToolkit:setExportChoice()
	if self.uiExportType:getValue() == 1 then
		self.uiExportDistanceType:setEnabled(false)
		self.uiExportDistance:setEnabled(false)
		self.uiExportMinDistance:setEnabled(false)
		self.uiExportMinAngle:setEnabled(false)
	else
		self.uiExportDistanceType:setEnabled(true)
		if self.uiExportDistanceType:getValue() == 1 then
			self.uiExportDistance:setEnabled(true)
			self.uiExportMinDistance:setEnabled(false)
			self.uiExportMinAngle:setEnabled(false)
		else
			self.uiExportDistance:setEnabled(false)
			self.uiExportMinDistance:setEnabled(true)
			self.uiExportMinAngle:setEnabled(true)
		end
	end
end

-- ---------------------------------------------------------------
-- UI Functions - Gen Road Mesh
-- ---------------------------------------------------------------

function SplineToolkit:setRoadTrafficChoice()
	if self:getChoiceBoolean(self.uiHasTrafficCenter) or self:getChoiceBoolean(self.uiHasTrafficLeft) or self:getChoiceBoolean(self.uiHasTrafficRight) then
		self.uiMaxSpeedScale:setEnabled(true)
		self.uiSpeedLimit:setEnabled(true)
	else
		self.uiMaxSpeedScale:setEnabled(false)
		self.uiSpeedLimit:setEnabled(false)
	end
	self.uiTrafficLeftPerc:setEnabled(self:getChoiceBoolean(self.uiHasTrafficLeft))
	self.uiTrafficRightPerc:setEnabled(self:getChoiceBoolean(self.uiHasTrafficRight))
end

function SplineToolkit:onSelectRoadImgFolder()
	local values = self.values.roadMesh
    local path = openDirDialog(values.imgPath)
    if path ~= nil and path ~= "" then
        path = string.gsub(path, "\\", "/")
        if string.sub(path, -1) ~= "/" then
            path = path .. "/"
        end
        values.imgPath = path
        self.uiImgRoadPath:setValue(values.imgPath)
		self.uiImgRoadPath:setToolTip(values.imgPath)
        self:saveSettings()
    end
end

function SplineToolkit:setRoadTextureImage(img)
	local values = self.values.fencePlacement
	
	local function validatePath(path)
		if not path or path == "" then
			return nil
		end

		path = string.gsub(path, "^%s*(.-)%s*$", "%1")

		local fileName = string.match(path, "([^/\\]+)$")

		if fileName and string.match(fileName, "%.[^%.]+$") then
			printError("[SplineToolkit] Path must not contain a file extension: " .. fileName)
			return nil
		end

		return path
	end

	local rawPath = self.uiImgRoadPath:getValue()
	local path = validatePath(rawPath)

	if not path then
		return
	end

	if not folderExists(path) then
		printError("[SplineToolkit] Road Texture image folder does not exist: " .. path)
		return
	end

	self.uiRoadIcon:setVisible(true)

	local filePath = path .. img
	local defaultFilePath = path .. values.defaultImage

	if fileExists(filePath) then
		self.uiRoadIcon:setImage(filePath)
		return
	end

	printWarning("[SplineToolkit] Road Texture icon not found, trying default: " .. filePath)

	if fileExists(defaultFilePath) then
		self.uiRoadIcon:setImage(defaultFilePath)
		return
	end

	printError("[SplineToolkit] Default Road Texture icon not found: " .. defaultFilePath)
	self.uiRoadIcon:setVisible(false)
end

function SplineToolkit:setRoadTextureList()
	local values = self.values.roadMesh
	local roadTextureTable = values.textureTable

    self.uiListRoad:clear()

    if not roadTextureTable or #roadTextureTable == 0 then
        printWarning("[SplineToolkit] Fence table is empty.")
        -- self.uiFenceIcon:setImage(SplineToolkit.FENCE_IMG_PATH .. values.defaultImage)
		self:setRoadTextureImage(values.defaultImage)
        return
    end

    for i, roadTexture in ipairs(roadTextureTable) do
        self.uiListRoad:appendItem(roadTexture.name or ("roadTexture " .. i))

        if roadTexture.isCustom then
            self.uiListRoad:setItemBackgroundColor(i - 1, 1, 1, 0.1, 1)
        end
    end

    if #roadTextureTable > 0 then
        self.uiListRoad:setSelectedItem(0)
        self:setRoadTextureListItemCallback(1)
    end
end
function SplineToolkit:clearRoadTextureList()
    local values = self.values and self.values.roadMesh
    if values == nil or values.textureTable == nil then
        return
    end

    local textureTable = values.textureTable

    for i = #textureTable, 1, -1 do
        if textureTable[i] and textureTable[i].isCustom then
            table.remove(textureTable, i)
        end
    end

    if self.uiListRoad then
        self.uiListRoad:clear()
    end
end

function SplineToolkit:setRoadTextureListItemCallback(index)
    local values = self.values.roadMesh
    local roadTextureTable = values.textureTable
	
	local roadTexture = roadTextureTable[index]
	if not roadTexture then
		self.uiRoadIcon:setImage(SplineToolkit.FENCE_IMG_PATH .. values.defaultImage)
		self:setRoadTextureImage(values.defaultImage)
		return
	end

    self.selectedRoadTextureIndex = index
	self:setRoadTextureImage(roadTexture.imgFile)
	
	if roadTextureTable[index].textures["diffuse"] ~= "" then
		self.uiRoadTextureHasDiffuse:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
		self.uiRoadTextureHasDiffuse:setToolTip(roadTextureTable[index].textures["diffuse"])
	else
		self.uiRoadTextureHasDiffuse:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
		self.uiRoadTextureHasDiffuse:setToolTip("")
	end
	if roadTextureTable[index].textures["specular"] ~= "" then
		self.uiRoadTextureHasSpecular:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
		self.uiRoadTextureHasSpecular:setToolTip(roadTextureTable[index].textures["specular"])
	else
		self.uiRoadTextureHasSpecular:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
		self.uiRoadTextureHasSpecular:setToolTip("")
	end
	if roadTextureTable[index].textures["normal"] ~= "" then
		self.uiRoadTextureHasNormal:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
		self.uiRoadTextureHasNormal:setToolTip(roadTextureTable[index].textures["normal"])
	else
		self.uiRoadTextureHasNormal:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
		self.uiRoadTextureHasNormal:setToolTip("")
	end
	if roadTextureTable[index].textures["height"] ~= "" then
		self.uiRoadTextureHasHeight:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
		self.uiRoadTextureHasHeight:setToolTip(roadTextureTable[index].textures["height"])
	else
		self.uiRoadTextureHasHeight:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
		self.uiRoadTextureHasHeight:setToolTip("")
	end
	if roadTextureTable[index].textures["alpha"] ~= "" then
		self.uiRoadTextureHasAlpha:setBackgroundColor(0.6, 1.0, 0.55, 1.0)
		self.uiRoadTextureHasAlpha:setToolTip(roadTextureTable[index].textures["alpha"])
	else
		self.uiRoadTextureHasAlpha:setBackgroundColor(0.9, 0.5, 0.5, 1.0)
		self.uiRoadTextureHasAlpha:setToolTip("")
	end
	
	if roadTexture.isCustom then
		self.uiRoadEdit:setEnabled(true)
		self.uiRoadDel:setEnabled(true)
	else
		self.uiRoadEdit:setEnabled(false)
		self.uiRoadDel:setEnabled(false)
	end
end

function SplineToolkit:onRoadTextureAddBtn()
    self:genUINewRoadTexture(nil, function(result, data)

        if not result or not data then return end

        table.insert(self.values.roadMesh.textureTable, data)

        self:saveSettings(self.currentTab)
        self:setRoadTextureList()
    end)
end

function SplineToolkit:onRoadTextureEditBtn()

    local selected = self.uiListRoad:getSelectedItem()
    if selected == nil or selected < 0 then
        printWarning("[SplineToolkit] No road texture selected.")
        return
    end

    local index = selected + 1
    local textureTable = self.values.roadMesh.textureTable
    local entry = textureTable[index]
    if not entry then return end

    self:genUINewRoadTexture(index, function(result, data)

        if not result or not data then return end

        textureTable[index] = {
            name      = data.name or "",
            imgFile   = data.imgFile or "",
            shaderVar = data.shaderVar or "",

            textures = {
                diffuse  = data.textures.diffuse,
                specular = data.textures.specular,
                normal   = data.textures.normal,
                height   = data.textures.height,
                alpha    = data.textures.alpha,
            },

            isCustom = true
        }

        self:saveSettings(self.currentTab)
        self:setRoadTextureList()

    end, entry)

end

function SplineToolkit:onRoadTextureDelBtn()

    local selected = self.uiListRoad:getSelectedItem()
    if selected == nil or selected < 0 then
        printWarning("[SplineToolkit] No road texture selected.")
        return
    end

    local index = selected + 1
    local textureTable = self.values.roadMesh.textureTable

    if not textureTable[index] then return end

    table.remove(textureTable, index)

    self:saveSettings(self.currentTab)
    self:setRoadTextureList()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	BASE TOOLS 		--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
function SplineToolkit:paintTerrainBySpline()

    local widthLeft  = self.uiPaintWidthLeft:getValue()
    local widthRight = self.uiPaintWidthRight:getValue()

    local choiceIndex = self.uiPaintTerrainLayer:getValue()
    local layerName = self.values.base.paintTerrain.textureLayers[choiceIndex]

    if layerName == nil or layerName == "" then
        printWarning("[SplineToolkit] No terrain layer selected")
        return
    end

    local terrainId = getChild(getRootNode(), "terrain")
    if terrainId == nil or terrainId == 0 then
        printError("[SplineToolkit] Terrain not found")
        return
    end

    local layerId = nil
    for i = 0, getTerrainNumOfLayers(terrainId) - 1 do
        if getTerrainLayerName(terrainId, i) == layerName then
            layerId = i
            break
        end
    end

    if layerId == nil then
        printError("[SplineToolkit] Layer not found in terrain: " .. tostring(layerName))
        return
    end

    local splineId = getSelection(0)
    if splineId == 0
    or not getHasClassId(splineId, ClassIds.SHAPE)
    or not getHasClassId(getGeometry(splineId), ClassIds.SPLINE) then
        printWarning("[SplineToolkit] Please select a spline")
        return
    end

    local splineLength = getSplineLength(splineId)
    if splineLength <= 0 then
        printWarning("[SplineToolkit] Invalid spline length")
        return
    end

    local step = 0.1 / splineLength
    local widthStep = 0.1
    local pos = 0.0

    while pos <= 1.0 do
        local px, py, pz = getSplinePosition(splineId, pos)
        local dx, dy, dz = getSplineDirection(splineId, pos)

        local crossX = -dz
        local crossZ = dx

        local len = math.sqrt(crossX * crossX + crossZ * crossZ)
        if len > 0 then
            crossX = crossX / len
            crossZ = crossZ / len
        end

        for w = -widthLeft, widthRight, widthStep do
            local nx = px + crossX * w
            local nz = pz + crossZ * w
            local ny = getTerrainHeightAtWorldPos(terrainId, nx, py, nz)

            setTerrainLayerAtWorldPos(terrainId, layerId, nx, ny, nz, 128.0)
        end

        pos = pos + step
    end

    -- letzten Punkt sauber mitnehmen
    do
        local px, py, pz = getSplinePosition(splineId, 1.0)
        local dx, dy, dz = getSplineDirection(splineId, 1.0)

        local crossX = -dz
        local crossZ = dx

        local len = math.sqrt(crossX * crossX + crossZ * crossZ)
        if len > 0 then
            crossX = crossX / len
            crossZ = crossZ / len
        end

        for w = -widthLeft, widthRight, widthStep do
            local nx = px + crossX * w
            local nz = pz + crossZ * w
            local ny = getTerrainHeightAtWorldPos(terrainId, nx, py, nz)

            setTerrainLayerAtWorldPos(terrainId, layerId, nx, ny, nz, 128.0)
        end
    end

    print(string.format("[SplineToolkit] Painted '%s' | Left: %.2f m | Right: %.2f m", layerName, widthLeft, widthRight))
end

function SplineToolkit:setSplineOnTerrain()
    local mSceneID = getRootNode()
    local mTerrainID = 0

    for i = 0, getNumOfChildren(mSceneID) - 1 do
        local mID = getChildAt(mSceneID, i)
        if getName(mID) == "terrain" then
            mTerrainID = mID
            break
        end
    end

    if mTerrainID == 0 then
        print("Error: Terrain node not found. Node must be named 'terrain'.")
        return
    end

    if getNumSelected() == 0 then
        print("Error: Select one or more splines.")
        return
    end

    local mSplineIDs = {}
    for i = 0, getNumSelected() - 1 do
        local mID = getSelection(i)
        if getHasClassId(mID, ClassIds.SHAPE) and getHasClassId(getGeometry(mID), ClassIds.SPLINE) then
            table.insert(mSplineIDs, mID)
        end
    end

    if #mSplineIDs == 0 then
        printError("Error: No valid splines selected.")
        return
    end

	for _, mSplineID in ipairs(mSplineIDs) do

		local numCVs = getSplineNumOfCV(mSplineID)

		if numCVs > 0 then

			local splineType = self:getSplineType(mSplineID)
			local offset = self.uiTerrainHeightOffset:getValue()

			for i = 0, numCVs - 1 do
				local worldX, worldY, worldZ

				if splineType == "CUBIC" then
					worldX, worldY, worldZ = getSplineEP(mSplineID, i)
				else
					worldX, worldY, worldZ = getSplineCV(mSplineID, i)
				end

				local terrainHeight = getTerrainHeightAtWorldPos(mTerrainID, worldX, 0, worldZ)
				local newWorldY = terrainHeight + offset
				local localX, localY, localZ = worldToLocal(mSplineID, worldX, newWorldY, worldZ)

				if splineType == "CUBIC" then
					setSplineEP(mSplineID, i, localX, localY, localZ)
				else
					setSplineCV(mSplineID, i, localX, localY, localZ)
				end
			end

		else
			printWarning("Warning: Spline has no control vertices.")
		end
	end

    print("Splines successfully snapped to terrain height with offset: " .. self.uiTerrainHeightOffset:getValue() .. "m.")
end

function SplineToolkit:setTerrainHeight(mHeightOffset, mSideCount, mFalloff)
	local terrain = self:getTerrain()
	if not terrain or terrain == 0 then
		printError("Error: Terrain node not found. Node needs to be named 'terrain'.")
		return
	end
	if getNumSelected() == 0 then
		printError("Error: Select one or more splines.")
		return
	end

	local mapMetersPerPixel
	if SplineToolkit.TERRAIN_METER_PER_PIXEL_LOAD_FROM_MAP then
		print("SplineToolkit.TERRAIN_METER_PER_PIXEL_LOAD_FROM_MAP = true")
		mapMetersPerPixel = getTerrainUnitsPerPixel() / 2
	else
		print("SplineToolkit.TERRAIN_METER_PER_PIXEL_LOAD_FROM_MAP = false")
		mapMetersPerPixel = SplineToolkit.TERRAIN_METER_PER_PIXEL_CUSTOM / 2
	end
	local pixelsPerMeter = 1.0 / mapMetersPerPixel

	local mSplineIDs = {}
	for i = 0, getNumSelected() - 1 do
		local mID = getSelection(i)
		if getHasClassId(mID, ClassIds.SHAPE) and getGeometry(mID) ~= 0
			and getHasClassId(getGeometry(mID), ClassIds.SPLINE) then
			table.insert(mSplineIDs, mID)
		end
	end
	if #mSplineIDs == 0 then
		printError("Error: No splines were selected.")
		return
	end

	local falloffSteps    = math.max(1, math.floor(mFalloff   * pixelsPerMeter))
	local sideSteps       = math.floor(mSideCount * pixelsPerMeter)
	local invFalloffSteps = 1.0 / falloffSteps

	local easingLUT = {}
	for i = 1, falloffSteps do
		local t = i * invFalloffSteps
		if t < 0.5 then
			easingLUT[i] = 4.0 * t * t * t
		else
			easingLUT[i] = 1.0 - ((-2.0 * t + 2.0) ^ 3) / 2.0
		end
	end

	local function getPerp(dirX, dirZ)
		local len = math.sqrt(dirX * dirX + dirZ * dirZ)
		if len > 0.0001 then return -dirZ / len, dirX / len end
		return 1, 0
	end

	local function setStrip(px, pz, vx, vz, height)
		setTerrainHeightAtWorldPos(terrain, px, 0, pz, height)
		local svx, svz = vx * mapMetersPerPixel, vz * mapMetersPerPixel
		local p1x, p1z = px + svx, pz + svz
		local p2x, p2z = px - svx, pz - svz
		for _ = 1, sideSteps do
			setTerrainHeightAtWorldPos(terrain, p1x, 0, p1z, height)
			setTerrainHeightAtWorldPos(terrain, p2x, 0, p2z, height)
			p1x = p1x + svx;  p1z = p1z + svz
			p2x = p2x - svx;  p2z = p2z - svz
		end
	end

	local function sweepFalloff(ox, oz, dx, dz, height)
		local targetH  = getTerrainHeightAtWorldPos(terrain, ox + mFalloff * dx, 0, oz + mFalloff * dz)
		local diff     = targetH - height
		local sdx, sdz = dx * mapMetersPerPixel, dz * mapMetersPerPixel
		local fx, fz   = ox + sdx, oz + sdz
		for i = 1, falloffSteps do
			setTerrainHeightAtWorldPos(terrain, fx, 0, fz, height + easingLUT[i] * diff)
			fx = fx + sdx;  fz = fz + sdz
		end
	end

	local progress     = ProgressDialog.show("Set Terrain Height")
	local totalSplines = #mSplineIDs

	for splineIdx, mSplineID in ipairs(mSplineIDs) do
		local splineBase  = (splineIdx - 1) / totalSplines
		local splineShare = 1.0 / totalSplines

		local mSplineLength = getSplineLength(mSplineID)
		local mSplinePieceT = mapMetersPerPixel / mSplineLength

		local mSplinePos = 0.0
		local lastPct    = -1
		while mSplinePos <= 1.0 do
			local px, py, pz = getSplinePosition(mSplineID, mSplinePos)
			local dx, dy, dz = getSplineDirection(mSplineID, mSplinePos)
			local height     = py + mHeightOffset
			local vx, vz     = getPerp(dx, dz)

			setStrip(px, pz, vx, vz, height)

			local reach = sideSteps * mapMetersPerPixel
			sweepFalloff(px + reach * vx, pz + reach * vz,  vx,  vz, height)
			sweepFalloff(px - reach * vx, pz - reach * vz, -vx, -vz, height)

			local pct = math.floor((splineBase + mSplinePos * splineShare) * 100)
			if pct ~= lastPct then
				progress:setProgress(pct, string.format("Spline %d/%d – %d%%", splineIdx, totalSplines, math.floor(mSplinePos * 100)))
				lastPct = pct
			end

			mSplinePos = mSplinePos + mSplinePieceT
		end
	end

	progress:close()
	return nil
end

function SplineToolkit:getSplineType(splineId)
    local numCVs = getSplineNumOfCV(splineId)
    if numCVs < 2 then
        return "UNKNOWN"
    end

    local epsilon = 0.0001

    for i = 0, numCVs - 1 do
        local epX, epY, epZ = getSplineEP(splineId, i)
        local cvX, cvY, cvZ = getSplineCV(splineId, i)

        if math.abs(epX - cvX) > epsilon
        or math.abs(epY - cvY) > epsilon
        or math.abs(epZ - cvZ) > epsilon then
            return "CUBIC"
        end
    end

    return "LINEAR"
end

function SplineToolkit:setSplineOffset()
    if getNumSelected() == 0 then
        printError("Error: Select one or more splines.")
        return
    end

    local sideOffset = self.uiOffsetSideOffset:getValue()
    local heightOffset = self.uiOffsetHeightOffset:getValue()
    local updatedSplines = 0

    for i = 0, getNumSelected() - 1 do
        local splineID = getSelection(i)

        if getHasClassId(splineID, ClassIds.SHAPE) and getHasClassId(getGeometry(splineID), ClassIds.SPLINE) then
            local numCVs = getSplineNumOfCV(splineID)

            if numCVs > 1 then
                for j = 0, numCVs - 1 do
                    local worldX, worldY, worldZ = getSplineCV(splineID, j)
                    local dirX, dirY, dirZ = getSplineDirection(splineID, j / (numCVs - 1))
                    local offsetX, _, offsetZ = self:crossProduct(dirX, dirY, dirZ, 0, 1, 0)

                    local newWorldX = worldX + (offsetX * sideOffset)
                    local newWorldY = worldY + heightOffset
                    local newWorldZ = worldZ + (offsetZ * sideOffset)
					
                    local localX, localY, localZ = worldToLocal(splineID, newWorldX, newWorldY, newWorldZ)

                    setSplineCV(splineID, j, localX, localY, localZ)
                end
                updatedSplines = updatedSplines + 1
            else
                printWarning("Warning: Spline has less than 2 control points.")
            end
        end
    end

    print(string.format("Updated %d spline(s) with sideOffset = %.2f and heightOffset = %.2f", updatedSplines, sideOffset, heightOffset))
end

function SplineToolkit:crossProduct(ax, ay, az, bx, by, bz)
    return ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx
end

function SplineToolkit:setFoliageBySpline(isClear)
    if getNumSelected() < 1 then
        printWarning("[SplineToolkit] Please select a spline")
        return
    end

    local spline = getSelection(0)
    if not getHasClassId(spline, ClassIds.SHAPE) or not getHasClassId(getGeometry(spline), ClassIds.SPLINE) then
        printWarning("[SplineToolkit] Selected object is not a spline")
        return
    end

    local terrain = getChild(getRootNode(),"terrain")
    if terrain == nil or terrain == 0 then
        printError("[SplineToolkit] Terrain not found")
        return
    end

    local widthLeft  = self.uiFoliageWidthLeft:getValue()
    local widthRight = self.uiFoliageWidthRight:getValue()

    local splineLength = getSplineLength(spline)
    if splineLength <= 0 then
        printWarning("[SplineToolkit] Invalid spline length")
        return
    end

    local step = 0.1 / splineLength
    local pos = 0
    local pointsRight = {}
    local modifiers = {}
    local multiModifier = nil

    if isClear then
        -- Read all foliage layer names from map i3d
        local i3dPath = getSceneFilename()
        if i3dPath == nil or i3dPath == "" then
            printError("[SplineToolkit] Could not get scene filename")
            return
        end
        local xml = XMLFile.loadIfExists("splineFoliageScan", i3dPath)
        if xml == nil then
            printError("[SplineToolkit] Failed to load map i3d")
            return
        end
        multiModifier = DensityMapMultiModifier.new()
        local seenId = {}
        local layerCount = 0
        local mlIdx = 0
        while true do
            local mlKey = string.format("i3D.Scene.TerrainTransformGroup.Layers.FoliageSystem.FoliageMultiLayer(%d)", mlIdx)
            if not xml:hasProperty(mlKey) then break end
            local ftIdx = 0
            while true do
                local ftKey = string.format("%s.FoliageType(%d)", mlKey, ftIdx)
                if not xml:hasProperty(ftKey) then break end
                local name = xml:getString(ftKey .. "#name")
                if name ~= nil then
                    local layerId = getTerrainDataPlaneByName(terrain, name)
                    if layerId ~= nil and layerId ~= 0 and not seenId[layerId] then
                        seenId[layerId] = true
                        local numCh = getTerrainDetailNumChannels(layerId)
                        local mod = DensityMapModifier.new(layerId, 0, numCh, terrain)
                        mod:setNewTypeIndexMode(DensityIndexCompareMode.ZERO)
                        local filter = DensityMapFilter.new(mod)
                        filter:setValueCompareParams(DensityValueCompareType.GREATER, 0)
                        multiModifier:addExecuteSet(0, mod, filter)
                        layerCount = layerCount + 1
                    end
                end
                ftIdx = ftIdx + 1
            end
            mlIdx = mlIdx + 1
        end
        xml:delete()
        if layerCount == 0 then
            printError("[SplineToolkit] No foliage layers found in map i3d")
            return
        end
        print("[SplineToolkit] Clearing foliage across " .. layerCount .. " layers")
    else
        local layerIndex = self.uiFoliageLayer:getValue()
        local stateIndex = self.uiFoliageLayerState:getValue()

        local layerName = self.foliageLayers.options[layerIndex]
        if layerName == nil then
            printWarning("[SplineToolkit] No foliage layer selected")
            return
        end

        local plane = getTerrainDataPlaneByName(terrain,layerName)
        if plane == nil or plane == 0 then
            printError("[SplineToolkit] Foliage layer not found: "..tostring(layerName))
            return
        end

        local modifier = DensityMapModifier.new(
            plane,
            self.foliageLayers.offsets[layerIndex],
            self.foliageLayers.channels[layerIndex],
            terrain
        )

        modifier:clearPolygonPoints()
        table.insert(modifiers,modifier)
    end

    while pos <= 1.0 do
        local x,_,z = getSplinePosition(spline,pos)
        local dx,_,dz = getSplineDirection(spline,pos)

        local crossX = -dz
        local crossZ = dx

        if multiModifier ~= nil then
            multiModifier:addPolygonPointWorldCoords(x + crossX * widthRight, z + crossZ * widthRight)
        else
            for _,mod in ipairs(modifiers) do
                mod:addPolygonPointWorldCoords(x + crossX * widthRight, z + crossZ * widthRight)
            end
        end

        table.insert(pointsRight,1,{ x = x - crossX * widthLeft, z = z - crossZ * widthLeft })
        pos = pos + step
    end

    for i=1,#pointsRight do
        if multiModifier ~= nil then
            multiModifier:addPolygonPointWorldCoords(pointsRight[i].x,pointsRight[i].z)
        else
            for _,mod in ipairs(modifiers) do
                mod:addPolygonPointWorldCoords(pointsRight[i].x,pointsRight[i].z)
            end
        end
    end

    if isClear then
        multiModifier:execute(false)
        print("[SplineToolkit] Foliage cleared by spline")
    else
        local stateIndex = self.uiFoliageLayerState:getValue()
        for _,mod in ipairs(modifiers) do
            mod:executeSet(stateIndex)
        end
        local layerName = self.foliageLayers.options[self.uiFoliageLayer:getValue()]
        print(string.format("[SplineToolkit] Foliage '%s' painted with state %d", layerName, stateIndex))
    end
end

function SplineToolkit:resampleSpline()
    if getNumSelected() < 1 then
        printWarning("[SplineToolkit] Select a spline")
        return
    end

    local spline = getSelection(0)

    if not getHasClassId(spline, ClassIds.SHAPE) or not getHasClassId(getGeometry(spline), ClassIds.SPLINE) then
        printWarning("[SplineToolkit] Selected object is not a spline")
        return
    end

    local targetPoints = math.max(self.uiNumOfPoints:getValue(), 2)

    local length = getSplineLength(spline)
    if length <= 0 then return end

    local parent = getParent(spline)
    if parent == nil or parent == 0 then parent = getRootNode() end

    local name = getName(spline)
    local isClosed = getIsSplineClosed(spline)

    -- Lokalen Transform der Original-Spline merken
    local tx, ty, tz = getTranslation(spline)
    local rx, ry, rz = getRotation(spline)
    local sx, sy, sz = getScale(spline)

    -- Edit-Points in lokaler Space der Original-Spline berechnen
    -- so bleibt das Origin korrekt wenn wir den Transform übernehmen
    local editPoints = {}
    local step = 1.0 / (targetPoints - 1)
    for i = 0, targetPoints - 1 do
        local wx, wy, wz = getSplinePosition(spline, i * step)
        local lx, ly, lz = worldToLocal(spline, wx, wy, wz)
        table.insert(editPoints, lx)
        table.insert(editPoints, ly)
        table.insert(editPoints, lz)
    end

    if #editPoints < 6 then
        printError("[SplineToolkit] Not enough points")
        return
    end

    local newSpline = createSplineFromEditPoints(parent, editPoints, false, isClosed)
    if newSpline == 0 then
        printError("[SplineToolkit] Failed to create spline")
        return
    end

    setName(newSpline, name)
    setTranslation(newSpline, tx, ty, tz)
    setRotation(newSpline, rx, ry, rz)
    setScale(newSpline, sx, sy, sz)

    clearSelection()
    delete(spline)
    addSelection(newSpline)

    print(string.format("[SplineToolkit] Spline resampled → %d points", targetPoints))
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	SET SPLINE OBJECTS		------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SplineToolkit:generateObjectsOnSpline()
    local activeIndex = self.uiPlaceObjectModeGroup and self.uiPlaceObjectModeGroup:getActiveIndex() or 1
    if activeIndex == 2 then
        self:generateObjectsOnArea()
    else
        self:generateObjectsAlongSpline()
    end
end

function SplineToolkit:generateObjectsAlongSpline()
    local mainTG, srcObjTG, srcSplineTG, placedTG = self:getOrCreatePlaceObjectsTransformgroups()
    link(mainTG, placedTG)

    for i = getNumOfChildren(placedTG)-1,0,-1 do
        delete(getChildAt(placedTG,i))
    end

    local sourceCount = getNumOfChildren(srcObjTG)
    if sourceCount == 0 then
        printError("[SplineToolkit] No SourceObjects found.")
        return
    end

    local isSequential = (self.uiObjectPlaceType:getValue() == 1)
    local distType     = self.uiObjectDistanceType:getValue()
    local fixDist      = math.max(self.uiObjectFixDistance:getValue(), 0.01)
    local minDist      = self.uiObjectMinDistance:getValue()
    local maxDist      = self.uiObjectMaxDistance:getValue()
    local sideOffset   = self.uiPlaceOffsetSide:getValue()
    local heightType   = self.uiSetHeightType:getValue()
    local fixHeight    = self.uiObjectHeight:getValue()
    local randomRotate = self:getChoiceBoolean(self.uiRandomRotate)
    local baseRotate   = math.rad(self.uiObjectRotate:getValue() or 0)
    local terrain      = self:getTerrain()
    local created      = 0
    local seqIndex     = 0

    local function getStep()
        if distType == 1 then
            return fixDist
        end
        return math.random() * (maxDist - minDist) + minDist
    end

    local function sampleSpline(spline, length, dist)
        dist = math.max(0, math.min(dist, length))
        local t = dist / length
        local px, py, pz = getSplinePosition(spline, t)
        local dx, dy, dz = getSplineDirection(spline, t)

        local rx, rz = -dz, dx
        local rl = math.sqrt(rx*rx + rz*rz)
        if rl > 0 then
            rx, rz = rx/rl, rz/rl
        end

        px = px + rx * sideOffset
        pz = pz + rz * sideOffset

        if heightType == 3 or heightType == 4 or heightType == 5 then
            if terrain then
                py = getTerrainHeightAtWorldPos(terrain, px, py, pz)
            end
        elseif heightType == 6 then
            py = fixHeight
        end

        return px, py, pz
    end

    for i = 0, getNumOfChildren(srcSplineTG)-1 do
        local spline = getChildAt(srcSplineTG, i)

        if self:isSpline(spline) then
            local length = getSplineLength(spline)
            local dist = 0

            while dist <= length do
                local px, py, pz = sampleSpline(spline, length, dist)

                local sourceObject
                if isSequential then
                    sourceObject = getChildAt(srcObjTG, seqIndex)
                    seqIndex = (seqIndex + 1) % sourceCount
                else
                    sourceObject = getChildAt(srcObjTG, math.random(0, sourceCount-1))
                end

                local inst = clone(sourceObject, false)
                link(placedTG, inst)
                setWorldTranslation(inst, px, py, pz)

                local step = getStep()

                local x1,y1,z1 = sampleSpline(spline,length,dist)
                local x2,y2,z2 = sampleSpline(spline,length,dist+step)
                local tx = x2-x1
                local ty = y2-y1
                local tz = z2-z1
                local tl = math.sqrt(tx*tx + ty*ty + tz*tz)
                if tl < 0.00001 then tl = 0.00001 end
                tx,ty,tz = tx/tl, ty/tl, tz/tl

                local ry = math.atan2(tx,tz) + baseRotate
                if randomRotate then ry = math.random()*math.pi*2 end

                if heightType == 1 then
                    setRotation(inst, 0, ry, 0)

                elseif heightType == 2 or heightType == 5 then
                    -- Nur horizontale Richtung für Yaw → kein Gimbal mit der Steigung
                    local htl = math.sqrt(tx*tx + tz*tz)
                    if htl < 0.00001 then htl = 0.00001 end
                    setWorldDirection(inst, tx/htl, 0, tz/htl, 0, 1, 0)

                    -- Steigung separat mit fixDist abtasten
                    local fx2,fy2,fz2 = sampleSpline(spline,length,dist+fixDist)
                    local horiz = math.sqrt((fx2-x1)^2 + (fz2-z1)^2)
                    if horiz < 0.00001 then horiz = 0.00001 end
                    local slope = math.atan2(fy2-y1,horiz)

					rotateAboutLocalAxis(inst,-slope,1,0,0)
					-- rotateAboutLocalAxis(inst,slope,1,0,0)

                elseif heightType == 3 then
                    setRotation(inst, 0, ry, 0)

                elseif heightType == 4 and terrain then
                    local ux, uy, uz = getTerrainNormalAtWorldPos(terrain, px, py, pz)
                    local ul = math.sqrt(ux*ux + uy*uy + uz*uz)
                    if ul > 0 then
                        ux, uy, uz = ux/ul, uy/ul, uz/ul
                    end
                    setWorldDirection(inst, tx, ty, tz, ux, uy, uz)
                    rotateAboutLocalAxis(inst, ry, 0, 1, 0)

                elseif heightType == 6 then
                    setRotation(inst, 0, ry, 0)
                end

                created = created + 1
                dist = dist + step
            end
        end
    end

    print(string.format("[SplineToolkit] Generated %d objects along splines.", created))
end

function SplineToolkit:generateObjectsOnArea()
    local mainTG, srcObjTG, srcSplineTG, placedTG = self:getOrCreatePlaceObjectsTransformgroups()
    link(mainTG, placedTG)

    for i = getNumOfChildren(placedTG)-1, 0, -1 do
        delete(getChildAt(placedTG, i))
    end

    local sourceCount = getNumOfChildren(srcObjTG)
    if sourceCount == 0 then
        printError("[SplineToolkit] No SourceObjects found.")
        return
    end

    local minDist    = math.max(self.uiAreaMinDist:getValue(), 0.01)
    local maxDist    = math.max(self.uiAreaMaxDist:getValue(), minDist)
    local halfCenter = self.uiAreaWidthCenter:getValue() * 0.5
    local leftOn     = self:getChoiceActiveOptionString(self.uiAreaLeftEnabled)   == "Enable"
    local centerOn   = self:getChoiceActiveOptionString(self.uiAreaCenterEnabled) == "Enable"
    local rightOn    = self:getChoiceActiveOptionString(self.uiAreaRightEnabled)  == "Enable"
    local terrain    = self:getTerrain()

    -- Laterale Zonen relativ zur Spline-Mitte
    local zones = {}
    if leftOn   then table.insert(zones, { -(halfCenter + self.uiAreaWidthLeft:getValue()), -halfCenter }) end
    if centerOn then table.insert(zones, { -halfCenter, halfCenter }) end
    if rightOn  then table.insert(zones, {  halfCenter, halfCenter + self.uiAreaWidthRight:getValue() }) end

    if #zones == 0 then
        printError("[SplineToolkit] No area zones enabled.")
        return
    end

    local totalWidth = 0
    for _, z in ipairs(zones) do totalWidth = totalWidth + (z[2] - z[1]) end

    local placed = {}  -- {x, z} aller platzierten Objekte für Abstandsprüfung
    local created = 0
    local splineStep = minDist * 0.5
    local attemptsPerStep = math.max(2, math.ceil(totalWidth / minDist) + 1)

    for i = 0, getNumOfChildren(srcSplineTG)-1 do
        local spline = getChildAt(srcSplineTG, i)
        if self:isSpline(spline) then
            local length = getSplineLength(spline)
            local dist = 0

            while dist <= length do
                local t = dist / length
                local sx, sy, sz = getSplinePosition(spline, t)
                local dx, dy, dz = getSplineDirection(spline, t)

                -- Lateraler Rechts-Vektor der Spline
                local rx, rz = -dz, dx
                local rl = math.sqrt(rx*rx + rz*rz)
                if rl > 0 then rx, rz = rx/rl, rz/rl end

                for _ = 1, attemptsPerStep do
                    local zone    = zones[math.random(#zones)]
                    local lateral = zone[1] + math.random() * (zone[2] - zone[1])
                    local px = sx + rx * lateral
                    local pz = sz + rz * lateral
                    local py = sy

                    if terrain then
                        py = getTerrainHeightAtWorldPos(terrain, px, py, pz)
                    end

                    -- Mindestabstand prüfen
                    local tooClose = false
                    for _, p in ipairs(placed) do
                        local ddx, ddz = px - p[1], pz - p[2]
                        if ddx*ddx + ddz*ddz < minDist*minDist then
                            tooClose = true
                            break
                        end
                    end

                    if not tooClose then
                        local src  = getChildAt(srcObjTG, math.random(0, sourceCount-1))
                        local inst = clone(src, false)
                        link(placedTG, inst)
                        setWorldTranslation(inst, px, py, pz)
                        setRotation(inst, 0, math.random() * math.pi * 2, 0)
                        table.insert(placed, {px, pz})
                        created = created + 1
                    end
                end

                dist = dist + splineStep
            end
        end
    end

    print(string.format("[SplineToolkit] Generated %d objects in area.", created))
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	PLACE FENCE 		--------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
function SplineToolkit:isSpline(entityId)
    if entityId == nil or entityId == 0 then return false end
    local ok, isShape = pcall(getHasClassId, entityId, ClassIds.SHAPE)
    if not ok or not isShape then return false end
    local ok2, geom = pcall(getGeometry, entityId)
    if not ok2 or geom == nil or geom == 0 then return false end
    local ok3, isSpline = pcall(getHasClassId, geom, ClassIds.SPLINE)
    return ok3 and isSpline
end

function SplineToolkit:buildAnimatedObjectXml(xmlFile, gateKey)
    local basePath = gateKey .. ".animatedObject"
    local saveId = xmlFile:getString(basePath .. "#saveId")
    if not saveId then return "" end

    local lines = {}
    local function add(indent, text)
        table.insert(lines, string.rep("  ", indent) .. text)
    end

    -- animatedObject tag
    local aoAttrs = ""
    local aoSaveId = xmlFile:getString(basePath .. "#saveId")
    local aoAI = xmlFile:getString(basePath .. "#useAIBlockingRegion")
    if aoSaveId then aoAttrs = aoAttrs .. ' saveId="' .. aoSaveId .. '"' end
    if aoAI then aoAttrs = aoAttrs .. ' useAIBlockingRegion="' .. aoAI .. '"' end
    add(0, "<animatedObject" .. aoAttrs .. ">")

    -- animation
    local duration = xmlFile:getString(basePath .. ".animation#duration")
    if duration then
        add(1, '<animation duration="' .. duration .. '">')

        local partIdx = 0
        while true do
            local partKey = basePath .. ".animation.part(" .. partIdx .. ")"
            local partNode = xmlFile:getString(partKey .. "#node")
            if not partNode then break end

            add(2, '<part node="' .. partNode .. '">')

            local kfIdx = 0
            while true do
                local kfKey = partKey .. ".keyFrame(" .. kfIdx .. ")"
                local kfTime = xmlFile:getString(kfKey .. "#time")
                if not kfTime then break end

                local kfAttrs = ' time="' .. kfTime .. '"'
                local rot = xmlFile:getString(kfKey .. "#rotation")
                local trans = xmlFile:getString(kfKey .. "#translation")
                local scale = xmlFile:getString(kfKey .. "#scale")
                if rot then kfAttrs = kfAttrs .. ' rotation="' .. rot .. '"' end
                if trans then kfAttrs = kfAttrs .. ' translation="' .. trans .. '"' end
                if scale then kfAttrs = kfAttrs .. ' scale="' .. scale .. '"' end

                add(3, "<keyFrame" .. kfAttrs .. "/>")
                kfIdx = kfIdx + 1
            end

            add(2, "</part>")
            partIdx = partIdx + 1
        end

        add(1, "</animation>")
    end

    -- controls
    local triggerNode = xmlFile:getString(basePath .. ".controls#triggerNode")
    if triggerNode then
        local ctrlAttrs = ' triggerNode="' .. triggerNode .. '"'
        local posAction = xmlFile:getString(basePath .. ".controls#posAction")
        local posText = xmlFile:getString(basePath .. ".controls#posText")
        local negText = xmlFile:getString(basePath .. ".controls#negText")
        if posAction then ctrlAttrs = ctrlAttrs .. ' posAction="' .. posAction .. '"' end
        if posText then ctrlAttrs = ctrlAttrs .. ' posText="' .. posText .. '"' end
        if negText then ctrlAttrs = ctrlAttrs .. ' negText="' .. negText .. '"' end
        add(1, "<controls" .. ctrlAttrs .. " />")
    end

    -- sounds
    local soundTags = {"moving", "posEnd", "negEnd"}
    local hasSounds = false
    for _, tag in ipairs(soundTags) do
        if xmlFile:getString(basePath .. ".sounds." .. tag .. "#linkNode") then
            hasSounds = true
            break
        end
    end
    if hasSounds then
        add(1, "<sounds>")
        for _, tag in ipairs(soundTags) do
            local linkNode = xmlFile:getString(basePath .. ".sounds." .. tag .. "#linkNode")
            if linkNode then
                local template = xmlFile:getString(basePath .. ".sounds." .. tag .. "#template")
                local sAttrs = ' linkNode="' .. linkNode .. '"'
                if template then sAttrs = sAttrs .. ' template="' .. template .. '"' end
                add(2, "<" .. tag .. sAttrs .. " />")
            end
        end
        add(1, "</sounds>")
    end

    add(0, "</animatedObject>")
    return table.concat(lines, "\n")
end

function SplineToolkit:loadFenceFromXML(index)
    local values = self.values.fencePlacement
    local fence = values.fenceTable[index]

    if not fence or not fence.xmlFile then
        printWarning("[SplineToolkit] No fence xml defined.")
        return
    end

    local xmlPath = fence.xmlFile:gsub("%$data", gamePath .. "data")

    if not fileExists(xmlPath) then
        printError("[SplineToolkit] Fence XML not found: " .. xmlPath)
        return
    end

    local xmlFile = XMLFile.load("fenceXML", xmlPath)
    if not xmlFile then
        printError("[SplineToolkit] Could not load fence XML.")
        return
    end

    self.selFenceInfo = {
        xmlFile     = xmlPath,
        i3dFile     = nil,
        i3dMappings = {},
        poles       = {},
        panels      = {},
        gates       = {}
    }

	-- I3D Datei-- I3D Datei
	local i3dFile = xmlFile:getString("placeable.base.filename")
	if i3dFile then
		if fence.isCustom then
			-- Nur Dateiname extrahieren (immer!)
			local fileName = i3dFile:match("([^/\\]+%.i3d)$")
			if fileName then
				local xmlDir = fence.xmlFile:match("^(.*[/\\])")
				self.selFenceInfo.i3dFile = xmlDir .. fileName
			else
				printWarning("[SplineToolkit] Could not extract i3d filename.")
			end
		else
			self.selFenceInfo.i3dFile = i3dFile:gsub("%$data", gamePath .. "data")
		end
	end

    -- I3D Mappings lesen
    local i3dMappings = {}
    xmlFile:iterate("placeable.i3dMappings.i3dMapping", function(_, key)
        local id = xmlFile:getString(key .. "#id")
        local node = xmlFile:getString(key .. "#node")
        if id and node then
            i3dMappings[id] = node
        end
    end)
    self.selFenceInfo.i3dMappings = i3dMappings

		-- Segmente durchgehen (wir flatten alles)
	local limitFenceSegment = false

	if fence.xmlFile == "$data/placeables/brandless/fences/US/fence08/fence08.xml"
	or fence.xmlFile == "$data/placeables/brandless/fences/US/fence12/fence12.xml" then
		limitFenceSegment = true
	end

	local fenceSegmentHandled = false

	xmlFile:iterate("placeable.fence.segment", function(_, segKey)

		local segmentClass = xmlFile:getString(segKey .. "#class")

		-- Nur für die beiden speziellen XMLs:
		if limitFenceSegment and segmentClass == "FenceSegment" then
			if fenceSegmentHandled then
				return -- weitere FenceSegment überspringen
			end
			fenceSegmentHandled = true
		end

		-- Poles
		xmlFile:iterate(segKey .. ".poles.pole", function(_, poleKey)
			local nodeId = xmlFile:getString(poleKey .. "#node")
			local radius = xmlFile:getFloat(poleKey .. "#radius") or 0
			if nodeId then
				table.insert(self.selFenceInfo.poles, {
					id = nodeId,
					nodePath = i3dMappings[nodeId],
					radius = radius
				})
			end
		end)

		-- Panels
		xmlFile:iterate(segKey .. ".panels.panel", function(_, panelKey)
			local nodeId = xmlFile:getString(panelKey .. "#node")
			local length = xmlFile:getFloat(panelKey .. "#length") or 0
			if nodeId then
				table.insert(self.selFenceInfo.panels, {
					id = nodeId,
					nodePath = i3dMappings[nodeId],
					length = length
				})
			end
		end)

		-- Gates
		xmlFile:iterate(segKey .. ".gate", function(_, gateKey)
			local nodeId = xmlFile:getString(gateKey .. "#node")
			local length = xmlFile:getFloat(gateKey .. "#length") or 0
			if nodeId then
				local animXml = self:buildAnimatedObjectXml(xmlFile, gateKey)
				table.insert(self.selFenceInfo.gates, {
					id         = nodeId,
					gateXmlKey = gateKey,
					nodePath   = i3dMappings[nodeId],
					length     = length,
					animationXml = animXml
				})
			end
		end)

	end)

    xmlFile:delete()
end

function SplineToolkit:canImportFence()
    if getNumSelected() ~= 1 then
        return false
    end

    local selected = getSelection(0)
    local fenceRoot = self:getPlaceFenceTransformgroup()
    local current = selected

    while current ~= 0 and current ~= fenceRoot do
        if getUserAttribute(current, "isFenceGroup") == true then
            return true
        end
        current = getParent(current)
    end

    return false
end

function SplineToolkit:prepareFenceGroupForSpline(splineIDs)
    local fenceRoot = self:getPlaceFenceTransformgroup()

    if not splineIDs or #splineIDs == 0 then
        return nil
    end

    local firstSpline = splineIDs[1]
    local fenceTG = nil
    local isExistingGroup = false

    -- Walk up from spline looking for isFenceGroup UserAttribute
    local current = getParent(firstSpline)
    while current ~= nil and current ~= 0 do
        if getUserAttribute(current, "isFenceGroup") == true then
            fenceTG = current
            isExistingGroup = true
            break
        end
        current = getParent(current)
    end

    if not isExistingGroup then
        local num = 1
        local function exists(name)
            for i = 0, getNumOfChildren(fenceRoot) - 1 do
                if getName(getChildAt(fenceRoot, i)) == name then
                    return true
                end
            end
            return false
        end

        while exists(string.format("fenceGroup%02d", num)) do
            num = num + 1
        end

        fenceTG = createTransformGroup(string.format("fenceGroup%02d", num))
        link(fenceRoot, fenceTG)
        setUserAttribute(fenceTG, "isFenceGroup", UserAttributeType.BOOLEAN, true)
    end

    local copyMode = self.uiSplineModeGroup and self.uiSplineModeGroup:getActiveIndex() == 1

    for i, splineID in ipairs(splineIDs) do
        if getParent(splineID) ~= fenceTG then
            if copyMode and not isExistingGroup then
                local clonedSpline = clone(splineID, true)
                link(fenceTG, clonedSpline)
                setVisibility(clonedSpline, false)
                splineIDs[i] = clonedSpline
            else
                unlink(splineID)
                link(fenceTG, splineID)
                setVisibility(splineID, false)
            end
        end
    end

    local fenceSub = nil
    local gatesSub = nil

    for i = 0, getNumOfChildren(fenceTG) - 1 do
        local child = getChildAt(fenceTG, i)
        local name = getName(child)

        if name == "fence" then fenceSub = child end
        if name == "gates" then gatesSub = child end
    end

    if not fenceSub then
        fenceSub = createTransformGroup("fence")
        link(fenceTG, fenceSub)
    end

    if not gatesSub then
        gatesSub = createTransformGroup("gates")
        link(fenceTG, gatesSub)
    end

    if isExistingGroup then
        for i = getNumOfChildren(fenceSub) - 1, 0, -1 do
            delete(getChildAt(fenceSub, i))
        end
    end

    self.currentFenceSubTG = fenceSub
    self.currentGateSubTG  = gatesSub

    return fenceTG
end

function SplineToolkit:resolveI3DMappingNode(rootNode, nodePath)
    if not nodePath or nodePath == "" then return nil end

    local current = rootNode

    for part in string.gmatch(nodePath, "[^|]+") do
        local indices = {}
        for num in string.gmatch(part, "%d+") do
            table.insert(indices, tonumber(num))
        end

        for _, idx in ipairs(indices) do
            if getNumOfChildren(current) > idx then
                current = getChildAt(current, idx)
            else
                return nil
            end
        end
    end

    return current
end

function SplineToolkit:selectedIsFenceGroup()
    if getNumSelected() ~= 1 then
        return false, nil
    end

    local selected = getSelection(0)
    local fenceRoot = self:getPlaceFenceTransformgroup()

    -- Walk up the hierarchy to find the fence group
    local fenceGroup = nil
    local current = selected

    while current ~= 0 and current ~= nil do
        if getUserAttribute(current, "isFenceGroup") == true then
            fenceGroup = current
            break
        end
        if current == fenceRoot then
            break
        end
        current = getParent(current)
    end

    -- Also check if the selected node itself is a direct child of fenceRoot (legacy support)
    if not fenceGroup and getParent(selected) == fenceRoot then
        fenceGroup = selected
    end

    if not fenceGroup then
        return false, nil
    end

    local splineIDs = {}

    for i = 0, getNumOfChildren(fenceGroup) - 1 do
        local child = getChildAt(fenceGroup, i)

        if self:isSpline(child) then
            table.insert(splineIDs, child)
        end
    end

    if #splineIDs == 0 then
        return false, nil
    end

    return true, splineIDs
end

function SplineToolkit:importFenceGate(index)
    if not self:canImportFence() then
        printWarning("A fence group must be selected to import a gate.")
        return
    end

    if not self.selFenceInfo or not self.selFenceInfo.i3dFile then
        printError("No fence loaded.")
        return
    end

    local gates = self.selFenceInfo.gates or {}
    if #gates == 0 then
        printWarning("Selected fence has no gates.")
        return
    end

    local gateDef = gates[index]
    if not gateDef then
        printError("Invalid gate index.")
        return
    end

    local cacheNode = loadI3DFile(self.selFenceInfo.i3dFile)
    if cacheNode == 0 then
        printError("Failed to load fence i3d.")
        return
    end

    local gateNode = self:resolveI3DMappingNode(cacheNode, gateDef.nodePath)
    if not gateNode then
        printError("Gate node not found in i3d.")
        delete(cacheNode)
        return
    end

    local cloneGate = clone(gateNode, false)

    local selectedNode = getSelection(0)
    local fenceGroup = nil
    local current = selectedNode

    while current ~= 0 do
        if getUserAttribute(current, "isFenceGroup") == true then
            fenceGroup = current
            break
        end
        current = getParent(current)
    end

    if not fenceGroup then
        printWarning("A fence group must be selected to import a gate.")
        delete(cacheNode)
        return
    end

    local gatesTG = nil
    for i = 0, getNumOfChildren(fenceGroup) - 1 do
        local child = getChildAt(fenceGroup, i)
        if getName(child) == "gates" then
            gatesTG = child
            break
        end
    end

    if not gatesTG then
        gatesTG = createTransformGroup("gates")
        link(fenceGroup, gatesTG)
    end

    link(gatesTG, cloneGate)

    setUserAttribute(cloneGate, "isFenceGate", UserAttributeType.BOOLEAN, true)
    setUserAttribute(cloneGate, "position",    UserAttributeType.FLOAT,   0.0)
    setUserAttribute(cloneGate, "gateLength",  UserAttributeType.FLOAT,   gateDef.length or 0.0)

    self:registerGateAnimation(cloneGate, gateDef)

    local splineIDs = {}
    for i = 0, getNumOfChildren(fenceGroup) - 1 do
        local child = getChildAt(fenceGroup, i)
        if self:isSpline(child) then
            table.insert(splineIDs, child)
        end
    end

    if #splineIDs > 0 then
        local spline = splineIDs[1]
        self:positionGateOnSpline(cloneGate, spline, 0.0, gateDef.length or 0.0)
    end

    delete(cacheNode)

    clearSelection()
    addSelection(cloneGate)
end

function SplineToolkit:positionGateOnSpline(gateNode, spline, positionPercent, gateLength)
    local splineLength = getSplineLength(spline)
    if splineLength <= 0 then
        return
    end

    gateLength = gateLength or 0.0

    local maxSplineForGate = splineLength - gateLength
    if maxSplineForGate < 0 then
        maxSplineForGate = 0
    end

    local normalizedStartPos = (positionPercent / 100.0) * (maxSplineForGate / splineLength)
    local normalizedEndPos = normalizedStartPos + (gateLength / splineLength)
    normalizedEndPos = math.min(1.0, normalizedEndPos)

    local startPos_x, startPos_y, startPos_z = getSplinePosition(spline, normalizedStartPos)
    local endPos_x, endPos_y, endPos_z = getSplinePosition(spline, normalizedEndPos)

    local gateDir_x = endPos_x - startPos_x
    local gateDir_y = endPos_y - startPos_y
    local gateDir_z = endPos_z - startPos_z

    local dirLength = math.sqrt(gateDir_x * gateDir_x + gateDir_y * gateDir_y + gateDir_z * gateDir_z)
    if dirLength > 0 then
        gateDir_x = gateDir_x / dirLength
        gateDir_y = gateDir_y / dirLength
        gateDir_z = gateDir_z / dirLength
    end

    setTranslation(gateNode, startPos_x, startPos_y, startPos_z)

    local angle = math.atan2(gateDir_x, gateDir_z)
    setRotation(gateNode, 0, angle, 0)
end

function SplineToolkit:onGatePositionSliderChanged()
    if getNumSelected() ~= 1 then
        return
    end

    local selectedGate = getSelection(0)
    if getUserAttribute(selectedGate, "isFenceGate") ~= true then
        return
    end

    local positionPercent = self.uiGatePositionSlider:getValue()
    local clampedPosition = math.max(0.0, math.min(100.0, positionPercent))

    setUserAttribute(selectedGate, "position", UserAttributeType.FLOAT, clampedPosition)

    local gateParent = getParent(selectedGate)
    local fenceGroup = getParent(gateParent)

    if not fenceGroup or getUserAttribute(fenceGroup, "isFenceGroup") ~= true then
        return
    end

    local splineIDs = {}
    for i = 0, getNumOfChildren(fenceGroup) - 1 do
        local child = getChildAt(fenceGroup, i)
        if self:isSpline(child) then
            table.insert(splineIDs, child)
        end
    end

    if #splineIDs > 0 then
        local gateLength = getUserAttribute(selectedGate, "gateLength") or 0.0
        self:positionGateOnSpline(selectedGate, splineIDs[1], clampedPosition, gateLength)
    end
end

-- Converts a node name (e.g. "gate4mOpenA") to a 1-indexed path relative to the gate node
-- (e.g. "1" if it's the first child, "1|3" for deeper children)
function SplineToolkit:convertNodeToIndexPath(nodeName, gateDef)
    local mappings = self.selFenceInfo and self.selFenceInfo.i3dMappings
    if not mappings then
        return nodeName
    end

    local fullPath = mappings[nodeName]
    if not fullPath then
        return "0"
    end

    local gatePath = gateDef.nodePath or ""
    local prefix   = gatePath .. "|"

    if fullPath:sub(1, #prefix) == prefix then
        return fullPath:sub(#prefix + 1)
    end

    return "0"
end

function SplineToolkit:registerGateAnimation(gateNode, gateDef)
    local fenceXmlPath = self.selFenceInfo and self.selFenceInfo.xmlFile
    if not fenceXmlPath or fenceXmlPath == "" then
        printWarning("[SplineToolkit] registerGateAnimation: no fence XML path in selFenceInfo")
        return
    end

    -- FenceGroup-Namen über Parent-Kette ermitteln (gate → gates TG → fenceGroup)
    local gatesTG   = getParent(gateNode)
    local fenceGroup = gatesTG and getParent(gatesTG) or nil
    local fenceGroupName = (fenceGroup and fenceGroup ~= 0) and getName(fenceGroup) or "fenceGroup"

    -- Unique Index generieren: [fenceGroupName]_[gateName]_[uniqueId]
    local gateId   = (gateDef.id or "gate"):gsub("[^%w]", "_")
    local uniqueId = self:generateUniqueId(8)
    local nodeName  = gateId .. "_" .. uniqueId
    local indexName = fenceGroupName .. "_" .. nodeName

    -- Node umbenennen: [gateName]_[uniqueId]
    setName(gateNode, nodeName)

    -- Relativer Pfad zur animatedMapObjects.xml vom Mod-Root
    local relPath = self:getOrCreateAnimationMapObjectsFile()
    if not relPath then
        printWarning("[SplineToolkit] registerGateAnimation: could not get animXML path")
        return
    end

    -- User Attributes setzen
    setUserAttribute(gateNode, "index",       UserAttributeType.STRING,   indexName)
    setUserAttribute(gateNode, "onCreate",    UserAttributeType.CALLBACK, "AnimatedMapObject.onCreate")
    setUserAttribute(gateNode, "xmlFilename", UserAttributeType.STRING,   relPath)

    -- animatedObject in die XML-Datei schreiben
    self:writeGateAnimToXml(gateDef, indexName)

    print("[SplineToolkit] Gate registered: " .. indexName)
end

function SplineToolkit:generateUniqueId(length)
    local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    math.randomseed(math.floor((getTime() * 1000000) % 2147483647))
    local id = ""
    for _ = 1, length do
        local i = math.random(1, #chars)
        id = id .. chars:sub(i, i)
    end
    return id
end

function SplineToolkit:copyXmlNodeRecursive(srcId, srcPath, dstId, dstPath, saveId, gateDef)
    local numAttrs = getXMLNumOfAttributes(srcId, srcPath)
    for i = 0, numAttrs - 1 do
        local attrName = getXMLAttributeName(srcId, srcPath, i)
        if attrName then
            local val = getXMLString(srcId, srcPath .. "#" .. attrName)
            if val ~= nil then
                if saveId ~= nil and attrName == "saveId" then
                    val = saveId
                elseif gateDef ~= nil and (attrName == "node" or attrName == "linkNode" or attrName == "triggerNode") then
                    val = self:convertNodeToIndexPath(val, gateDef)
                end
                setXMLString(dstId, dstPath .. "#" .. attrName, val)
            end
        end
    end

    local numChildren = getXMLNumOfChildren(srcId, srcPath)
    local childIndexCounter = {}
    for i = 0, numChildren - 1 do
        local childName = getXMLElementName(srcId, srcPath .. ".*(" .. i .. ")")
        if childName then
            childIndexCounter[childName] = (childIndexCounter[childName] or -1) + 1
            local idx = childIndexCounter[childName]
            local srcChild = srcPath .. "." .. childName .. "(" .. idx .. ")"
            local dstChild = dstPath .. "." .. childName .. "(" .. idx .. ")"
            self:copyXmlNodeRecursive(srcId, srcChild, dstId, dstChild, saveId, gateDef)
        end
    end
end

function SplineToolkit:writeGateAnimToXml(gateDef, saveId)
    local fullPath = SplineToolkit.FENCE_CALLBACK_ANIMATION_FILENAME
    if not fullPath then return end

    local xmlBlock = gateDef.animationXml
    if not xmlBlock or xmlBlock == "" then
        printWarning("[SplineToolkit] writeGateAnimToXml: no animationXml in gateDef")
        return
    end

    -- animationXml als In-Memory XML laden
    local srcId = loadXMLFileFromMemory("AnimSrc", xmlBlock)
    if not srcId or srcId == 0 then
        printError("[SplineToolkit] writeGateAnimToXml: konnte animationXml nicht parsen")
        return
    end

    -- Ziel-XML laden oder neu erstellen
    local dstId
    if fileExists(fullPath) then
        dstId = loadXMLFile("AnimDst", fullPath)
    end
    if not dstId or dstId == 0 then
        dstId = createXMLFile("AnimDst", fullPath, "animatedObjects")
    end
    if not dstId or dstId == 0 then
        delete(srcId)
        printError("[SplineToolkit] writeGateAnimToXml: kann Ziel-XML nicht öffnen/erstellen: " .. fullPath)
        return
    end

    -- Nächsten freien Slot finden
    local entryIdx = 0
    while hasXMLProperty(dstId, "animatedObjects.animatedObject(" .. entryIdx .. ")") do
        entryIdx = entryIdx + 1
    end

    local dstPath = "animatedObjects.animatedObject(" .. entryIdx .. ")"

    -- Rekursiv kopieren; Quellpfad ist der Root-Elementname "animatedObject"
    self:copyXmlNodeRecursive(srcId, "animatedObject", dstId, dstPath, saveId, gateDef)

    saveXMLFile(dstId)
    delete(srcId)
    delete(dstId)
    print("[SplineToolkit] Wrote animatedObject saveId=" .. saveId .. " to " .. fullPath)
end

function SplineToolkit:checkGateAnimState()
    local gateNode = self.selectedGateNode
    if not gateNode then
        return "No Gate", {0.7, 0.7, 0.7}
    end

    -- UserAttribute-Checks
    local indexVal    = getUserAttribute(gateNode, "index")
    local onCreateVal = getUserAttribute(gateNode, "onCreate")
    local xmlFileVal  = getUserAttribute(gateNode, "xmlFilename")

    if not indexVal or indexVal == "" then
        return "Missing userAttribute: index", {0.9, 0.3, 0.3}
    end
    if onCreateVal ~= "AnimatedMapObject.onCreate" then
        return "Wrong userAttribute: onCreate", {0.9, 0.3, 0.3}
    end
    if not xmlFileVal or xmlFileVal == "" then
        return "Missing userAttribute: xmlFilename", {0.9, 0.3, 0.3}
    end

    -- Datei-Check
    local fullPath = SplineToolkit.FENCE_CALLBACK_ANIMATION_FILENAME
    if not fullPath or not fileExists(fullPath) then
        return "XML File Missing", {0.9, 0.3, 0.3}
    end

    local xmlId = loadXMLFile("AnimStateCheck", fullPath)
    if not xmlId or xmlId == 0 then
        return "Cannot Read XML", {0.9, 0.3, 0.3}
    end

    -- Eintrag per saveId suchen
    local entryIdx, i = nil, 0
    while true do
        local sid = getXMLString(xmlId, "animatedObjects.animatedObject(" .. i .. ")#saveId")
        if sid == nil then break end
        if sid == indexVal then entryIdx = i; break end
        i = i + 1
    end

    if not entryIdx then
        delete(xmlId)
        return "Not in XML", {1.0, 0.9, 0.4}
    end

    local base = "animatedObjects.animatedObject(" .. entryIdx .. ")"

    -- Animation vorhanden?
    if not getXMLString(xmlId, base .. ".animation#duration") then
        delete(xmlId)
        return "No Animation", {1.0, 0.5, 0.3}
    end

    -- Mindestens ein Part mit node vorhanden?
    local partNode = getXMLString(xmlId, base .. ".animation.part(0)#node")
    if not partNode or partNode == "" then
        delete(xmlId)
        return "No Anim Parts", {1.0, 0.5, 0.3}
    end

    -- Node-Pfade konvertiert? (nur Ziffern und | erlaubt)
    local function isIndexPath(val)
        return val ~= nil and val:match("^[%d|]+$") ~= nil
    end

    if not isIndexPath(partNode) then
        delete(xmlId)
        return "Node Not Converted", {1.0, 0.5, 0.3}
    end

    local triggerNode = getXMLString(xmlId, base .. ".controls#triggerNode")
    if triggerNode and not isIndexPath(triggerNode) then
        delete(xmlId)
        return "Trigger Not Converted", {1.0, 0.5, 0.3}
    end

    -- Sounds: mindestens ein linkNode konvertiert?
    for _, tag in ipairs({"moving", "posEnd", "negEnd"}) do
        local linkNode = getXMLString(xmlId, base .. ".sounds." .. tag .. "#linkNode")
        if linkNode and not isIndexPath(linkNode) then
            delete(xmlId)
            return "Sound Node Not Converted", {1.0, 0.5, 0.3}
        end
    end

    delete(xmlId)
    return "OK", {0.4, 0.85, 0.4}
end

function SplineToolkit:validateAnimationMapXml()
    print("=== [SplineToolkit] Fence Animation XML Validation ===")

    local fullPath = SplineToolkit.FENCE_CALLBACK_ANIMATION_FILENAME
    if not fullPath or fullPath == "" then
        printError("[Validate] FENCE_CALLBACK_ANIMATION_FILENAME not set.")
        return
    end

    local function isIndexPath(val)
        return val ~= nil and val:match("^[%d|]+$") ~= nil
    end

    -- Load XML and collect all entries
    local xmlId = nil
    local xmlEntries = {}
    local xmlEntryCount = 0

    if fileExists(fullPath) then
        xmlId = loadXMLFile("AnimValidate", fullPath)
        if not xmlId or xmlId == 0 then
            printError("[Validate] Cannot read XML: " .. fullPath)
            return
        end
        local i = 0
        while true do
            local sid = getXMLString(xmlId, "animatedObjects.animatedObject(" .. i .. ")#saveId")
            if sid == nil then break end
            xmlEntries[sid] = i
            xmlEntryCount = xmlEntryCount + 1
            i = i + 1
        end
        print(string.format("[Validate] XML: %d entr%s | %s", xmlEntryCount, xmlEntryCount == 1 and "y" or "ies", fullPath))
    else
        printWarning("[Validate] XML file not found: " .. fullPath)
    end

    -- Collect all gates from scene — fence groups may live anywhere, not just under fenceRoot.
    local sceneGates = {}
    local fenceGroupCount = 0

    local function collectGatesFromNode(node)
        for i = 0, getNumOfChildren(node) - 1 do
            local child = getChildAt(node, i)
            if getUserAttribute(child, "isFenceGroup") == true then
                fenceGroupCount = fenceGroupCount + 1
                local groupName = getName(child)
                for j = 0, getNumOfChildren(child) - 1 do
                    local sub = getChildAt(child, j)
                    if getName(sub) == "gates" then
                        for k = 0, getNumOfChildren(sub) - 1 do
                            local gateNode = getChildAt(sub, k)
                            if getUserAttribute(gateNode, "isFenceGate") == true then
                                table.insert(sceneGates, {
                                    index     = getUserAttribute(gateNode, "index"),
                                    onCreate  = getUserAttribute(gateNode, "onCreate"),
                                    xmlFile   = getUserAttribute(gateNode, "xmlFilename"),
                                    node      = gateNode,
                                    groupName = groupName,
                                    name      = getName(gateNode),
                                })
                            end
                        end
                        break
                    end
                end
            else
                collectGatesFromNode(child)
            end
        end
    end

    collectGatesFromNode(getRootNode())

    print(string.format("[Validate] Scene: %d fence group(s), %d gate(s)", fenceGroupCount, #sceneGates))

    -- Check XML for orphaned entries (no matching scene gate)
    if xmlId then
        for sid, _ in pairs(xmlEntries) do
            local found = false
            for _, gate in ipairs(sceneGates) do
                if gate.index == sid then found = true; break end
            end
            if not found then
                printWarning(string.format("[Validate] ORPHAN: XML saveId='%s' has no gate in scene.", sid))
            end
        end
    end

    -- Validate each scene gate
    local okCount, errCount, warnCount = 0, 0, 0

    for _, gate in ipairs(sceneGates) do
        local prefix = string.format("[Validate][%s > %s]", gate.groupName, gate.name)
        local gateOk = true

        -- UserAttribute checks
        if not gate.index or gate.index == "" then
            printError(prefix .. " Missing userAttribute: index")
            errCount = errCount + 1; gateOk = false
        end
        if gate.onCreate ~= "AnimatedMapObject.onCreate" then
            printError(string.format("%s Wrong/missing onCreate: '%s'", prefix, tostring(gate.onCreate)))
            errCount = errCount + 1; gateOk = false
        end
        if not gate.xmlFile or gate.xmlFile == "" then
            printWarning(prefix .. " Missing userAttribute: xmlFilename")
            warnCount = warnCount + 1
        end

        -- XML checks
        if xmlId and gate.index and gate.index ~= "" then
            local entryIdx = xmlEntries[gate.index]
            if entryIdx == nil then
                printWarning(string.format("%s Not in XML (index='%s')", prefix, gate.index))
                warnCount = warnCount + 1; gateOk = false
            else
                local base = "animatedObjects.animatedObject(" .. entryIdx .. ")"

                if not getXMLString(xmlId, base .. ".animation#duration") then
                    printError(prefix .. " No animation duration in XML.")
                    errCount = errCount + 1; gateOk = false
                end

                local partNode = getXMLString(xmlId, base .. ".animation.part(0)#node")
                if not partNode or partNode == "" then
                    printError(prefix .. " No animation parts in XML.")
                    errCount = errCount + 1; gateOk = false
                elseif not isIndexPath(partNode) then
                    printError(string.format("%s Anim part node not converted: '%s'", prefix, partNode))
                    errCount = errCount + 1; gateOk = false
                end

                local triggerNode = getXMLString(xmlId, base .. ".controls#triggerNode")
                if triggerNode and not isIndexPath(triggerNode) then
                    printError(string.format("%s TriggerNode not converted: '%s'", prefix, triggerNode))
                    errCount = errCount + 1; gateOk = false
                end

                for _, tag in ipairs({"moving", "posEnd", "negEnd"}) do
                    local linkNode = getXMLString(xmlId, base .. ".sounds." .. tag .. "#linkNode")
                    if linkNode and not isIndexPath(linkNode) then
                        printError(string.format("%s Sound '%s' linkNode not converted: '%s'", prefix, tag, linkNode))
                        errCount = errCount + 1; gateOk = false
                    end
                end
            end
        elseif not xmlId then
            printWarning(prefix .. " Skipping XML check (file not found).")
            warnCount = warnCount + 1
        end

        if gateOk then okCount = okCount + 1 end
    end

    if xmlId then delete(xmlId) end

    print(string.format("=== [Validate] %d OK | %d error(s) | %d warning(s) ===", okCount, errCount, warnCount))
end

function SplineToolkit:collectGateExclusionZones(fenceTG, splineID)
    local zones = {}
    local splineLength = getSplineLength(splineID)
    if splineLength <= 0 then return zones end

    local gatesTG = nil
    for i = 0, getNumOfChildren(fenceTG) - 1 do
        local child = getChildAt(fenceTG, i)
        if getName(child) == "gates" then
            gatesTG = child
            break
        end
    end
    if not gatesTG then return zones end

    for i = 0, getNumOfChildren(gatesTG) - 1 do
        local gateNode = getChildAt(gatesTG, i)
        if getUserAttribute(gateNode, "isFenceGate") == true then
            local posPercent = getUserAttribute(gateNode, "position") or 0.0
            local gateLength = getUserAttribute(gateNode, "gateLength") or 0.0

            local maxSplineForGate = splineLength - gateLength
            if maxSplineForGate < 0 then maxSplineForGate = 0 end

            local tStart = (posPercent / 100.0) * (maxSplineForGate / splineLength)
            local tEnd = tStart + (gateLength / splineLength)
            tEnd = math.min(1.0, tEnd)

            if tEnd > tStart then
                table.insert(zones, {tStart = tStart, tEnd = tEnd})
            end
        end
    end

    table.sort(zones, function(a, b) return a.tStart < b.tStart end)
    return zones
end

function SplineToolkit:getFenceSegments(zones)
    local segments = {}
    local cursor = 0.0

    for _, zone in ipairs(zones) do
        if zone.tStart > cursor then
            table.insert(segments, {tStart = cursor, tEnd = zone.tStart})
        end
        cursor = zone.tEnd
    end

    if cursor < 1.0 then
        table.insert(segments, {tStart = cursor, tEnd = 1.0})
    end

    return segments
end

function SplineToolkit:generateFenceOnSpline()
    if not self.selFenceInfo or not self.selFenceInfo.i3dFile then
        printError("No fence loaded.")
        return
    end

    local splineIDs = {}
    local isFenceGroup, groupSplines = self:selectedIsFenceGroup()

    if isFenceGroup then
        splineIDs = groupSplines
    else
        local numSelected = getNumSelected()
        if numSelected < 1 then
            printError("Select splines or a fence group.")
            return
        end
        for i = 0, numSelected - 1 do
            local id = getSelection(i)
            if self:isSpline(id) then
                table.insert(splineIDs, id)
            end
        end
    end

    if #splineIDs == 0 then
        printError("No valid splines found.")
        return
    end

    local fenceTG  = self:prepareFenceGroupForSpline(splineIDs)
    local cacheNode = loadI3DFile(self.selFenceInfo.i3dFile)
    if cacheNode == 0 then
        printError("Failed to load fence i3d.")
        return
    end
    link(fenceTG, cacheNode)

    local panels = self.selFenceInfo.panels or {}
    local poles  = self.selFenceInfo.poles  or {}
    if #panels == 0 then
        delete(cacheNode)
        return
    end

    local baseLength      = panels[1].length or 3
    local globalStartPole = self:getChoiceBoolean(self.uiFencePlaceStartPole)
    local globalEndPole   = self:getChoiceBoolean(self.uiFencePlaceEndPole)

    for _, splineID in ipairs(splineIDs) do
        if getHasClassId(splineID, ClassIds.SHAPE) and getHasClassId(getGeometry(splineID), ClassIds.SPLINE) then
			local splineType      = self:getSplineType(splineID)

            local splineLength = getSplineLength(splineID)
            local isClosed     = getIsSplineClosed(splineID)

            local placeStartPole = globalStartPole
            local placeEndPole   = globalEndPole
            if isClosed then
                placeStartPole = true
                placeEndPole   = false
            end

            local nodePositions = {}

            -- Collect gate exclusion zones and compute fence segments
            local gateZones = self:collectGateExclusionZones(fenceTG, splineID)
            local fenceSegments = self:getFenceSegments(gateZones)

            -- If no gates, fenceSegments = {{tStart=0, tEnd=1}} (full spline)

            ------------------------------------------------
            -- PANEL GENERATION + NODE TRACKING
            ------------------------------------------------
            -- Build set of gate boundary t-values to suppress poles there
            local gateBoundarySet = {}
            for _, zone in ipairs(gateZones) do
                gateBoundarySet[zone.tStart] = true
                gateBoundarySet[zone.tEnd] = true
            end

            local function isGateBoundary(t)
                for bt, _ in pairs(gateBoundarySet) do
                    if math.abs(t - bt) < 0.0001 then return true end
                end
                return false
            end

            if splineType == "CUBIC" then
                for _, seg in ipairs(fenceSegments) do
                    local segSplineLen = (seg.tEnd - seg.tStart) * splineLength
                    if segSplineLen > 0 then
                        local ratio  = segSplineLen / baseLength
                        local nFloor = math.max(1, math.floor(ratio))
                        local nCeil  = math.max(1, math.ceil(ratio))

                        local scaleFloor = segSplineLen / (nFloor * baseLength)
                        local scaleCeil  = segSplineLen / (nCeil  * baseLength)

                        local errFloor = math.abs(scaleFloor - 1)
                        local errCeil  = math.abs(scaleCeil  - 1)

                        local count = nFloor
                        if errCeil < errFloor then
                            count = nCeil
                        end

                        local step = segSplineLen / count

                        for s = 0, count - 1 do
                            local t0 = seg.tStart + (s * step) / splineLength
                            local t1 = seg.tStart + ((s + 1) * step) / splineLength

                            local x0,y0,z0 = getSplinePosition(splineID,t0)
                            local x1,y1,z1 = getSplinePosition(splineID,t1)

                            local dx = x1-x0
                            local dy = y1-y0
                            local dz = z1-z0
                            local len = math.sqrt(dx*dx+dy*dy+dz*dz)

                            if len > 0 then
                                dx,dy,dz = dx/len,dy/len,dz/len
                                local scale = len/baseLength

                                self:placeFencePanel(self.currentFenceSubTG,cacheNode, panels,{x0,y0,z0},{x1,y1,z1},{dx,dy,dz},scale)

                                if s == 0 then
                                    local noPole = isGateBoundary(t0)
                                    table.insert(nodePositions,{x0,y0,z0,dx,dz, noPole = noPole})
                                end
                                local noPole = isGateBoundary(t1)
                                table.insert(nodePositions,{x1,y1,z1,dx,dz, noPole = noPole})
                            end
                        end
                    end
                end

            else
                local numCV    = getSplineNumOfCV(splineID)
                local maxIndex = numCV - 2
                if isClosed then maxIndex = numCV - 1 end

                -- Pre-calculate cumulative lengths for correct t mapping
                local cvSegLengths = {}
                local totalLinearLength = 0
                for s = 0, maxIndex do
                    local ni = s + 1
                    if ni >= numCV then ni = 0 end
                    local ax,ay,az = getSplineCV(splineID, s)
                    local bx,by,bz = getSplineCV(splineID, ni)
                    local dl = math.sqrt((bx-ax)^2 + (by-ay)^2 + (bz-az)^2)
                    table.insert(cvSegLengths, dl)
                    totalLinearLength = totalLinearLength + dl
                end

                local cumLength = 0
                for s = 0, maxIndex do
                    local nextIndex = s + 1
                    if nextIndex >= numCV then nextIndex = 0 end

                    local x0,y0,z0 = getSplineCV(splineID,s)
                    local x1,y1,z1 = getSplineCV(splineID,nextIndex)

                    local dx = x1-x0
                    local dy = y1-y0
                    local dz = z1-z0
                    local segLength = cvSegLengths[s + 1]

                    if segLength > 0 then
                        dx,dy,dz = dx/segLength,dy/segLength,dz/segLength

                        local cvTStart = cumLength / totalLinearLength
                        local cvTEnd = (cumLength + segLength) / totalLinearLength

                        -- Find fence segments that overlap with this CV segment
                        for _, fSeg in ipairs(fenceSegments) do
                            local overlapStart = math.max(cvTStart, fSeg.tStart)
                            local overlapEnd = math.min(cvTEnd, fSeg.tEnd)

                            if overlapEnd > overlapStart then
                                -- Map overlap back to local CV segment coordinates
                                local localStart = (overlapStart - cvTStart) / (cvTEnd - cvTStart)
                                local localEnd = (overlapEnd - cvTStart) / (cvTEnd - cvTStart)
                                local localLength = (localEnd - localStart) * segLength

                                if localLength > 0 then
                                    local ratio  = localLength / baseLength
                                    local nFloor = math.max(1, math.floor(ratio))
                                    local nCeil  = math.max(1, math.ceil(ratio))

                                    local scaleFloor = localLength / (nFloor * baseLength)
                                    local scaleCeil  = localLength / (nCeil  * baseLength)

                                    local errFloor = math.abs(scaleFloor - 1)
                                    local errCeil  = math.abs(scaleCeil  - 1)

                                    local panelCount = nFloor
                                    if errCeil < errFloor then
                                        panelCount = nCeil
                                    end

                                    local step  = localLength / panelCount
                                    local scale = step / baseLength

                                    local startOffset = localStart * segLength

                                    for p = 0, panelCount - 1 do
                                        local px = x0 + dx*(startOffset + p*step)
                                        local py = y0 + dy*(startOffset + p*step)
                                        local pz = z0 + dz*(startOffset + p*step)

                                        local endX = px + dx*step
                                        local endY = py + dy*step
                                        local endZ = pz + dz*step

                                        self:placeFencePanel(self.currentFenceSubTG,cacheNode, panels,{px,py,pz},{endX,endY,endZ},{dx,dy,dz},scale)

                                        if #nodePositions == 0 and p == 0 then
                                            local tPos = overlapStart
                                            table.insert(nodePositions,{px,py,pz,dx,dz, noPole = isGateBoundary(tPos)})
                                        end
                                        local tPos = overlapStart + (p + 1) * (overlapEnd - overlapStart) / panelCount
                                        table.insert(nodePositions,{endX,endY,endZ,dx,dz, noPole = isGateBoundary(tPos)})
                                    end
                                end
                            end
                        end
                    end
                    cumLength = cumLength + segLength
                end
            end

            ------------------------------------------------
            -- POLE GENERATION (ISOLATED PER SPLINE)
            ------------------------------------------------
            if #poles > 0 then
                local total = #nodePositions
                for i = 1, total do
                    local np = nodePositions[i]
                    local x,y,z,dx,dz = np[1],np[2],np[3],np[4],np[5]
                    local isFirst = (i == 1)
                    local isLast  = (i == total)

                    if np.noPole then
                        -- Skip pole at gate boundaries
                    else
                        local place = false
                        if isClosed then
                            place = true
                        else
                            if isFirst and placeStartPole then
                                place = true
                            elseif isLast and placeEndPole then
                                place = true
                            elseif not isFirst and not isLast then
                                place = true
                            end
                        end

                        if place then
                            self:placeFencePole(self.currentFenceSubTG,
                                cacheNode,poles,x,y,z,dx,dz,nil,nil)
                        end
                    end
                end
            end
        end
    end

    delete(cacheNode)
end

function SplineToolkit:placeFencePanel(fenceTG, cacheNode, panels, startPos, endPos, dir, scale)
    local panelDef = panels[math.random(1, #panels)]
    local panelNode = self:resolveI3DMappingNode(cacheNode, panelDef.nodePath)
    if not panelNode then return nil end

    local segment = clone(panelNode, false)
    link(fenceTG, segment)

    local terrain = self:getTerrain()

    local startX, startZ = startPos[1], startPos[3]
    local endX, endZ     = endPos[1],   endPos[3]

    local startY = startPos[2]
    local endY   = endPos[2]

    if terrain then
        startY = getTerrainHeightAtWorldPos(terrain, startX, 0, startZ)
        endY   = getTerrainHeightAtWorldPos(terrain, endX,   0, endZ)
    end

    -- 3D Richtungsvektor
    local dx = endX - startX
    local dy = endY - startY
    local dz = endZ - startZ

    local len = math.sqrt(dx*dx + dy*dy + dz*dz)
    if len ~= 0 then
        dx = dx / len
        dy = dy / len
        dz = dz / len
    end

    -- Yaw (Rotation um Y)
    local ry = math.atan2(dx, dz)

    -- Pitch (Rotation um X)
    local rx = -math.atan2(dy, math.sqrt(dx*dx + dz*dz))

    setWorldTranslation(segment, startX, startY, startZ)
    setWorldRotation(segment, rx, ry, 0)

    setScale(segment, 1, 1, scale)
	
	if self.uiFencePlaceYOffset:getValue() == 1 then

		local terrain = self:getTerrain()
		if terrain then

			local startX = startPos[1]
			local startZ = startPos[3]
			local endX   = endPos[1]
			local endZ   = endPos[3]

			local startY = getTerrainHeightAtWorldPos(terrain, startX, 0, startZ)
			local endY   = getTerrainHeightAtWorldPos(terrain, endX,   0, endZ)

			setWorldTranslation(segment, startX, startY, startZ)

			local ry = math.atan2(dir[1], dir[3])
			setWorldRotation(segment, 0, ry, 0)

			local yOffset = endY - startY

			local function applyYOffset(node)
				if node == nil or node == 0 then return end

				if getHasClassId(node, ClassIds.SHAPE) then
					local okMat, numMats = pcall(getNumOfMaterials, node)
					if okMat then
						for m = 0, numMats - 1 do
							local okParam = pcall(getShaderParameter, node, "yOffset", m)
							if okParam then
								setShaderParameter(node, "yOffset", yOffset, 0, 0, 0, false, m)
							end
						end
					end
				end

				for i = 0, getNumOfChildren(node) - 1 do
					applyYOffset(getChildAt(node, i))
				end
			end

			applyYOffset(segment)
		end
	end
    return segment
end

function SplineToolkit:placeFencePole(fenceTG, cacheNode, poles, x,y,z, dx,dz,prevDirX, prevDirZ)
    local poleDef = poles[math.random(1, #poles)]
    local poleNode = self:resolveI3DMappingNode(cacheNode, poleDef.nodePath)
    if not poleNode then return end

    local pole = clone(poleNode, false)
    link(fenceTG, pole)

    local terrain = self:getTerrain()
    local terrainY = y

    if terrain then
        terrainY = getTerrainHeightAtWorldPos(terrain, x, 0, z)
    end

    setWorldTranslation(pole, x, terrainY, z)

    local currX = dx
    local currZ = dz

    local rx, rz

    if prevDirX then
        rx = prevDirX + currX
        rz = prevDirZ + currZ
    else
        rx = currX
        rz = currZ
    end

    local rlen = math.sqrt(rx*rx + rz*rz)
    if rlen ~= 0 then
        rx = rx / rlen
        rz = rz / rlen
    end

    local ry = math.atan2(rx, rz)
    setWorldRotation(pole, 0, ry, 0)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	EXPORT SPLINE		-----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SplineToolkit:exportSplineToObj()
    if getNumSelected() == 0 then
        printError("[SplineToolkit] Select at least one spline.")
        return
    end

    local exportPath = self:validateExportPath(self.uiExportOBJPath:getValue())
    if not exportPath then
        return
    end

    local filename

    if self.uiExportUseCustomFilename:getValue() then
        local custom = self.uiExportCustomFilename:getValue()
        if custom ~= nil and custom ~= "" then
            filename = custom:gsub("%s+", "_") .. ".obj"
        else
            filename = "SplineExport.obj"
        end
    else
        filename = "SplineExport.obj"
    end

    local objFilePath = exportPath .. filename

    local file = createFile(objFilePath, FileAccess.WRITE)

    if file == 0 then
        printError("[SplineToolkit] Could not create file: " .. objFilePath)
        return
    end

    ------------------------------------------------
    -- HEADER
    ------------------------------------------------
    fileWrite(file, "# Exported by SplineToolkit by Aslan\n")

    local meshType  = self.uiExportType:getValue()
    local distType  = self.uiExportDistanceType:getValue()
    local fixedDist = self.uiExportDistance:getValue()
    local minDist   = self.uiExportMinDistance:getValue()
    local minAngle  = math.rad(self.uiExportMinAngle:getValue())

    local globalVertexCount = 0

    for s = 0, getNumSelected() - 1 do
        local splineID = getSelection(s)

        if getHasClassId(splineID, ClassIds.SHAPE) and getHasClassId(getGeometry(splineID), ClassIds.SPLINE) then
            local vertexIndices = {}
            if meshType == 1 then
                -- Only original CVs
                local numCVs = getSplineNumOfCV(splineID)
                for i = 0, numCVs - 1 do
                    local x,y,z = getSplineCV(splineID, i)
                    fileWrite(file, string.format("v %.6f %.6f %.6f\n", x,y,z))
                    globalVertexCount = globalVertexCount + 1
                    table.insert(vertexIndices, globalVertexCount)
                end
            else
                local length = getSplineLength(splineID)
                local t = 0.0
                local internalStep = 0.05

                local lastX,lastY,lastZ = nil,nil,nil
                local lastDirX,lastDirY,lastDirZ = nil,nil,nil

                while t <= length do

                    local px,py,pz = getSplinePosition(splineID, t/length)
                    local dx,dy,dz = getSplineDirection(splineID, t/length)

                    local addVertex = false

                    if not lastX then
                        addVertex = true
                    else
                        local dist = math.sqrt((px-lastX)^2 + (py-lastY)^2 + (pz-lastZ)^2)

                        if distType == 1 then
                            if dist >= fixedDist then
                                addVertex = true
                            end
                        else
                            if dist >= minDist then
                                local dot = dx*lastDirX + dy*lastDirY + dz*lastDirZ
                                dot = math.max(-1, math.min(1, dot))
                                local angle = math.acos(dot)
                                if angle >= minAngle then
                                    addVertex = true
                                end
                            end
                        end
                    end

                    if addVertex then
                        fileWrite(file, string.format("v %.6f %.6f %.6f\n", px,py,pz))
                        globalVertexCount = globalVertexCount + 1
                        table.insert(vertexIndices, globalVertexCount)

                        lastX,lastY,lastZ = px,py,pz
                        lastDirX,lastDirY,lastDirZ = dx,dy,dz
                    end

                    t = t + internalStep
                end
                local px,py,pz = getSplinePosition(splineID, 1.0)
                fileWrite(file, string.format("v %.6f %.6f %.6f\n", px,py,pz))
                globalVertexCount = globalVertexCount + 1
                table.insert(vertexIndices, globalVertexCount)
            end

            if #vertexIndices > 1 then
                fileWrite(file, "l ")
                for _, idx in ipairs(vertexIndices) do
                    fileWrite(file, tostring(idx) .. " ")
                end
                fileWrite(file, "\n")
            end
        else
            print("Selection contains non-spline object.")
        end
    end

    delete(file)
    print("Export completed: " .. objFilePath)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	GEN ROAD MESH		-----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
function SplineToolkit:getChildByName(parent, name)
    if parent == 0 or parent == nil then return nil end
    for i = 0, getNumOfChildren(parent) - 1 do
        local c = getChildAt(parent, i)
        if getName(c) == name then
            return c
        end
    end
    return nil
end

function SplineToolkit:linkI3DRoadChildren(i3dRoot, targetTG)
    for i = getNumOfChildren(i3dRoot) - 1, 0, -1 do
        local c = getChildAt(i3dRoot, i)
        link(targetTG, c)
    end
    delete(i3dRoot)
end

function SplineToolkit:generateRoad()
    if getNumSelected() ~= 1 then
        printError("Select exactly one spline.")
        return
    end

    local spline = getSelection(0)

    if not getHasClassId(getGeometry(spline), ClassIds.SPLINE) then
        printError("Selected object is not a spline.")
        return
    end

    local roadName = (self.uiRoadName:getValue() or ""):match("^%s*(.-)%s*$")

    if roadName == "" then
        printError("[SplineToolkit] Enter a Road Name.")
        return
    end

    local mainTG = self:getRoadTransformgroup()
    local parent = getParent(spline)
    local alreadyRoadSpline = false

    if parent ~= nil and parent ~= 0 then
        if getParent(parent) == mainTG then
            alreadyRoadSpline = true
        end
    end

    local existingTG = self:getChildByName(mainTG, roadName)

    if not alreadyRoadSpline and existingTG ~= nil then
        YesNoDialog.show(
            "Road already exists",
            "A road group named '" .. roadName .. "' already exists.\nDo you want to overwrite it?",
            function(result)
                if result == true then
                    self:generateRoadExecute(spline)
                else
                    print("[SplineToolkit] Road generation cancelled.")
                end

            end, "Overwrite", "Cancel")
        return
    end

    self:generateRoadExecute(spline)
end
function SplineToolkit:generateRoadExecute(spline)
    local segments   = self:buildAdaptiveSegments(spline)
    local alignEdges = self:getChoiceBoolean(self.uiGenRoadAlignEdges)

    local vertices, uvs, faces = self:buildMesh(spline, segments, alignEdges)
    local trafficData = self:buildTrafficSplines(spline, segments)

    self:exportRoad(spline, vertices, uvs, faces, trafficData)
end

function SplineToolkit:buildAdaptiveSegments(spline)

    local segments = {}

    local minLen   = math.max(self.uiGenRoadMinSegLenght:getValue(), 0.01)
    local minAngle = math.rad(self.uiGenRoadMinAngle:getValue())

    local splineLen = getSplineLength(spline)

    local sampleDist = math.min(minLen * 0.25, 0.5)
    local dt = sampleDist / splineLen

    local segStartT = 0.0

    local startPx, startPy, startPz = getSplinePosition(spline, segStartT)
    local startDx, startDy, startDz = getSplineDirection(spline, segStartT)

    -- NORMALIZE START DIR
    local len = MathUtil.vector3Length(startDx,startDy,startDz)
    if len > 0.0001 then
        startDx, startDy, startDz = startDx/len, startDy/len, startDz/len
    end

    local accLen = 0.0
    local t = dt

    while t <= 1.0 do

        local px, py, pz = getSplinePosition(spline, t)
        local dx, dy, dz = getSplineDirection(spline, t)

        -- NORMALIZE CURRENT DIR
        local len2 = MathUtil.vector3Length(dx,dy,dz)
        if len2 > 0.0001 then
            dx, dy, dz = dx/len2, dy/len2, dz/len2
        end

        ------------------------------------------------
        -- DISTANCE (JETZT 3D!)
        ------------------------------------------------
        local ddx = px - startPx
        local ddy = py - startPy
        local ddz = pz - startPz
        accLen = math.sqrt(ddx*ddx + ddy*ddy + ddz*ddz)

        ------------------------------------------------
        -- ANGLE (JETZT 3D!)
        ------------------------------------------------
        local dot = startDx * dx + startDy * dy + startDz * dz
        dot = math.max(-1, math.min(1, dot))

        local angle = math.acos(dot)

        ------------------------------------------------
        -- SPLIT CONDITION
        ------------------------------------------------
        if angle >= minAngle and accLen >= minLen then

            table.insert(segments, { t1 = segStartT, t2 = t })

            segStartT = t

            startPx, startPy, startPz = px, py, pz
            startDx, startDy, startDz = dx, dy, dz

            accLen = 0.0
        end

        t = t + dt
    end

    ------------------------------------------------
    -- LAST SEGMENT
    ------------------------------------------------
    table.insert(segments, { t1 = segStartT, t2 = 1.0 })

    return segments
end

function SplineToolkit:buildMesh(spline, segments, alignEdgesOnTerrain)
    local verts = {}
    local uvs   = {}   -- parallel to verts (one UV per vertex)
    local faces = {}   -- { p1, p2, p3 }

    local width     = self.uiGenRoadWidthSlider:getValue()
    local halfWidth = width * 0.5

    local texDist     = math.max(self.uiTextureDistSlider:getValue() or 5.0, 0.01)
    local sliceStartP = math.max(0, math.min(1, (self.uiTextureSliceStartSlider:getValue() or 0)  / 100))
    local sliceEndP   = math.max(0, math.min(1, (self.uiTextureSliceEndSlider:getValue()   or 25) / 100))
    local mirror      = self:getChoiceBoolean(self.uiMirrorAtCenter)

    local mTerrainID = alignEdgesOnTerrain and self:getTerrain() or nil

    -- UV tile limit: u resets after TILE_LIMIT repetitions to keep values within GE's precision range.
    -- u=TILE_LIMIT and u=0 both sample the same texture position (integer tile boundary), so the seam
    -- between the two vertex copies (B_end / B_start) is visually invisible.
    -- UV resets at most every TILE_LIMIT tile-repetitions to stay within GE's precision range.
    -- The reset does NOT happen at a fixed u=12 boundary — it happens at whichever cross-section
    -- comes just before the next one would exceed TILE_LIMIT. At that cross-section the vertex is
    -- duplicated: B_end keeps the current u (e.g. 11.2), B_start uses fmod(u, 1.0) (e.g. 0.2).
    -- fmod(11.2, 1.0) = 0.2 → same texture position → seam is completely invisible.
    local TILE_LIMIT = 12.0

    local prevPx, prevPz = nil, nil
    local prevT_outer    = nil
    local accDist        = 0.0   -- total XZ distance from road start
    local tileOriginDist = 0.0   -- accDist at the start of the current tile group
    local prevLocalU     = 0.0   -- localU of the previous cross-section
    local sectionCount   = 0

    local function addVertex(px, py, pz, u, v)
        verts[#verts + 1] = { px, py, pz }
        uvs[#uvs + 1]     = { u,  v }
    end

    local function getVCoords()
        local vS = 1.0 - sliceStartP
        local vE = 1.0 - sliceEndP
        if mirror then return vS, vE, vS
        else            return vS, (vS + vE) * 0.5, vE end
    end

    local function emitSection(t, uValue)
        local px, py, pz = getSplinePosition(spline, t)
        local dx, _, dz  = getSplineDirection(spline, t)

        local rx, rz = -dz, dx
        local len = math.sqrt(rx * rx + rz * rz)
        if len < 0.0001 then return end
        rx, rz = rx / len, rz / len

        local lx  = px - rx * halfWidth;  local lz  = pz - rz * halfWidth
        local cx  = px;                    local cz  = pz
        local rxp = px + rx * halfWidth;  local rzp = pz + rz * halfWidth

        local ly, cy, ry = py, py, py
        if mTerrainID then
            ly = getTerrainHeightAtWorldPos(mTerrainID, lx,  0, lz)  or py
            cy = getTerrainHeightAtWorldPos(mTerrainID, cx,  0, cz)  or py
            ry = getTerrainHeightAtWorldPos(mTerrainID, rxp, 0, rzp) or py
        end

        local vL, vC, vR = getVCoords()
        addVertex(lx,  ly, lz,  uValue, vL)
        addVertex(cx,  cy, cz,  uValue, vC)
        addVertex(rxp, ry, rzp, uValue, vR)

        sectionCount = sectionCount + 1

        if sectionCount >= 2 then
            local currBase = #verts - 2
            local prevBase = currBase - 3
            table.insert(faces, { prevBase,   prevBase+1, currBase   })
            table.insert(faces, { currBase,   prevBase+1, currBase+1 })
            table.insert(faces, { prevBase+1, prevBase+2, currBase+1 })
            table.insert(faces, { currBase+1, prevBase+2, currBase+2 })
        end
    end

    local function addCrossSection(t)
        local px, _, pz = getSplinePosition(spline, t)

        local newAccDist = accDist
        if prevPx ~= nil then
            local ddx = px - prevPx
            local ddz = pz - prevPz
            newAccDist = accDist + math.sqrt(ddx * ddx + ddz * ddz)
        end

        local localU = (newAccDist - tileOriginDist) / texDist

        -- If THIS cross-section would exceed TILE_LIMIT, reset at the PREVIOUS cross-section.
        -- The previous cross-section was already emitted and acts as B_end (no change needed).
        -- We now emit B_start at that same world position with fmod(prevLocalU, 1.0):
        --   fmod(11.2, 1.0) = 0.2  →  same texture position as 11.2  →  seam invisible.
        -- No extra geometry is inserted between existing cross-sections.
        if prevPx ~= nil and localU >= TILE_LIMIT then
            local newOriginU = math.fmod(prevLocalU, 1.0)

            sectionCount = 0                              -- no face between B_end and B_start
            emitSection(prevT_outer, newOriginU)          -- B_start at previous position

            tileOriginDist = accDist - newOriginU * texDist
            localU = (newAccDist - tileOriginDist) / texDist
        end

        accDist      = newAccDist
        prevPx, prevPz = px, pz
        prevLocalU   = localU

        emitSection(t, localU)
        prevT_outer = t
    end

    for _, seg in ipairs(segments) do
        addCrossSection(seg.t1)
    end
    local lastSeg = segments[#segments]
    if lastSeg then addCrossSection(lastSeg.t2) end

    return verts, uvs, faces
end

function SplineToolkit:buildTrafficSplines(spline, segments)
    local data = {}
    local halfWidth = self.uiGenRoadWidthSlider:getValue() * 0.5
    local roadName  = self.uiRoadName:getValue()

    if #segments == 0 then
        return data
    end

    local function buildOffsetSpline(name, offset)
        local cvs = {}

        local function addPoint(t)

            local px, py, pz = getSplinePosition(spline, t)
            local dx, _, dz = getSplineDirection(spline, t)

            local len = math.sqrt(dx*dx + dz*dz)
            if len < 0.0001 then
                dx, dz, len = 1, 0, 1
            end

            dx, dz = dx / len, dz / len

            local rx = -dz
            local rz = dx

            local cx = px + rx * offset
            local cz = pz + rz * offset

            cvs[#cvs + 1] = { cx, py, cz }
        end

        addPoint(0.0)

        for i = 1, #segments do
            local t1 = segments[i].t1
            local t2 = segments[i].t2
            local tm = (t1 + t2) * 0.5
            addPoint(tm)
        end

        addPoint(1.0)

        if #cvs >= 2 then
            data[name] = cvs
        end
    end

    if self:getChoiceBoolean(self.uiHasTrafficCenter) then
        buildOffsetSpline(roadName .. "_center", 0)
    end

    if self:getChoiceBoolean(self.uiHasTrafficLeft) then
        local offset = -halfWidth * (self.uiTrafficLeftPerc:getValue() / 100)
        buildOffsetSpline(roadName .. "_left", offset)
    end

    if self:getChoiceBoolean(self.uiHasTrafficRight) then
        local offset = halfWidth * (self.uiTrafficRightPerc:getValue() / 100)
        buildOffsetSpline(roadName .. "_right", offset)
    end

    return data
end

function SplineToolkit:exportRoad(spline, vertices, uvs, faces, trafficData)

    local uiRoadName = (self.uiRoadName:getValue() or ""):match("^%s*(.-)%s*$")

    local mainTG = self:getRoadTransformgroup()      -- Roads TG
    local parent = getParent(spline)

    local streetTG = nil
    local roadName = nil

    if parent ~= nil and parent ~= 0 then
        local parentOfParent = getParent(parent)

        if parentOfParent == mainTG then
            streetTG = parent
            roadName = getName(parent)
        end
    end

    if streetTG == nil then

        if uiRoadName == "" then
            printError("[SplineToolkit] Enter a Road Name.")
            return
        end

        streetTG = self:getChildByName(mainTG, uiRoadName)

        if streetTG == nil then
            streetTG = createTransformGroup(uiRoadName)
            link(mainTG, streetTG)
            print("[SplineToolkit] Created road: " .. uiRoadName)
        else
            print("[SplineToolkit] Updating existing road: " .. uiRoadName)
        end

        roadName = uiRoadName
    else
        print("[SplineToolkit] Updating existing road: " .. roadName)
    end

    local sourceName = "source_" .. roadName

    if getName(spline) ~= sourceName then
        setName(spline, sourceName)
    end

    if getParent(spline) ~= streetTG then
        link(streetTG, spline)
    end

    for i = getNumOfChildren(streetTG) - 1, 0, -1 do
        local child = getChildAt(streetTG, i)

        if child ~= spline then
            delete(child)
        end
    end

    local exportPath = self:validateExportPath(self.uiExportStreetPath:getValue())
    if not exportPath then
        return
    end
	
    local meshI3D    = exportPath .. roadName .. ".i3d"
    local objPath    = exportPath .. roadName .. ".obj"
    local trafficI3D = exportPath .. roadName .. "_trafficSplines.i3d"


    self:exportRoadOBJ(objPath, vertices, uvs, faces)
    self:exportRoadI3DMesh(meshI3D, vertices, uvs, faces)

    if next(trafficData) then
        self:exportRoadTrafficSplines(trafficI3D, trafficData)
    end

    local meshRoot = loadI3DFile(meshI3D)
    if meshRoot ~= 0 then
        self:linkI3DRoadChildren(meshRoot, streetTG)
    end

    if next(trafficData) then
        local trafficTG = createTransformGroup("trafficSplines")
        link(streetTG, trafficTG)

        local trafficRoot = loadI3DFile(trafficI3D)
        if trafficRoot ~= 0 then
            self:linkI3DRoadChildren(trafficRoot, trafficTG)
        end
    end

    local segCount = math.floor(#faces / 4)
    print(string.format("[SplineToolkit] Road generated %s (%d segments | %d faces | %d vertices)", roadName, segCount, #faces, #vertices))
    -- print("[SplineToolkit] Road generated: " .. roadName)
end

function SplineToolkit:exportRoadOBJ(path, verts, uvs, faces)
    local f = createFile(path, FileAccess.WRITE)
    if f == 0 then
        printError("OBJ export failed")
        return
    end

    fileWrite(f, "# Generated by SplineToolkit Script from Aslan\n")

    -- Deduplicate positions: seam vertices share the same world position but have
    -- different UV values. We merge identical positions so the OBJ mesh stays
    -- fully connected, while UV indices still reference the original (parallel) array.
    local posMap   = {}  -- "x,y,z" key → deduplicated position index (1-based)
    local posList  = {}  -- deduplicated position list
    local vertRemap = {} -- original vertex index → deduplicated position index

    for i, v in ipairs(verts) do
        local key = string.format("%.4f,%.4f,%.4f", v[1], v[2], v[3])
        if posMap[key] then
            vertRemap[i] = posMap[key]
        else
            posList[#posList + 1] = v
            posMap[key] = #posList
            vertRemap[i] = #posList
        end
    end

    -- Positions (deduplicated)
    for _, v in ipairs(posList) do
        fileWrite(f, string.format("v %.6f %.6f %.6f\n", v[1], v[2], v[3]))
    end

    fileWrite(f, "\n")

    -- UVs (all entries, original indices — parallel to the original verts array)
    for _, uv in ipairs(uvs or {}) do
        fileWrite(f, string.format("vt %.6f %.6f\n", uv[1], uv[2]))
    end

    fileWrite(f, "\n")

    -- Faces: position index from deduplicated list, UV index from original array
    for _, t in ipairs(faces) do
        fileWrite(f, string.format(
            "f %d/%d %d/%d %d/%d\n",
            vertRemap[t[1]], t[1],
            vertRemap[t[2]], t[2],
            vertRemap[t[3]], t[3]
        ))
    end

    delete(f)
end

function SplineToolkit:exportRoadI3DMesh(path, verts, uvs, faces)
    local f = createFile(path, FileAccess.WRITE)
    if f == 0 then printError("i3D export failed") return end

    local vCount = #verts
    local tCount = #faces

    -- pick selected texture def
    local values = self.values.roadMesh
    local texIndex = self.selectedRoadTextureIndex or 1
    local texDef = values.textureTable and values.textureTable[texIndex] or nil

    -- terrainDecal
    local terrainDecal = self:getChoiceBoolean(self.uiTerrainDecal)

    -- collect texture files (optional)
    local shaderFile = "$data/shaders/vertexPaintShader.xml"

    local diffuse  = texDef and texDef.textures and texDef.textures["diffuse"]  or nil
    local normal   = texDef and texDef.textures and texDef.textures["normal"]   or nil
    local specular = texDef and texDef.textures and texDef.textures["specular"] or nil
    local height   = texDef and texDef.textures and texDef.textures["height"]   or nil
    local alpha    = texDef and texDef.textures and texDef.textures["alpha"]    or nil

    -- decide shader variation
    local variation = "customParallax_alphaMap"
    if height ~= nil and alpha == nil then
        variation = "customParallax"
    elseif height == nil and alpha ~= nil then
        variation = "customAlphaMap"
    elseif height == nil and alpha == nil then
        variation = "custom"
    end

    -- FileIds
    local fileId = 1
    local fileIds = {}

    local function addFile(filename)
        if filename == nil then return nil end
        if fileIds[filename] ~= nil then
            return fileIds[filename]
        end
        local id = fileId
        fileIds[filename] = id
        fileId = fileId + 1
        return id
    end

    local idDiffuse  = addFile(diffuse)
    local idNormal   = addFile(normal)
    local idSpecular = addFile(specular)
    local idAlpha    = addFile(alpha)
    local idHeight   = addFile(height)
    local idShader   = addFile(shaderFile)

    -- header
    fileWrite(f, '<?xml version="1.0" encoding="iso-8859-1"?>\n\n')
    fileWrite(f, '<i3D name="SplineStreet" version="1.6" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://i3d.giants.ch/schema/i3d-1.6.xsd">\n')

    -- Files
    fileWrite(f, '  <Files>\n')
    -- write in deterministic order like sample
    if alpha    then fileWrite(f, string.format('    <File fileId="%d" filename="%s"/>\n', idAlpha, alpha)) end
    if diffuse  then fileWrite(f, string.format('    <File fileId="%d" filename="%s"/>\n', idDiffuse, diffuse)) end
    if height   then fileWrite(f, string.format('    <File fileId="%d" filename="%s"/>\n', idHeight, height)) end
    if normal   then fileWrite(f, string.format('    <File fileId="%d" filename="%s"/>\n', idNormal, normal)) end
    if specular then fileWrite(f, string.format('    <File fileId="%d" filename="%s"/>\n', idSpecular, specular)) end
    fileWrite(f, string.format('    <File fileId="%d" filename="%s"/>\n', idShader, shaderFile))
    fileWrite(f, '  </Files>\n\n')

    -- Materials
    fileWrite(f, '  <Materials>\n')
    fileWrite(f, string.format('    <Material name="roadMaterial" materialId="1" customShaderId="%d" customShaderVariation="%s">\n', idShader, texDef.shaderVar))

    if idDiffuse then
        fileWrite(f, string.format('      <Texture fileId="%d"/>\n', idDiffuse))
    end
    if idNormal then
        fileWrite(f, string.format('      <Normalmap fileId="%d"/>\n', idNormal))
    end
    if idSpecular then
        fileWrite(f, string.format('      <Glossmap fileId="%d"/>\n', idSpecular))
    end
    if idHeight then
        fileWrite(f, string.format('      <Custommap name="mParallaxMap" fileId="%d"/>\n', idHeight))
    end
    if idAlpha and texDef.shaderVar == "alphaNoise_customParallax_alphaMap" then
        fileWrite(f, string.format('      <Custommap name="alphaMap" fileId="%d"/>\n', idAlpha))
    end

    fileWrite(f, '    </Material>\n')
    fileWrite(f, '  </Materials>\n\n')

    -- Shapes
    fileWrite(f, '  <Shapes>\n')
    fileWrite(f, '    <IndexedTriangleSet name="Street" shapeId="1" isOptimized="false">\n')
    fileWrite(f, string.format('      <Vertices count="%d" normal="true" uv0="true" color="true">\n', vCount))

    for i = 1, vCount do
        local p = verts[i]
        local t0 = uvs[i] or {0.0, 0.0}
        -- normal = straight up (wie vorher)
        fileWrite(f, string.format('        <v p="%.4f %.4f %.4f" n="0 1 0" t0="%.6f %.6f" c="0.0 0.0 0.0 1.0"/>\n', p[1], p[2], p[3], t0[1], t0[2]))
    end

    fileWrite(f, '      </Vertices>\n')

    fileWrite(f, string.format('      <Triangles count="%d">\n', tCount))
    for _, tri in ipairs(faces) do
        fileWrite(f, string.format('        <t vi="%d %d %d"/>\n', tri[1]-1, tri[2]-1, tri[3]-1))
    end
    fileWrite(f, '      </Triangles>\n')

    fileWrite(f, '      <Subsets count="1">\n')
    fileWrite(f, string.format('        <Subset firstVertex="0" numVertices="%d" firstIndex="0" numIndices="%d"/>\n', vCount, tCount * 3))
    fileWrite(f, '      </Subsets>\n')

    fileWrite(f, '    </IndexedTriangleSet>\n')
    fileWrite(f, '  </Shapes>\n\n')

    -- Scene
    local shapeName = self.uiRoadName:getValue() or "Road"
    fileWrite(f, '  <Scene>\n')
    fileWrite(f, string.format('    <Shape name="%s" shapeId="1" static="%s" castsShadows="true" receiveShadows="true" nonRenderable="%s" terrainDecal="%s" materialIds="1"/>\n',
        shapeName,
        terrainDecal and "false" or "true",
        terrainDecal and "true" or "false",
        terrainDecal and "true" or "false"
    ))
    fileWrite(f, '  </Scene>\n\n')

    fileWrite(f, '</i3D>\n')
    delete(f)
end

function SplineToolkit:exportRoadTrafficSplines(path, trafficData)
    if next(trafficData) == nil then return end

    local f = createFile(path, FileAccess.WRITE)
    if f == 0 then
        printError("Failed to create traffic spline i3d")
        return
    end

    fileWrite(f, '<?xml version="1.0" encoding="iso-8859-1"?>\n')
    fileWrite(f, '<i3D name="TrafficSplines" version="1.6">\n')

    -- SHAPES
    fileWrite(f, '  <Shapes>\n')
    local shapeId = 1
    for name, cvs in pairs(trafficData) do
        fileWrite(f, string.format('    <NurbsCurve name="%s" shapeId="%d" type="cubic" degree="3" form="open">\n', name, shapeId))
        for _, cv in ipairs(cvs) do
            fileWrite(f, string.format('      <cv c="%.4f %.4f %.4f"/>\n', cv[1], cv[2], cv[3]))
        end
        fileWrite(f, '    </NurbsCurve>\n')
        shapeId = shapeId + 1
    end
    fileWrite(f, '  </Shapes>\n')

    -- SCENE
    fileWrite(f, '  <Scene>\n')
    local nodeIds = {}
    local nodeId = 1
    shapeId = 1
    for name, _ in pairs(trafficData) do
        fileWrite(f, string.format('    <Shape name="%s" shapeId="%d" nodeId="%d"/>\n', name, shapeId, nodeId))
        nodeIds[#nodeIds + 1] = nodeId
        shapeId = shapeId + 1
        nodeId = nodeId + 1
    end
    fileWrite(f, '  </Scene>\n')

    -- USER ATTRIBUTES
    fileWrite(f, '  <UserAttributes>\n')
    for _, nId in ipairs(nodeIds) do
        fileWrite(f, string.format('    <UserAttribute nodeId="%d">\n', nId))
        fileWrite(f, string.format('      <Attribute name="maxSpeedScale" type="float" value="%.3f"/>\n', self.uiMaxSpeedScale:getValue() or 1.0))
        fileWrite(f, string.format('      <Attribute name="speedLimit" type="float" value="%.3f"/>\n', self.uiSpeedLimit:getValue() or 15.0))
        fileWrite(f, '    </UserAttribute>\n')
    end
    fileWrite(f, '  </UserAttributes>\n')

    fileWrite(f, '</i3D>\n')
    delete(f)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	UTILS - TRANSFORMGROUP MANAGER 		---------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SplineToolkit:getSplineToolkitTransformgroup()
    local root = getRootNode()
    for i = 0, getNumOfChildren(root) - 1 do
        local child = getChildAt(root, i)
        if getName(child) == "SplineToolkitAslan" then
            return child
        end
    end

    local tg = createTransformGroup("SplineToolkitAslan")
    link(root, tg)

    print("[SplineToolkit] Created TransformGroup 'SplineToolkitAslan'")
    return tg
end

function SplineToolkit:getOrCreatePlaceObjectsTransformgroups()
    local mainContainer = self:getSplineToolkitTransformgroup()
    local placeTG, sourceObjTG, sourceSplineTG, placedObjTG
    local newRoot, newSrcObj, newSrcSpline, newPlaced = false, false, false, false

    for i = 0, getNumOfChildren(mainContainer) - 1 do
        local child = getChildAt(mainContainer, i)
        if getName(child) == "SetObjectsBySpline" then
            placeTG = child
            break
        end
    end

    if not placeTG then
        placeTG = createTransformGroup("SetObjectsBySpline")
        link(mainContainer, placeTG)
        newRoot = true
    end

    for i = 0, getNumOfChildren(placeTG) - 1 do
        local child = getChildAt(placeTG, i)
        local name = getName(child)
        if name == "SourceObject"  then sourceObjTG    = child end
        if name == "SourceSplines" then sourceSplineTG = child end
        if name == "PlacedObjects" then placedObjTG    = child end
    end

    if not sourceObjTG then
        sourceObjTG = createTransformGroup("SourceObject")
        link(placeTG, sourceObjTG)
        newSrcObj = true
    end

    if not sourceSplineTG then
        sourceSplineTG = createTransformGroup("SourceSplines")
        link(placeTG, sourceSplineTG)
        newSrcSpline = true
    end

    if not placedObjTG then
        placedObjTG = createTransformGroup("PlacedObjects")
        link(placeTG, placedObjTG)
        newPlaced = true
    end

    print(string.format("[SplineToolkit] SetObjectsBySpline (%s)", newRoot and "created" or "found"))
    print(string.format("    ├─ SourceObject (%s)",  newSrcObj    and "created" or "found"))
    print(string.format("    ├─ SourceSplines (%s)", newSrcSpline and "created" or "found"))
    print(string.format("    └─ PlacedObjects (%s)", newPlaced    and "created" or "found"))

    return placeTG, sourceObjTG, sourceSplineTG, placedObjTG
end

function SplineToolkit:getPlaceFenceTransformgroup()
    local mainContainer = self:getSplineToolkitTransformgroup()
    local fenceTG

    for i = 0, getNumOfChildren(mainContainer) - 1 do
        local child = getChildAt(mainContainer, i)
        if getName(child) == "SetFenceBySpline" then
            fenceTG = child
            break
        end
    end

    if not fenceTG then
        fenceTG = createTransformGroup("SetFenceBySpline")
        link(mainContainer, fenceTG)
        print("[SplineToolkit] Created TransformGroup 'SetFenceBySpline'")
    end

    return fenceTG
end

function SplineToolkit:getRoadTransformgroup()
    local mainContainer = self:getSplineToolkitTransformgroup()
    local roadTG

    for i = 0, getNumOfChildren(mainContainer) - 1 do
        local child = getChildAt(mainContainer, i)
        if getName(child) == "GenRoadMesh" then
            roadTG = child
            break
        end
    end

    if not roadTG then
        roadTG = createTransformGroup("GenRoadMesh")
        link(mainContainer, roadTG)
        print("[SplineToolkit] Created TransformGroup 'GenRoadMesh'")
    end

    return roadTG
end
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	UTILS - WINDOWS 			-----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SplineToolkit:convertFileText(path)
    if type(path) ~= "string" then
        return path
    end

    local marker = "FarmingSimulator2025"

    local startPos = string.find(path, marker, 1, true)
    if startPos ~= nil then
        local shortened = string.sub(path, startPos + #marker)
        shortened = shortened:gsub("^[/\\]+", "")
        return ".../" .. shortened
    end

    return path
end

function SplineToolkit:genUINewFence(fenceId, callback, existingEntry)
    assert(callback == nil or type(callback) == "function")

    local title = (fenceId == nil) and "Add New Fence Entry" or ("Edit Fence Entry - " .. existingEntry.name)

    local state = {
        fenceXMLPath = "",
        ui = {}
    }

    local uiFrameRowSizer = UIRowLayoutSizer.new()
    local window = UIWindow.new(uiFrameRowSizer, title, false, true)

    local uiBorderSizer = UIRowLayoutSizer.new()
    UIPanel.new(uiFrameRowSizer, uiBorderSizer, -1, -1, 400, -1, BorderDirection.NONE, 0, 1)

    local uiRowSizer = UIRowLayoutSizer.new()
    local uiPanelSizer = UIPanel.new(uiBorderSizer, uiRowSizer, -1, -1, -1, -1, BorderDirection.NONE, 0, 1)
    uiPanelSizer:setBackgroundColor(0.98, 0.98, 0.98, 1)

    local rowSizerElements = UIRowLayoutSizer.new()
    UIPanel.new(uiRowSizer, rowSizerElements, -1, -1, -1, -1, BorderDirection.ALL, 10, 1)
	
    local rowSizerInfo = UIRowLayoutSizer.new()
    local uiInfoBox = UIPanel.new(rowSizerElements, rowSizerInfo, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1)
    uiInfoBox:setBackgroundColor(1.0, 0.9, 0.53, 1.0)
    local rowSizerInfoElements = UIRowLayoutSizer.new()
    local uiInfoBox = UIPanel.new(rowSizerInfo, rowSizerInfoElements, -1, -1, -1, -1, BorderDirection.ALL, 5, 1)
	UILabel.new(rowSizerInfoElements, "• The Fence I3D file must be in the same folder as the selected XML.")
	UILabel.new(rowSizerInfoElements, "• The icon must be a 512x512 .PNG placed in this folder:")
    UILabel.new(rowSizerInfoElements, getEditorDirectory())
    UILabel.new(rowSizerInfoElements, SplineToolkit.FENCE_RAW_IMG_PATH)
	UILabel.new(rowSizerInfoElements, "• If import Mod-Fence - get permission from the original mod author.")

	UIHorizontalLine.new(rowSizerElements)
    -- ===============================
    -- XML FILE SELECT
    -- ===============================
	local function convertPNGFilename(isAdd, fileName)
		if not fileName or fileName == "" then
			return fileName
		end

		if isAdd then
			-- Wenn nicht bereits .png (case-insensitive)
			if not fileName:lower():match("%.png$") then
				return fileName .. ".png"
			end
			return fileName
		else
			-- Entferne .png am Ende (case-insensitive)
			return fileName:gsub("(%.[pP][nN][gG])$", "")
		end
	end

    
	local function selectFenceXMLFile()

        local filePath = openFileDialog("", "Fence XML File|*.xml")
        if not filePath or filePath == "" then return end

        local xmlFile = XMLFile.loadIfExists("FenceCheck", filePath)
        if not xmlFile then
            printError("[SplineToolkit] Invalid XML file: " .. filePath)
            return
        end

        if not xmlFile:hasProperty("placeable.fence") then
            xmlFile:delete()
            printError("[SplineToolkit] Selected file has no <fence> tag")
            return
        end

        xmlFile:delete()

        state.fenceXMLPath = filePath
        state.ui.fenceXMLPath:setValue(filePath)
    end

    UILabel.new(rowSizerElements, "XML File:")
    local pathRow = UIColumnLayoutSizer.new()
    UIPanel.new(rowSizerElements, pathRow, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

    state.ui.fenceXMLPath = UITextArea.new(pathRow, "", TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.RIGHT, 5, 1)
    UIButton.new(pathRow, "🗁", selectFenceXMLFile, nil, -1, -1, 25, -1)

    UILabel.new(rowSizerElements, "Name:")
    state.ui.fenceName = UITextArea.new(rowSizerElements, "", TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

    UILabel.new(rowSizerElements, "Icon File Name (without .png):")
    state.ui.fenceIconName = UITextArea.new(rowSizerElements, "", TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

    local columnSizerButtons = UIColumnLayoutSizer.new()
    UIPanel.new(uiBorderSizer, columnSizerButtons, -1, -1, -1, -1, BorderDirection.ALL, 10)
	
	if existingEntry then
		state.ui.fenceXMLPath:setValue(existingEntry.xmlFile or "")
		state.ui.fenceName:setValue(existingEntry.name or "")
		print(existingEntry.imgFile)
		state.ui.fenceIconName:setValue(convertPNGFilename(false, existingEntry.imgFile) or "")
	end

    local wasButtonPressed = false

	local function onClickSave()
		local xmlPath = state.ui.fenceXMLPath:getValue()
		local name    = state.ui.fenceName:getValue()

		if xmlPath == "" or name == "" then
			printError("[SplineToolkit] XML file and name must be present.")
			return
		end
        
		wasButtonPressed = true

        local result = {
            xmlFile = state.ui.fenceXMLPath:getValue(),
            name    = state.ui.fenceName:getValue(),
            imgFile = convertPNGFilename(true, state.ui.fenceIconName:getValue())
        }
		print(result.imgFile)
        window:close()

        if callback then
            callback(true, result)
        end
    end

    local function onClickReturn()
        wasButtonPressed = true
        window:close()
        if callback then callback(false) end
    end

    UILabel.new(columnSizerButtons, "", false, TextAlignment.LEFT, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.NONE, 0, 1)
    UIButton.new(columnSizerButtons, "Save", onClickSave, nil, -1, -1, 90, 26, BorderDirection.RIGHT, 10):setBackgroundColor(0.6, 1.0, 0.55, 1.0)
    UIButton.new(columnSizerButtons, "Return", onClickReturn, nil, -1, -1, 90, 26):setBackgroundColor(0.9, 0.5, 0.5, 1.0)

    window:setOnCloseCallback(function()
        if not wasButtonPressed and callback then
            callback(nil)
        end
    end)

    window:fit()
    window:refresh()
    window:showWindow()
end

-- Speichert animatedMapObjects.xml zurück.
-- gateIndexName gesetzt  → ersetzt nur den Eintrag dieses Gates (xmlString = ein <animatedObject>-Block)
-- gateIndexName nil      → überschreibt die gesamte Datei (xmlString = komplettes XML)
function SplineToolkit:saveAnimationMapXml(xmlString)
    local fullPath = SplineToolkit.FENCE_CALLBACK_ANIMATION_FILENAME
    if not fullPath or not xmlString or xmlString == "" then return false end

    local srcId = loadXMLFileFromMemory("AnimSaveSrc", xmlString)
    if not srcId or srcId == 0 then
        printError("[SplineToolkit] saveAnimationMapXml: cannot parse XML")
        return false
    end

    local dstId = createXMLFile("AnimSaveDst", fullPath, "animatedObjects")
    if not dstId or dstId == 0 then delete(srcId); return false end

    local i = 0
    while hasXMLProperty(srcId, "animatedObjects.animatedObject(" .. i .. ")") do
        self:copyXmlNodeRecursive(srcId, "animatedObjects.animatedObject(" .. i .. ")", dstId, "animatedObjects.animatedObject(" .. i .. ")", nil, nil)
        i = i + 1
    end

    saveXMLFile(dstId)
    delete(srcId)
    delete(dstId)
    print("[SplineToolkit] animatedMapObjects.xml saved (" .. i .. " entries)")
    return true
end

-- Baut rekursiv einen XML-String aus einem xmlId-Element (alte GE API)
function SplineToolkit:buildXmlString(xmlId, path, indent)
    indent = indent or 0
    local pad = string.rep("     ", indent)

    local elementName = getXMLElementName(xmlId, path)
    if not elementName then return "" end

    local attrs = ""
    local numAttrs = getXMLNumOfAttributes(xmlId, path)
    for i = 0, numAttrs - 1 do
        local attrName = getXMLAttributeName(xmlId, path, i)
        if attrName then
            local val = getXMLString(xmlId, path .. "#" .. attrName) or ""
            attrs = attrs .. string.format(' %s="%s"', attrName, val)
        end
    end

    local numChildren = getXMLNumOfChildren(xmlId, path)
    if numChildren == 0 then
        return pad .. "<" .. elementName .. attrs .. " />"
    end

    local lines = { pad .. "<" .. elementName .. attrs .. ">" }
    local childCounts = {}
    for i = 0, numChildren - 1 do
        local childName = getXMLElementName(xmlId, path .. ".*(" .. i .. ")")
        if childName then
            childCounts[childName] = (childCounts[childName] or -1) + 1
            local childPath = path .. "." .. childName .. "(" .. childCounts[childName] .. ")"
            table.insert(lines, self:buildXmlString(xmlId, childPath, indent + 1))
        end
    end
    table.insert(lines, pad .. "</" .. elementName .. ">")
    return table.concat(lines, "\n")
end

-- Liest den animatedObject-XML-Block des aktuell gewählten Gates aus animatedMapObjects.xml
function SplineToolkit:getGateAnimationXmlString()
    local gateNode = self.selectedGateNode
    if not gateNode then return nil end

    local indexName = getUserAttribute(gateNode, "index")
    if not indexName or indexName == "" then return nil end

    local fullPath = SplineToolkit.FENCE_CALLBACK_ANIMATION_FILENAME
    if not fullPath or not fileExists(fullPath) then return nil end

    local xmlId = loadXMLFile("AnimView", fullPath)
    if not xmlId or xmlId == 0 then return nil end

    -- Eintrag mit passendem saveId suchen
    local entryIdx = nil
    local i = 0
    while true do
        local saveId = getXMLString(xmlId, "animatedObjects.animatedObject(" .. i .. ")#saveId")
        if saveId == nil then break end
        if saveId == indexName then
            entryIdx = i
            break
        end
        i = i + 1
    end

    if not entryIdx then
        delete(xmlId)
        return nil
    end

    local result = self:buildXmlString(xmlId, "animatedObjects.animatedObject(" .. entryIdx .. ")", 0)
    delete(xmlId)
    return result
end

function SplineToolkit:onClickOpenAnimationXMLFileViewer()
    local fullPath = SplineToolkit.FENCE_CALLBACK_ANIMATION_FILENAME
    local xmlContent = "(File not found)"
    if fullPath and fileExists(fullPath) then
        local xmlId = loadXMLFile("AnimViewFull", fullPath)
        if xmlId and xmlId ~= 0 then
            xmlContent = saveXMLFileToMemory(xmlId) or "(Could not read XML)"
            delete(xmlId)
        end
    end

    local title = fullPath and fullPath:match("([^/\\]+)$") or "Animation XML"

    local uiFrameRowSizer = UIRowLayoutSizer.new()
    local window = UIWindow.new(uiFrameRowSizer, title, true, false)

    local uiBorderSizer = UIRowLayoutSizer.new()
    UIPanel.new(uiFrameRowSizer, uiBorderSizer, -1, -1, 800, 550, BorderDirection.NONE, 0, 1)

    local uiRowSizer = UIRowLayoutSizer.new()
    local uiPanelSizer = UIPanel.new(uiBorderSizer, uiRowSizer, -1, -1, -1, -1, BorderDirection.NONE, 0, 1)
    uiPanelSizer:setBackgroundColor(0.98, 0.98, 0.98, 1)

    local rowSizerElements = UIRowLayoutSizer.new()
    UIPanel.new(uiRowSizer, rowSizerElements, -1, -1, -1, -1, BorderDirection.ALL, 10, 1)
    local uiTextArea = UITextArea.new(rowSizerElements, xmlContent, TextAlignment.LEFT, false, true, -1, -1, -1, -1, BorderDirection.BOTTOM, 0, 1)

    local columnSizerButtons = UIColumnLayoutSizer.new()
    UIPanel.new(uiBorderSizer, columnSizerButtons, -1, -1, -1, -1, BorderDirection.ALL, 10)
    UIButton.new(columnSizerButtons, "Validate Fences", function() self:validateAnimationMapXml(uiTextArea:getValue()) end, nil, -1, -1, 120, 26):setBackgroundColor(0.1, 0.77, 0.99, 1.0)
    UILabel.new(columnSizerButtons, "", false, TextAlignment.LEFT, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.NONE, 0, 1)
    UIButton.new(columnSizerButtons, "Save", function() self:saveAnimationMapXml(uiTextArea:getValue()) end, nil, -1, -1, 90, 26):setBackgroundColor(0.6, 1.0, 0.55, 1.0)
    UIButton.new(columnSizerButtons, "Close", function() window:close() end, nil, -1, -1, 90, 26):setBackgroundColor(0.9, 0.5, 0.5, 1.0)

    window:fit()
    window:refresh()
    window:showWindow()
end


function SplineToolkit:genUINewRoadTexture(roadId, callback, existingEntry)
    assert(callback == nil or type(callback) == "function")

    local title = (roadId == nil)
        and "Add New Road Texture"
        or ("Edit Road Texture - " .. (existingEntry and existingEntry.name or ""))

    local state = {
        ui = {}
    }

	local function convertPNGFilename(isAdd, fileName)
		if not fileName or fileName == "" then
			return fileName
		end

		if isAdd then
			-- Wenn nicht bereits .png (case-insensitive)
			if not fileName:lower():match("%.png$") then
				return fileName .. ".png"
			end
			return fileName
		else
			-- Entferne .png am Ende (case-insensitive)
			return fileName:gsub("(%.[pP][nN][gG])$", "")
		end
	end

    local uiFrameRowSizer = UIRowLayoutSizer.new()
    local window = UIWindow.new(uiFrameRowSizer, title, false, true)

    local borderSizer = UIRowLayoutSizer.new()
    UIPanel.new(uiFrameRowSizer, borderSizer, -1, -1, 450, -1, BorderDirection.NONE, 0, 1)

    local contentSizer = UIRowLayoutSizer.new()
    local panel = UIPanel.new(borderSizer, contentSizer, -1, -1, -1, -1, BorderDirection.NONE, 0, 1):setBackgroundColor(0.98, 0.98, 0.98, 1)
    -- panel:setBackgroundColor(0.98, 0.98, 0.98, 1)

    local rowSizerElements = UIRowLayoutSizer.new()
    UIPanel.new(contentSizer, rowSizerElements, -1, -1, -1, -1, BorderDirection.ALL, 10, 1)
	
    -- INFO BOX
    local infoSizer = UIRowLayoutSizer.new()
    local infoPanel = UIPanel.new(rowSizerElements, infoSizer, -1, -1, -1, -1, BorderDirection.ALL, 10, 1)
    infoPanel:setBackgroundColor(1.0, 0.9, 0.53, 1.0)

    UILabel.new(infoSizer, "• Set Icon Filename without '.png'.", false, TextAlignment.LEFT, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.ALL, 5)
    UILabel.new(infoSizer, "• Icon must be a 512x512 PNG inside Road IMG folder.", false, TextAlignment.LEFT, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.ALL, 5)

    UIHorizontalLine.new(rowSizerElements, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

    ------------------------------------------------
    -- NAME + ICON
    ------------------------------------------------
	local row = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizerElements, row, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
    UILabel.new(row, "Texture Name:", false, TextAlignment.LEFT, VerticalAlignment.CENTER, -1, -1, 90, -1, BorderDirection.RIGHT, 5)
    state.ui.name = UITextArea.new(row, "", TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1)

	local row = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizerElements, row, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
    UILabel.new(row, "Icon File Name:", false, TextAlignment.LEFT, VerticalAlignment.CENTER, -1, -1, 90, -1, BorderDirection.RIGHT, 5)
    state.ui.icon = UITextArea.new(row, "", TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.BOTTOM, 5, 1)

    UIHorizontalLine.new(rowSizerElements, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
    ------------------------------------------------
    -- TEXTURE FILE PICKER
    ------------------------------------------------
    local function createTextureRow(labelText, key)
        local row = UIColumnLayoutSizer.new()
        UIPanel.new(rowSizerElements, row, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)

        UILabel.new(row, labelText .. ":", false, TextAlignment.LEFT, VerticalAlignment.CENTER, -1, -1, 60, -1, BorderDirection.RIGHT, 5)

        state.ui[key] = UITextArea.new(row, "", TextAlignment.LEFT, false, false, -1, -1, -1, -1, BorderDirection.RIGHT, 5, 1)

        UIButton.new(row, "🗁", function()
            local filePath = openFileDialog("", "DDS File|*.dds")
            if filePath and filePath ~= "" then
                state.ui[key]:setValue(filePath)
            end
        end, nil, -1, -1, 25, -1)
		UIButton.new(row, "X", function() 
			state.ui[key]:setValue("")
		end, nil, -1, -1, 25, -1)
    end

    createTextureRow("Diffuse",  "diffuse")
    createTextureRow("Specular", "specular")
    createTextureRow("Normal",   "normal")
    createTextureRow("Height",   "height")
    createTextureRow("Alpha",    "alpha")

	local row = UIColumnLayoutSizer.new()
	UIPanel.new(rowSizerElements, row, -1, -1, -1, -1, BorderDirection.BOTTOM, 5)
    state.ui.alphaInsideDiffuse = UILabel.new(row, "Is Alpha-Channel inside the Diffuse Map?", false, TextAlignment.LEFT, VerticalAlignment.CENTER, -1, -1, -1, -1, BorderDirection.RIGHT, 5, 1)
    -- UITextArea.new(row, "Is Alpha inside the Diffuse Map?", TextAlignment.LEFT, true, false, -1, -1, -1, -1, BorderDirection.RIGHT, 5, 1)
    state.ui.alphaInsideDiffuse = UIChoice.new(row, {"False", "True"}, 0, -1, -1, -1, -1, BorderDirection.NONE, 5, 1)
    ------------------------------------------------
    -- BUTTONS
    ------------------------------------------------
    local buttonSizer = UIColumnLayoutSizer.new()
    UIPanel.new(borderSizer, buttonSizer, -1, -1, -1, -1, BorderDirection.ALL, 10)

    local wasPressed = false

    local function onClickSave()
        local name = state.ui.name:getValue()
        local icon = convertPNGFilename(true, state.ui.icon:getValue())
		local shaderVariant
		if state.ui.alphaInsideDiffuse:getValue() == 0 then
			shaderVariant = "alphaNoise_customParallax_alphaMap"
		else
			shaderVariant = "alphaNoise_terrainFormat_customParallax"
		end
		print(shaderVariant)

        if name == nil or name == "" then
            printError("[SplineToolkit] Texture name required.")
            return
        end

        -- if icon == nil or icon == "" then
            -- return
        -- end

        local result = {
            name = name,
            imgFile = icon,
			shaderVar = shaderVariant,
            textures = {
                diffuse  = state.ui.diffuse:getValue(),
                specular = state.ui.specular:getValue(),
                normal   = state.ui.normal:getValue(),
                height   = state.ui.height:getValue(),
                alpha    = state.ui.alpha:getValue()
            },
            isCustom = true
        }

        wasPressed = true
        window:close()

        if callback then
            callback(true, result)
        end
    end

    local function onClickReturn()
        wasPressed = true
        window:close()
        if callback then callback(false) end
    end

    UILabel.new(buttonSizer, "", false, TextAlignment.LEFT, VerticalAlignment.TOP, -1, -1, -1, -1, BorderDirection.NONE, 0, 1)
    UIButton.new(buttonSizer, "Save", onClickSave, nil, -1, -1, 90, 26, BorderDirection.RIGHT, 10):setBackgroundColor(0.6, 1.0, 0.55, 1.0)
    UIButton.new(buttonSizer, "Return", onClickReturn, nil, -1, -1, 90, 26):setBackgroundColor(0.9, 0.5, 0.5, 1.0)

    window:setOnCloseCallback(function()
        if not wasPressed and callback then
            callback(nil)
        end
    end)

    ------------------------------------------------
    -- EDIT MODE FILL
    ------------------------------------------------
    if existingEntry then
        state.ui.name:setValue(existingEntry.name or "")
		state.ui.icon:setValue(convertPNGFilename(false, existingEntry.imgFile) or "")

        if existingEntry.textures then
            state.ui.diffuse:setValue(existingEntry.textures.diffuse or "")
            state.ui.specular:setValue(existingEntry.textures.specular or "")
            state.ui.normal:setValue(existingEntry.textures.normal or "")
            state.ui.height:setValue(existingEntry.textures.height or "")
            state.ui.alpha:setValue(existingEntry.textures.alpha or "")
        end
    end

    window:fit()
    window:refresh()
    window:showWindow()
end
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	UTILS - OTHER UTILS 		-----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SplineToolkit:getTerrain()
    local root = getRootNode()

    for i = 0, getNumOfChildren(root) - 1 do
        local child = getChildAt(root, i)
        if getName(child) == "terrain" then
            return child
        end
    end

    print("[SplineToolkit] Terrain not found")
    return nil
end

function SplineToolkit:setTerrainTextureLayers()
    local layerTable = self.values.base.paintTerrain.textureLayers
    table.clear(layerTable)

    local mSceneID = getRootNode()
    local mTerrainID = self:getTerrain()

    local numLayers = getTerrainNumOfLayers(mTerrainID)

    local combined = {}
    local normal = {}

    for i = 0, numLayers - 1 do
        local name = getTerrainLayerName(mTerrainID, i)

        if name ~= nil and name ~= "" then
            if name == string.upper(name) then
                table.insert(combined, name)
            else
                table.insert(normal, name)
            end
        end
    end

    for _, v in ipairs(combined) do
        table.insert(layerTable, v)
    end

    for _, v in ipairs(normal) do
        table.insert(layerTable, v)
    end
end

function SplineToolkit:getIsSpline(node)
    if node == nil or node == 0 then
        return false
    end

    if not getHasClassId(node, ClassIds.SHAPE) then
        return false
    end

    local geo = getGeometry(node)
    if geo == nil or geo == 0 then
        return false
    end

    return getHasClassId(geo, ClassIds.SPLINE)
end

function SplineToolkit:clampMinMaxSlider(minEl, maxEl, gap)
    gap = gap or 0
    minEl:setOnChangeCallback(function()
        if minEl:getValue() + gap > maxEl:getValue() then
            maxEl:setValue(minEl:getValue() + gap)
        end
    end)
    maxEl:setOnChangeCallback(function()
        if maxEl:getValue() - gap < minEl:getValue() then
            minEl:setValue(maxEl:getValue() - gap)
        end
    end)
end

function SplineToolkit:setChoiceFromString(uiChoice, list, valueString)
    if uiChoice == nil or list == nil or valueString == nil then
        return
    end

    local target = tostring(valueString):upper()
    local index = 0

    for i = 1, #list do
        if tostring(list[i]):upper() == target then
            index = i - 1
            break
        end
    end

    uiChoice:setChoices(list, index)
end

function SplineToolkit:getChoiceActiveOptionString(uiChoice)
	if uiChoice == nil then return nil end
	return uiChoice:getOptionString(uiChoice:getValue()-1)
end

function SplineToolkit:getChoiceBoolean(uiChoice)
    if uiChoice == nil then
        return false
    end

    local value = self:getChoiceActiveOptionString(uiChoice)
    if value == nil then
        return false
    end

    return string.lower(value) == "true"
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	SAVE & LOAD SETTINS 		------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
local function versionToNum(v)
    local num, factor = 0, 1000000000
    for part in tostring(v):gmatch("%d+") do
        num = num + (tonumber(part) or 0) * factor
        factor = factor / 1000
        if factor < 1 then break end
    end
    return num
end

function SplineToolkit:isSettingsOutdated(xmlFile)
    local stored = xmlFile:getString("settings#version") or ""
    return versionToNum(SplineToolkit.VERSION) > versionToNum(stored)
end

function SplineToolkit:saveSettings(tab)
    local xmlFile = XMLFile.loadIfExists("SplineToolkitSettings", SplineToolkit.SETTINGS_PATH)

    if xmlFile then
        if self:isSettingsOutdated(xmlFile) then
            local storedVersion = xmlFile:getString("settings#version") or "none"
            printWarning(string.format("[SplineToolkit][saveSettings] Version mismatch (current = %s | settings = %s) – clearing and rebuilding.", SplineToolkit.VERSION, storedVersion))
            xmlFile:delete()
            xmlFile = XMLFile.create("SplineToolkitSettings", SplineToolkit.SETTINGS_PATH, "settings")
            if not xmlFile then return end
        end
    else
        xmlFile = XMLFile.create("SplineToolkitSettings", SplineToolkit.SETTINGS_PATH, "settings")
        if not xmlFile then return end
    end

    xmlFile:setString("settings#version", SplineToolkit.VERSION)

	if tab == self.tabNames[1] then -- Base Tools
		local baseKey = "settings.base"
		xmlFile:setFloat(baseKey .. "#setOnTerrainHeightOffset", self.uiTerrainHeightOffset:getValue())
		xmlFile:setFloat(baseKey .. "#offsetSide", self.uiOffsetSideOffset:getValue())
		xmlFile:setFloat(baseKey .. "#offsetHeight", self.uiOffsetHeightOffset:getValue())
		xmlFile:setFloat(baseKey .. "#terrainHeight", self.uiTerrainHeightHeightOffset:getValue())
		xmlFile:setFloat(baseKey .. "#terrainWidth", self.uiTerrainHeightWidth:getValue())
		xmlFile:setFloat(baseKey .. "#terrainSmoothDistance", self.uiTerrainHeightSmoothDist:getValue())
		xmlFile:setFloat(baseKey .. "#paintWidthLeft", self.uiPaintWidthLeft:getValue())
		xmlFile:setFloat(baseKey .. "#paintWidthRight", self.uiPaintWidthRight:getValue())
		
		xmlFile:setFloat(baseKey .. "#foliageWidthLeft", self.uiFoliageWidthLeft:getValue())
		xmlFile:setFloat(baseKey .. "#foliageWidthRight", self.uiFoliageWidthRight:getValue())
		
		xmlFile:setInt(baseKey .. "#numSplinePoints", self.uiNumOfPoints:getValue())
		
	elseif tab == self.tabNames[2] then -- Place Objects
		local baseKey = "settings.objectPlacement"
		local values = self.values.objectPlacement

		if values.activeModeIndex == 2 then
			xmlFile:setFloat(baseKey .. "#areaMinDistBetween", self.uiAreaMinDist:getValue())
			xmlFile:setFloat(baseKey .. "#areaMaxDistBetween", self.uiAreaMaxDist:getValue())
			xmlFile:setFloat(baseKey .. "#areaWidthLeft",      self.uiAreaWidthLeft:getValue())
			xmlFile:setFloat(baseKey .. "#areaWidthCenter",    self.uiAreaWidthCenter:getValue())
			xmlFile:setFloat(baseKey .. "#areaWidthRight",     self.uiAreaWidthRight:getValue())
			xmlFile:setString(baseKey .. "#areaLeftEnabled",   self:getChoiceActiveOptionString(self.uiAreaLeftEnabled))
			xmlFile:setString(baseKey .. "#areaCenterEnabled", self:getChoiceActiveOptionString(self.uiAreaCenterEnabled))
			xmlFile:setString(baseKey .. "#areaRightEnabled",  self:getChoiceActiveOptionString(self.uiAreaRightEnabled))
		else
			xmlFile:setFloat(baseKey .. "#sideOffset",         self.uiPlaceOffsetSide:getValue())
			xmlFile:setFloat(baseKey .. "#objectFixDistance",  self.uiObjectFixDistance:getValue())
			xmlFile:setFloat(baseKey .. "#objectMinDistance",  self.uiObjectMinDistance:getValue())
			xmlFile:setFloat(baseKey .. "#objectMaxDistance",  self.uiObjectMaxDistance:getValue())
			xmlFile:setFloat(baseKey .. "#objectHeight",       self.uiObjectHeight:getValue())
			xmlFile:setFloat(baseKey .. "#objectRotate",       self.uiObjectRotate:getValue())
			xmlFile:setString(baseKey .. "#objDistanceType",   self:getChoiceActiveOptionString(self.uiObjectDistanceType))
			xmlFile:setString(baseKey .. "#setHeightType",     self:getChoiceActiveOptionString(self.uiSetHeightType))
			xmlFile:setString(baseKey .. "#setRandomRotate",   self:getChoiceActiveOptionString(self.uiRandomRotate))
		end

    elseif tab == self.tabNames[3] then -- Place Fence
        local scene = getSceneFilename()
        local baseKey = "settings.placeFence"

        xmlFile:setString(baseKey .. "#imgPath", self.uiImgFencePath:getValue())
        xmlFile:setString(baseKey .. "#useYOffset",self:getChoiceActiveOptionString(self.uiFencePlaceYOffset))
        xmlFile:setString(baseKey .. "#placeStartPole",self:getChoiceActiveOptionString(self.uiFencePlaceStartPole))
        xmlFile:setString(baseKey .. "#placeEndPole",self:getChoiceActiveOptionString(self.uiFencePlaceEndPole))

        local i = 0
        local sceneIndex = nil

        while xmlFile:hasProperty(string.format("%s.customFences.scene(%d)", baseKey, i)) do
            if xmlFile:getString(string.format("%s.customFences.scene(%d)#path", baseKey, i)) == scene then
                sceneIndex = i
                break
            end
            i = i + 1
        end

        if sceneIndex == nil then
            sceneIndex = i
        else
            xmlFile:removeProperty(string.format("%s.customFences.scene(%d)", baseKey, sceneIndex))
        end

        local sceneKey = string.format("%s.customFences.scene(%d)", baseKey, sceneIndex)
        xmlFile:setString(sceneKey .. "#path", scene)

        local fenceTable = self.values.fencePlacement.fenceTable
        local fenceIndex = 0

        for _, fence in ipairs(fenceTable) do
            if fence.isCustom then
                local fenceKey = string.format("%s.fence(%d)", sceneKey, fenceIndex)

                xmlFile:setString(fenceKey .. "#name", fence.name)
                xmlFile:setString(fenceKey .. "#xmlFile", fence.xmlFile)
                xmlFile:setString(fenceKey .. "#imgFile", fence.imgFile)

                fenceIndex = fenceIndex + 1
            end
        end

	elseif tab == self.tabNames[4] then -- Export .OBJ
		local baseKey = "settings.exportObject"
		xmlFile:setString(baseKey .. "#exportPath", self.uiExportOBJPath:getValue())
		xmlFile:setBool(baseKey .. "#useCustomFilename", self.uiExportUseCustomFilename:getValue())
		xmlFile:setString(baseKey .. "#customFileName", self.values.exportObject.customFileName)
		xmlFile:setString(baseKey .. "#createMeshType", self:getChoiceActiveOptionString(self.uiExportType))
		xmlFile:setString(baseKey .. "#distanceType", self:getChoiceActiveOptionString(self.uiExportDistanceType))
		xmlFile:setFloat(baseKey .. "#vertexDistance", self.uiExportDistance:getValue())
		xmlFile:setFloat(baseKey .. "#vertexMinDistance", self.uiExportMinDistance:getValue())
		xmlFile:setFloat(baseKey .. "#vertexMinAngle", self.uiExportMinAngle:getValue())

	elseif tab == self.tabNames[5] then -- Gen. Road Mesh
        local scene = getSceneFilename()
		local baseKey = "settings.roadMesh"
		xmlFile:setString(baseKey .. "#exportPath", self.uiExportStreetPath:getValue())
		
		xmlFile:setString(baseKey .. "#roadName", self.uiRoadName:getValue())
		xmlFile:setString(baseKey .. "#imgPath", self.uiImgRoadPath:getValue())
		
		xmlFile:setString(baseKey .. "#mirrorAtCenter", self:getChoiceActiveOptionString(self.uiMirrorAtCenter))
		xmlFile:setFloat(baseKey .. "#textureDistance", self.uiTextureDistSlider:getValue())
		xmlFile:setFloat(baseKey .. "#textureSliceStart", self.uiTextureSliceStartSlider:getValue())
		xmlFile:setFloat(baseKey .. "#textureSliceEnd", self.uiTextureSliceEndSlider:getValue())
		
		xmlFile:setString(baseKey .. "#terrainDecal", self:getChoiceActiveOptionString(self.uiTerrainDecal))
		xmlFile:setFloat(baseKey .. "#width", self.uiGenRoadWidthSlider:getValue())
		xmlFile:setFloat(baseKey .. "#minSegmentLength", self.uiGenRoadMinSegLenght:getValue())
		xmlFile:setFloat(baseKey .. "#maxAngle", self.uiGenRoadMinAngle:getValue())
		xmlFile:setString(baseKey .. "#alignEdgesOnTerrain", self:getChoiceActiveOptionString(self.uiGenRoadAlignEdges))
		xmlFile:setString(baseKey .. "#trafficCenter", self:getChoiceActiveOptionString(self.uiHasTrafficCenter))
		xmlFile:setString(baseKey .. "#trafficLeft", self:getChoiceActiveOptionString(self.uiHasTrafficLeft))
		xmlFile:setString(baseKey .. "#trafficRight", self:getChoiceActiveOptionString(self.uiHasTrafficRight))
		xmlFile:setFloat(baseKey .. "#leftPercent", self.uiTrafficLeftPerc:getValue())
		xmlFile:setFloat(baseKey .. "#rightPercent", self.uiTrafficRightPerc:getValue())
		xmlFile:setInt(baseKey .. "#maxSpeedScale", self.uiMaxSpeedScale:getValue())
		xmlFile:setInt(baseKey .. "#speedLimit", self.uiSpeedLimit:getValue())
		
		local i = 0
		local sceneIndex = nil

		while xmlFile:hasProperty(string.format("%s.customRoadTextures.scene(%d)", baseKey, i)) do
			if xmlFile:getString(string.format("%s.customRoadTextures.scene(%d)#path", baseKey, i)) == scene then
				sceneIndex = i
				break
			end
			i = i + 1
		end

		if sceneIndex == nil then
			sceneIndex = i
		else
			xmlFile:removeProperty(string.format("%s.customRoadTextures.scene(%d)", baseKey, sceneIndex))
		end

		local sceneKey = string.format("%s.customRoadTextures.scene(%d)", baseKey, sceneIndex)
		xmlFile:setString(sceneKey .. "#path", scene)

		local textureTable = self.values.roadMesh.textureTable
		local textureIndex = 0

		for _, texture in ipairs(textureTable) do

			if texture.isCustom then

				local textureKey = string.format("%s.texture(%d)", sceneKey, textureIndex)

				xmlFile:setString(textureKey .. "#name", texture.name)
				xmlFile:setString(textureKey .. "#imgFile", texture.imgFile)
				xmlFile:setString(textureKey .. "#shaderVar", texture.shaderVar)

				if texture.textures then
					xmlFile:setString(textureKey .. "#diffuse",  texture.textures.diffuse)
					xmlFile:setString(textureKey .. "#specular", texture.textures.specular)
					xmlFile:setString(textureKey .. "#normal",   texture.textures.normal)
					xmlFile:setString(textureKey .. "#height",   texture.textures.height)
					xmlFile:setString(textureKey .. "#alpha",    texture.textures.alpha)
				end

				textureIndex = textureIndex + 1
			end
		end
    end

    xmlFile:save()
    xmlFile:delete()
end

function SplineToolkit:loadSettings(tab)
    local xmlFile = XMLFile.loadIfExists("SplineToolkitSettings", SplineToolkit.SETTINGS_PATH)
    if not xmlFile then return end
    if self:isSettingsOutdated(xmlFile) then
        local storedVersion = xmlFile:getString("settings#version") or "none"
        printWarning(string.format("[SplineToolkit][loadSettings] Version mismatch (current = %s | settings = %s) – using defaults.", SplineToolkit.VERSION, storedVersion))
        xmlFile:delete()
        return
    end

	self.loadSettingChoiceList = {}

	if tab == self.tabNames[1] then -- Base Tools
		local baseKey = "settings.base"
		if xmlFile:hasProperty(baseKey) then
			local values = self.values.base

			values.setOnTerrain.heightOffset = xmlFile:getFloat(baseKey .. "#setOnTerrainHeightOffset") or values.setOnTerrain.heightOffset
			values.setOffset.sideOffset = xmlFile:getFloat(baseKey .. "#offsetSide") or values.setOffset.sideOffset
			values.setOffset.heightOffset = xmlFile:getFloat(baseKey .. "#offsetHeight") or values.setOffset.heightOffset
			values.setTerrainHeight.terrainHeight = xmlFile:getFloat(baseKey .. "#terrainHeight") or values.setTerrainHeight.terrainHeight
			values.setTerrainHeight.terrainWidth = xmlFile:getFloat(baseKey .. "#terrainWidth") or values.setTerrainHeight.terrainWidth
			values.setTerrainHeight.smoothDistance = xmlFile:getFloat(baseKey .. "#terrainSmoothDistance") or values.setTerrainHeight.smoothDistance
			values.paintTerrain.widthLeft = xmlFile:getFloat(baseKey .. "#paintWidthLeft") or values.paintTerrain.widthLeft
			values.paintTerrain.widthRight = xmlFile:getFloat(baseKey .. "#paintWidthRight") or values.paintTerrain.widthRight
			
			values.setFoliage.widthLeft = xmlFile:getFloat(baseKey .. "#foliageWidthLeft") or values.setFoliage.widthLeft
			values.setFoliage.widthRight = xmlFile:getFloat(baseKey .. "#foliageWidthRight") or values.setFoliage.widthRight
			values.resampleSpline.numPoints = xmlFile:getInt(baseKey .. "#numSplinePoints") or values.resampleSpline.numPoints
		end

	elseif tab == self.tabNames[2] then -- Place Objects
		local baseKey = "settings.objectPlacement"
		if xmlFile:hasProperty(baseKey) then
			local values = self.values.objectPlacement
			-- values.activeModeIndex = xmlFile:getInt(baseKey .. "#activeModeIndex")
			-- Spline settings (values always loaded, choices only if spline subpage is active)
			values.sideOffset = xmlFile:getFloat(baseKey .. "#sideOffset") or values.sideOffset
			values.objectFixDistance = xmlFile:getFloat(baseKey .. "#objectFixDistance") or values.objectFixDistance
			values.objectMinDistance = xmlFile:getFloat(baseKey .. "#objectMinDistance") or values.objectMinDistance
			values.objectMaxDistance = xmlFile:getFloat(baseKey .. "#objectMaxDistance") or values.objectMaxDistance
			values.objectHeight = xmlFile:getFloat(baseKey .. "#objectHeight") or values.objectHeight
			values.objectRotate = xmlFile:getFloat(baseKey .. "#objectRotate") or values.objectRotate
			-- Area settings (values always loaded, choices only if area subpage is active)
			values.areaMinDistBetween = xmlFile:getFloat(baseKey .. "#areaMinDistBetween") or values.areaMinDistBetween
			values.areaMaxDistBetween = xmlFile:getFloat(baseKey .. "#areaMaxDistBetween") or values.areaMaxDistBetween
			values.areaWidthLeft = xmlFile:getFloat(baseKey .. "#areaWidthLeft") or values.areaWidthLeft
			values.areaWidthCenter = xmlFile:getFloat(baseKey .. "#areaWidthCenter") or values.areaWidthCenter
			values.areaWidthRight = xmlFile:getFloat(baseKey .. "#areaWidthRight") or values.areaWidthRight
			if values.activeModeIndex == 2 then
				table.insert(self.loadSettingChoiceList, {uiKey="uiAreaLeftEnabled", options=values.areaChoiceOptions, selected=xmlFile:getString(baseKey .. "#areaLeftEnabled")})
				table.insert(self.loadSettingChoiceList, {uiKey="uiAreaCenterEnabled", options=values.areaChoiceOptions, selected=xmlFile:getString(baseKey .. "#areaCenterEnabled")})
				table.insert(self.loadSettingChoiceList, {uiKey="uiAreaRightEnabled", options=values.areaChoiceOptions, selected=xmlFile:getString(baseKey .. "#areaRightEnabled")})
			else
				table.insert(self.loadSettingChoiceList, {uiKey="uiObjectDistanceType", options=values.objDistanceType, selected=xmlFile:getString(baseKey .. "#objDistanceType")})
				table.insert(self.loadSettingChoiceList, {uiKey="uiSetHeightType", options=values.setHeightType, selected=xmlFile:getString(baseKey .. "#setHeightType")})
				table.insert(self.loadSettingChoiceList, {uiKey="uiRandomRotate", options=values.setRandomRotate, selected=xmlFile:getString(baseKey .. "#setRandomRotate")})
			end
		end

	elseif tab == self.tabNames[3] then -- Place Fence
		local scene = getSceneFilename()
		local baseKey = "settings.placeFence"
		local values = self.values.fencePlacement

		if xmlFile:hasProperty(baseKey) then
			values.imgPath = xmlFile:getString(baseKey .. "#imgPath") or values.imgPath

			table.insert(self.loadSettingChoiceList, {uiKey="uiFencePlaceYOffset", options=values.useYOffset, selected=xmlFile:getString(baseKey .. "#useYOffset")})
			table.insert(self.loadSettingChoiceList, {uiKey="uiFencePlaceStartPole", options=values.placeStartPole, selected=xmlFile:getString(baseKey .. "#placeStartPole")})
			table.insert(self.loadSettingChoiceList, {uiKey="uiFencePlaceEndPole", options=values.placeEndPole, selected=xmlFile:getString(baseKey .. "#placeEndPole")})

			local i = 0
			while xmlFile:hasProperty(string.format("%s.customFences.scene(%d)", baseKey, i)) do
				local sceneKey = string.format("%s.customFences.scene(%d)", baseKey, i)
				if xmlFile:getString(sceneKey .. "#path") == scene then
					local fenceIndex = 0
					while xmlFile:hasProperty(string.format("%s.fence(%d)", sceneKey, fenceIndex)) do
						local fenceKey = string.format("%s.fence(%d)", sceneKey, fenceIndex)
						table.insert(values.fenceTable, {name=xmlFile:getString(fenceKey .. "#name") or "", xmlFile=xmlFile:getString(fenceKey .. "#xmlFile") or "", imgFile=xmlFile:getString(fenceKey .. "#imgFile") or "", isCustom=true})
						fenceIndex = fenceIndex + 1
					end
					break
				end
				i = i + 1
			end
		end

	elseif tab == self.tabNames[4] then -- Export .OBJ
		local baseKey = "settings.exportObject"
		local values = self.values.exportObject
		if xmlFile:hasProperty(baseKey) then
			values.exportPath = xmlFile:getString(baseKey .. "#exportPath") or values.exportPath
			values.useCustomFilename = xmlFile:getBool(baseKey .. "#useCustomFilename")
			values.customFileName = xmlFile:getString(baseKey .. "#customFileName") or values.customFileName
			values.vertexDistance = xmlFile:getFloat(baseKey .. "#vertexDistance") or values.vertexDistance
			values.vertexMinDistance = xmlFile:getFloat(baseKey .. "#vertexMinDistance") or values.vertexMinDistance
			values.vertexMinAngle = xmlFile:getFloat(baseKey .. "#vertexMinAngle") or values.vertexMinAngle

			table.insert(self.loadSettingChoiceList, {uiKey="uiExportType", options=values.createMeshType, selected=xmlFile:getString(baseKey .. "#createMeshType")})
			table.insert(self.loadSettingChoiceList, {uiKey="uiExportDistanceType", options=values.distanceType, selected=xmlFile:getString(baseKey .. "#distanceType")})
		end

	elseif tab == self.tabNames[5] then -- Gen. Road Mesh
		local scene = getSceneFilename()
		local baseKey = "settings.roadMesh"
		local values = self.values.roadMesh
		if xmlFile:hasProperty(baseKey) then
			values.exportPath = xmlFile:getString(baseKey .. "#exportPath") or values.exportPath
			values.roadName = xmlFile:getString(baseKey .. "#roadName") or values.roadName
			
			values.imgPath = xmlFile:getString(baseKey .. "#imgPath") or values.imgPath
			values.textureDistance = xmlFile:getFloat(baseKey .. "#textureDistance") or values.textureDistance
			values.sliceStart = xmlFile:getFloat(baseKey .. "#textureSliceStart") or values.sliceStart
			values.sliceEnd = xmlFile:getFloat(baseKey .. "#textureSliceEnd") or values.sliceEnd
			table.insert(self.loadSettingChoiceList, {uiKey="uiMirrorAtCenter", options=values.mirrorAtCenter, selected=xmlFile:getString(baseKey .. "#mirrorAtCenter")})
			table.insert(self.loadSettingChoiceList, {uiKey="uiTerrainDecal", options=values.terrainDecal, selected=xmlFile:getString(baseKey .. "#terrainDecal")})
			
			values.width = xmlFile:getFloat(baseKey .. "#width") or values.width
			values.minSegmentLength = xmlFile:getFloat(baseKey .. "#minSegmentLength") or values.minSegmentLength
			values.maxAngle = xmlFile:getFloat(baseKey .. "#maxAngle") or values.maxAngle
			values.leftPercent = xmlFile:getFloat(baseKey .. "#leftPercent") or values.leftPercent
			values.rightPercent = xmlFile:getFloat(baseKey .. "#rightPercent") or values.rightPercent
			values.maxSpeedScale = xmlFile:getInt(baseKey .. "#maxSpeedScale") or values.maxSpeedScale
			values.speedLimit = xmlFile:getInt(baseKey .. "#speedLimit") or values.speedLimit

			table.insert(self.loadSettingChoiceList, {uiKey="uiAlignEdgesChoice", options=values.alignEdgesOnTerrain, selected=xmlFile:getString(baseKey .. "#alignEdgesOnTerrain")})
			table.insert(self.loadSettingChoiceList, {uiKey="uiHasTrafficCenter", options=values.trafficCenter, selected=xmlFile:getString(baseKey .. "#trafficCenter")})
			table.insert(self.loadSettingChoiceList, {uiKey="uiHasTrafficLeft", options=values.trafficLeft, selected=xmlFile:getString(baseKey .. "#trafficLeft")})
			table.insert(self.loadSettingChoiceList, {uiKey="uiHasTrafficRight", options=values.trafficRight, selected=xmlFile:getString(baseKey .. "#trafficRight")})
			
			
			local i = 0
			while xmlFile:hasProperty(string.format("%s.customRoadTextures.scene(%d)", baseKey, i)) do
				local sceneKey = string.format("%s.customRoadTextures.scene(%d)", baseKey, i)

				if xmlFile:getString(sceneKey .. "#path") == scene then

					local textureIndex = 0
					while xmlFile:hasProperty(string.format("%s.texture(%d)", sceneKey, textureIndex)) do

						local textureKey = string.format("%s.texture(%d)", sceneKey, textureIndex)

						table.insert(values.textureTable, {
							name      = xmlFile:getString(textureKey .. "#name") or "",
							imgFile   = xmlFile:getString(textureKey .. "#imgFile") or "",
							shaderVar = xmlFile:getString(textureKey .. "#shaderVar") or "",

							textures = {
								diffuse  = xmlFile:getString(textureKey .. "#diffuse"),
								specular = xmlFile:getString(textureKey .. "#specular"),
								normal   = xmlFile:getString(textureKey .. "#normal"),
								height   = xmlFile:getString(textureKey .. "#height"),
								alpha    = xmlFile:getString(textureKey .. "#alpha"),
							},

							isCustom = true
						})

						textureIndex = textureIndex + 1
					end

					break
				end

				i = i + 1
			end
			
		end
	end

	xmlFile:delete()
end

function SplineToolkit:togglePreview(mode)
    if not self.preview then return end
    local currentState = self.preview.state[mode] or 0
    local newState = (currentState + 1) % 3

    self.preview.state[mode] = newState

    ------------------------------------------------
    -- ALLE ANDEREN MODES RESETTEN
    ------------------------------------------------
    for m,btn in pairs(self.preview.buttons) do
        if m ~= mode then
            self.preview.state[m] = 0
            if btn then
                btn:setBackgroundColor(unpack(self.preview.colors.off))
            end
        end
    end

    local btn = self.preview.buttons[mode]

    ------------------------------------------------
    -- STATE HANDLING
    ------------------------------------------------
    if newState == 0 then
        -- AUS
        if btn then
            btn:setBackgroundColor(unpack(self.preview.colors.off))
        end

		self:togglePlayingState(false)
		drawDebugSetDimmingState(false)
        self.preview.active = false
        self.preview.mode = nil

        if self.previewDrawCallback then
            removeDrawListener(self.previewDrawCallback)
            self.previewDrawCallback = nil
        end

        print("[SplineToolkit] Preview OFF")

    else
        -- EIN / DIMMING
        self.preview.active = true
        self.preview.mode = mode

		self:togglePlayingState(true)
        if newState == 1 then
            btn:setBackgroundColor(unpack(self.preview.colors.preview))
            print("[SplineToolkit] Preview ON")
			drawDebugSetDimmingState(false)
        elseif newState == 2 then
            btn:setBackgroundColor(unpack(self.preview.colors.dimmed))
			drawDebugSetDimmingState(true)
            print("[SplineToolkit] Preview DIMMED")
        end

        if not self.previewDrawCallback then
            self.previewDrawCallback = addDrawListener("splineToolkit_previewDraw", self, self.previewDraw)
        end
    end
end

function SplineToolkit:disableAllPreviews()
    if not self.preview then return end

    for mode,btn in pairs(self.preview.buttons) do
        self.preview.state[mode] = 0
        if btn then
            btn:setBackgroundColor(unpack(self.preview.colors.off))
        end
    end

	self:togglePlayingState(false)
	drawDebugSetDimmingState(false)
    self.preview.active = false
    self.preview.mode = nil

    if self.previewDrawCallback then
        removeDrawListener(self.previewDrawCallback)
        self.previewDrawCallback = nil
		print("[SplineToolkit] All previews disabled")
    end

end


-- Converts a DRAW_COLORS entry to four floats via EditorUtils.colorIntToFloat
local function dc(key)
    local c = SplineToolkit.DRAW_COLORS[key]
    local f = EditorUtils.colorIntToFloat
    return f(c[1]), f(c[2]), f(c[3]), f(c[4] or 255)
end

local function dbgPoint(x, y, z, key, depthTest)
    local r, g, b, a = dc(key)
    drawDebugPoint(x, y, z, r, g, b, a, depthTest)
end

local function dbgLine(x1, y1, z1, key, x2, y2, z2, depthTest)
    local r, g, b = dc(key)
    drawDebugLine(x1, y1, z1, r, g, b, x2, y2, z2, r, g, b, depthTest)
end

local function dbgPoly(verts, key, depthTest)
    local r, g, b, a = dc(key)
    drawDebugPolygon(verts, r, g, b, a, depthTest)
end

local function sampleSplineAdaptive(spline, angleThreshold, maxDepth)

    local points = {}

    local function getDir(a,b)
        local dx,dy,dz = b[1]-a[1], b[2]-a[2], b[3]-a[3]
        local len = MathUtil.vector3Length(dx,dy,dz)
        if len < 0.0001 then return nil end
        return dx/len, dy/len, dz/len
    end

    local function recurse(t1, t2, depth)

        if depth > maxDepth then return end

        local tm = (t1 + t2) * 0.5

        local p1 = {getSplinePosition(spline, t1)}
        local pm = {getSplinePosition(spline, tm)}
        local p2 = {getSplinePosition(spline, t2)}

        local d1 = {getDir(p1, pm)}
        local d2 = {getDir(pm, p2)}

        if d1[1] == nil or d2[1] == nil then return end

        local dot = d1[1]*d2[1] + d1[2]*d2[2] + d1[3]*d2[3]
        dot = math.max(-1, math.min(1, dot))

        local angle = math.acos(dot)

        if angle > angleThreshold then
            recurse(t1, tm, depth+1)
            recurse(tm, t2, depth+1)
        else
            table.insert(points, p1)
        end
    end

    recurse(0,1,0)

    -- letzten Punkt hinzufügen!
    local last = {getSplinePosition(spline, 1)}
    table.insert(points, last)

    return points
end

local function buildOffsetPoints(points, widthLeft, widthRight, terrain, yOffset)
    yOffset = yOffset or 0.05

    local left = {}
    local right = {}

    for i=1,#points do

        local p = points[i]

        local prev = points[math.max(i-1,1)]
        local next = points[math.min(i+1,#points)]

        local dirX = next[1] - prev[1]
        local dirY = next[2] - prev[2]
        local dirZ = next[3] - prev[3]

        local len = MathUtil.vector3Length(dirX,dirY,dirZ)
        if len > 0.0001 then
            dirX,dirY,dirZ = dirX/len, dirY/len, dirZ/len
        end

        local nx,ny,nz = MathUtil.crossProduct(dirX,dirY,dirZ, 0,1,0)

        local nLen = MathUtil.vector3Length(nx,ny,nz)
        if nLen > 0.0001 then
            nx,ny,nz = nx/nLen, ny/nLen, nz/nLen
        end

        local lx = p[1] - nx * widthLeft
        local lz = p[3] - nz * widthLeft
        local rx = p[1] + nx * widthRight
        local rz = p[3] + nz * widthRight

        local ly = terrain and (getTerrainHeightAtWorldPos(terrain, lx, 0, lz) or p[2]) or p[2]
        local ry = terrain and (getTerrainHeightAtWorldPos(terrain, rx, 0, rz) or p[2]) or p[2]

        table.insert(left,  {lx, ly + yOffset, lz})
        table.insert(right, {rx, ry + yOffset, rz})
    end

    return left, right
end

function SplineToolkit:drawSplineArea(spline, widthLeft, widthRight, r,g,b,a)
    if spline == nil or spline == 0 then return end

    local angleThreshold = math.rad(0.75)
    local maxDepth = 30
    local points = sampleSplineAdaptive(spline, angleThreshold, maxDepth)

    if #points < 2 then return end
    local terrain = self:getTerrain()
    local leftPoints, rightPoints = buildOffsetPoints(points, widthLeft, widthRight, terrain, 0.1)
    for i=1,#points-1 do
        local l1 = leftPoints[i];  local l2 = leftPoints[i+1]
        local r1 = rightPoints[i]; local r2 = rightPoints[i+1]
        drawDebugPolygon({l1[1],l1[2],l1[3], r1[1],r1[2],r1[3], r2[1],r2[2],r2[3]}, r,g,b,a,false)
        drawDebugPolygon({l1[1],l1[2],l1[3], r2[1],r2[2],r2[3], l2[1],l2[2],l2[3]}, r,g,b,a,false)
    end

    for i=1,#leftPoints-1 do
        local a = leftPoints[i]
        local b = leftPoints[i+1]
        dbgLine(a[1],a[2],a[3], "LINE_EDGE", b[1],b[2],b[3], false)
    end

    for i=1,#rightPoints-1 do
        local a = rightPoints[i]
        local b = rightPoints[i+1]
        dbgLine(a[1],a[2],a[3], "LINE_EDGE", b[1],b[2],b[3], false)
    end
end

function SplineToolkit:drawSplineOffsetStrip(spline, lat1, lat2, r, g, b, a)
    local points = sampleSplineAdaptive(spline, math.rad(0.75), 30)
    if #points < 2 then return end

    local terrain = self:getTerrain()
    local edge1, edge2 = {}, {}
    for i = 1, #points do
        local p    = points[i]
        local prev = points[math.max(i-1, 1)]
        local next = points[math.min(i+1, #points)]

        local dirX = next[1] - prev[1]
        local dirY = next[2] - prev[2]
        local dirZ = next[3] - prev[3]
        local len  = MathUtil.vector3Length(dirX, dirY, dirZ)
        if len > 0.0001 then dirX, dirY, dirZ = dirX/len, dirY/len, dirZ/len end

        local nx, ny, nz = MathUtil.crossProduct(dirX, dirY, dirZ, 0, 1, 0)
        local nLen = MathUtil.vector3Length(nx, ny, nz)
        if nLen > 0.0001 then nx, ny, nz = nx/nLen, ny/nLen, nz/nLen end

        local e1x = p[1] + nx*lat1;  local e1z = p[3] + nz*lat1
        local e2x = p[1] + nx*lat2;  local e2z = p[3] + nz*lat2
        local e1y = terrain and (getTerrainHeightAtWorldPos(terrain, e1x, 0, e1z) or p[2]) or p[2]
        local e2y = terrain and (getTerrainHeightAtWorldPos(terrain, e2x, 0, e2z) or p[2]) or p[2]
        table.insert(edge1, {e1x, e1y + 0.1, e1z})
        table.insert(edge2, {e2x, e2y + 0.1, e2z})
    end

    for i = 1, #edge1 - 1 do
        local e1a, e1b = edge1[i], edge1[i+1]
        local e2a, e2b = edge2[i], edge2[i+1]
        drawDebugPolygon({e1a[1],e1a[2],e1a[3], e2a[1],e2a[2],e2a[3], e2b[1],e2b[2],e2b[3]}, r, g, b, a, false)
        drawDebugPolygon({e1a[1],e1a[2],e1a[3], e2b[1],e2b[2],e2b[3], e1b[1],e1b[2],e1b[3]}, r, g, b, a, false)
    end

    for i = 1, #edge1 - 1 do
        local pa, pb = edge1[i], edge1[i+1]
        drawDebugLine(pa[1],pa[2],pa[3], r,g,b, pb[1],pb[2],pb[3], r,g,b, false)
        pa, pb = edge2[i], edge2[i+1]
        drawDebugLine(pa[1],pa[2],pa[3], r,g,b, pb[1],pb[2],pb[3], r,g,b, false)
    end
end

function SplineToolkit:drawTerrainHeightAdaptive(spline, halfWidth, smooth, heightOffset)
    if spline == nil or spline == 0 then return end

    local angleThreshold = math.rad(0.5)
    local maxDepth = 50

    local points = sampleSplineAdaptive(spline, angleThreshold, maxDepth)
    if #points < 2 then return end

    local terrain = self:getTerrain()

    local leftOuter  = {}
    local rightOuter = {}
    local leftInner  = {}
    local rightInner = {}

    for i=1,#points do
        local p = points[i]
        local prev = points[math.max(i-1,1)]
        local next = points[math.min(i+1,#points)]

        local dirX = next[1] - prev[1]
        local dirY = next[2] - prev[2]
        local dirZ = next[3] - prev[3]

        local len = MathUtil.vector3Length(dirX,dirY,dirZ)
        if len > 0.0001 then
            dirX,dirY,dirZ = dirX/len, dirY/len, dirZ/len
        end

        local nx,ny,nz = MathUtil.crossProduct(dirX,dirY,dirZ, 0,1,0)
        local nLen = MathUtil.vector3Length(nx,ny,nz)
        if nLen > 0.0001 then
            nx,ny,nz = nx/nLen, ny/nLen, nz/nLen
        end

        local outer = halfWidth + smooth
        local inner = halfWidth

        local loX = p[1] - nx*outer;  local loZ = p[3] - nz*outer
        local roX = p[1] + nx*outer;  local roZ = p[3] + nz*outer
        local liX = p[1] - nx*inner;  local liZ = p[3] - nz*inner
        local riX = p[1] + nx*inner;  local riZ = p[3] + nz*inner

        local loY = terrain and (getTerrainHeightAtWorldPos(terrain, loX, 0, loZ) or p[2]) or p[2]
        local roY = terrain and (getTerrainHeightAtWorldPos(terrain, roX, 0, roZ) or p[2]) or p[2]

        local splineTopY = p[2] + heightOffset

        table.insert(leftOuter,  {loX, loY + 0.05, loZ})
        table.insert(rightOuter, {roX, roY + 0.05, roZ})
        table.insert(leftInner,  {liX, splineTopY, liZ})
        table.insert(rightInner, {riX, splineTopY, riZ})
    end

    local function drawQuad(A, B, C, D, r, g, b, a)
        -- Two explicit triangles to ensure consistent triangulation across adjacent quads
        drawDebugPolygon({A[1],A[2],A[3], B[1],B[2],B[3], C[1],C[2],C[3]}, r,g,b,a,false)
        drawDebugPolygon({A[1],A[2],A[3], C[1],C[2],C[3], D[1],D[2],D[3]}, r,g,b,a,false)
    end

    for i=1,#points-1 do
        local LO1,LO2 = leftOuter[i],  leftOuter[i+1]
        local RO1,RO2 = rightOuter[i], rightOuter[i+1]
        local LI1,LI2 = leftInner[i],  leftInner[i+1]
        local RI1,RI2 = rightInner[i], rightInner[i+1]

        drawQuad(LO1, LI1, LI2, LO2, dc("TERRAIN_SMOOTH_ZONE")) -- left smooth zone
        drawQuad(LI1, RI1, RI2, LI2, dc("TERRAIN_CENTER"))      -- center
        drawQuad(RI1, RO1, RO2, RI2, dc("TERRAIN_SMOOTH_ZONE")) -- right smooth zone
    end

    local function drawLineStrip(pts)
        for i=1,#pts-1 do
            local a = pts[i]
            local b = pts[i+1]
            dbgLine(a[1],a[2],a[3], "LINE_EDGE", b[1],b[2],b[3], false)
        end
    end

    drawLineStrip(leftOuter)
    drawLineStrip(rightOuter)
    drawLineStrip(leftInner)
    drawLineStrip(rightInner)
end

function SplineToolkit:previewDraw()
    if not self.preview or not self.preview.active then
        return
    end

    local mode = self.preview.mode
    local selectionCount = getNumSelected()
    if selectionCount == 0 and mode ~= "placeObject" then return end

    if mode == "setOffset" then
        local sideOffset   = self.uiOffsetSideOffset:getValue()
        local heightOffset = self.uiOffsetHeightOffset:getValue()

        for s=0,selectionCount-1 do
            local spline = getSelection(s)
            if spline ~= nil and spline ~= 0 and getSplineNumOfCV(spline) ~= nil then
                local numCV = getSplineNumOfCV(spline)
                local prevX, prevY, prevZ = nil,nil,nil
                for i=0,numCV-1 do
                    local x,y,z = getSplineEP(spline, i)

                    local dirX,dirY,dirZ
                    if i < numCV-1 then
                        local nx,ny,nz = getSplineEP(spline, i+1)
                        dirX,dirY,dirZ = nx-x, ny-y, nz-z
                    else
                        local px,py,pz = getSplineCV(spline, i-1)
                        dirX,dirY,dirZ = x-px, y-py, z-pz
                    end

                    local len = MathUtil.vector3Length(dirX,dirY,dirZ)
                    if len > 0.0001 then
                        dirX,dirY,dirZ = dirX/len, dirY/len, dirZ/len
                    end

                    local rx,ry,rz = MathUtil.crossProduct(dirX,dirY,dirZ, 0,1,0)

                    local rLen = MathUtil.vector3Length(rx,ry,rz)
                    if rLen > 0.0001 then
                        rx,ry,rz = rx/rLen, ry/rLen, rz/rLen
                    end

                    local ox = x + rx * sideOffset
                    local oy = y + heightOffset
                    local oz = z + rz * sideOffset

                    dbgPoint(ox, oy, oz, "POINT_SAMPLE", true)

                    if prevX ~= nil then
                        local er,eg,eb = dc("LINE_EDGE")
                        drawDebugLine(prevX,prevY,prevZ, er,eg,eb, ox,oy,oz, er,eg,eb, true)
                    end

                    prevX,prevY,prevZ = ox,oy,oz
                end
            end
        end
    elseif mode == "setTerrainHeight" then
        local heightOffset = self.uiTerrainHeightHeightOffset:getValue()
        local width        = self.uiTerrainHeightWidth:getValue() / 2
        local smooth       = self.uiTerrainHeightSmoothDist:getValue()
        for s=0,selectionCount-1 do
            local spline = getSelection(s)
            if spline ~= nil and spline ~= 0 and getSplineNumOfCV(spline) ~= nil then
                self:drawTerrainHeightAdaptive(spline, width, smooth, heightOffset)
            end
        end
    elseif mode == "paintTerrain" then
        local left  = self.uiPaintWidthLeft:getValue()
        local right = self.uiPaintWidthRight:getValue()

        for i=0,selectionCount-1 do
            local node = getSelection(i)
            if node ~= nil and node ~= 0 and getSplineNumOfCV(node) ~= nil then
                self:drawSplineArea(node, left, right, dc("PAINT_FILL"))
            end
        end
    elseif mode == "setFoliage" then
        local left  = self.uiFoliageWidthLeft:getValue()
        local right = self.uiFoliageWidthRight:getValue()

        for i=0,selectionCount-1 do
            local node = getSelection(i)
            if node ~= nil and node ~= 0 and getSplineNumOfCV(node) ~= nil then
                self:drawSplineArea(node, left, right, dc("FOLIAGE_FILL"))
            end
        end
	elseif mode == "resampleSpline" then
		local selectionCount = getNumSelected()
		if selectionCount == 0 then return end

		local targetPoints = math.max(self.uiNumOfPoints:getValue(), 2)
		local yOffset = 0.5

		for s=0,selectionCount-1 do
			local spline = getSelection(s)
			if not self:getIsSpline(spline) then
				printWarning("[SplineToolkit] Selected node is not a spline")
			else
				local length = getSplineLength(spline)
				if length > 0 then
					local step = 1.0 / (targetPoints - 1)
					local prevX, prevY, prevZ = nil,nil,nil

					for i = 0, targetPoints - 1 do
						local t = i * step
						local x,y,z = getSplinePosition(spline, t)
						y = y + yOffset
						
						dbgPoint(x, y, z, "POINT_SAMPLE", true)
						
						if prevX ~= nil then
							dbgLine(prevX,prevY,prevZ, "LINE_PATH", x,y,z, true)
						end

						prevX,prevY,prevZ = x,y,z
					end
				end
			end
		end
	elseif mode == "export" then
		local selectionCount = getNumSelected()
		if selectionCount == 0 then return end

		local meshType  = self.uiExportType:getValue()
		local distType  = self.uiExportDistanceType:getValue()
		local fixedDist = self.uiExportDistance:getValue()
		local minDist   = self.uiExportMinDistance:getValue()
		local minAngle  = math.rad(self.uiExportMinAngle:getValue())

		local yOffset = 0.5

		for s = 0, selectionCount - 1 do
			local spline = getSelection(s)
			if not self:getIsSpline(spline) then
				printWarning("[SplineToolkit] Selected node is not a spline")
			else
				local prevX, prevY, prevZ = nil,nil,nil

				if meshType == 1 then
					local numCVs = getSplineNumOfCV(spline)
					for i = 0, numCVs - 1 do
						local x,y,z = getSplineCV(spline, i)
						y = y + yOffset

						dbgPoint(x,y,z, "POINT_SAMPLE", true)

						if prevX ~= nil then
							dbgLine(prevX,prevY,prevZ, "LINE_PATH", x,y,z, true)
						end

						prevX,prevY,prevZ = x,y,z
					end
				else
					local length = getSplineLength(spline)
					if length <= 0 then return end

					local t = 0.0
					local internalStep = 0.05

					local lastX,lastY,lastZ = nil,nil,nil
					local lastDirX,lastDirY,lastDirZ = nil,nil,nil

					while t <= length do
						local px,py,pz = getSplinePosition(spline, t/length)
						local dx,dy,dz = getSplineDirection(spline, t/length)
						local addVertex = false

						if not lastX then
							addVertex = true
						else
							local dist = math.sqrt((px-lastX)^2 + (py-lastY)^2 + (pz-lastZ)^2)

							if distType == 1 then
								if dist >= fixedDist then
									addVertex = true
								end
							else
								if dist >= minDist then
									local dot = dx*lastDirX + dy*lastDirY + dz*lastDirZ
									dot = math.max(-1, math.min(1, dot))
									local angle = math.acos(dot)

									if angle >= minAngle then
										addVertex = true
									end
								end
							end
						end
						if addVertex then
							local x = px
							local y = py + yOffset
							local z = pz
							dbgPoint(x,y,z, "POINT_SAMPLE", true)
							if prevX ~= nil then
								dbgLine(prevX,prevY,prevZ, "LINE_PATH", x,y,z, true)
							end
							prevX,prevY,prevZ = x,y,z
							lastX,lastY,lastZ = px,py,pz
							lastDirX,lastDirY,lastDirZ = dx,dy,dz
						end
						t = t + internalStep
					end

					local px,py,pz = getSplinePosition(spline, 1.0)
					local x = px
					local y = py + yOffset
					local z = pz

					dbgPoint(x,y,z, "POINT_SAMPLE", true)

					if prevX ~= nil then
						dbgLine(prevX,prevY,prevZ, "LINE_PATH", x,y,z, true)
					end
				end
			end
		end
	elseif mode == "placeObject" then
		-- find SourceSplines TG without creating anything
		local srcSplineTG = nil
		local ok, mainContainer = pcall(self.getSplineToolkitTransformgroup, self)
		if ok and mainContainer and mainContainer ~= 0 then
			for i = 0, getNumOfChildren(mainContainer) - 1 do
				local child = getChildAt(mainContainer, i)
				if child and child ~= 0 and getName(child) == "SetObjectsBySpline" then
					for j = 0, getNumOfChildren(child) - 1 do
						local sub = getChildAt(child, j)
						if sub and sub ~= 0 and getName(sub) == "SourceSplines" then
							srcSplineTG = sub
							break
						end
					end
					break
				end
			end
		end
		if not srcSplineTG then return end

		if self.placeObjectLastMode == "area" and self.uiAreaWidthCenter then
			local halfCenter = self.uiAreaWidthCenter:getValue() * 0.5
			local widthLeft  = self.uiAreaWidthLeft:getValue()
			local widthRight = self.uiAreaWidthRight:getValue()
			local leftOn     = self:getChoiceActiveOptionString(self.uiAreaLeftEnabled)   == "Enable"
			local centerOn   = self:getChoiceActiveOptionString(self.uiAreaCenterEnabled) == "Enable"
			local rightOn    = self:getChoiceActiveOptionString(self.uiAreaRightEnabled)  == "Enable"

			for i = 0, getNumOfChildren(srcSplineTG) - 1 do
				local node = getChildAt(srcSplineTG, i)
				if self:isSpline(node) then
					if SplineToolkit.GERMANY_EASTER_EGG then
						if leftOn   then self:drawSplineOffsetStrip(node, -(halfCenter + widthLeft), -halfCenter, dc("PLACE_EGG_LEFT"))   end
						if centerOn then self:drawSplineOffsetStrip(node,  -halfCenter,  halfCenter,  dc("PLACE_EGG_CENTER")) end
						if rightOn  then self:drawSplineOffsetStrip(node,   halfCenter,  halfCenter + widthRight, dc("PLACE_EGG_RIGHT")) end
					else
						if leftOn   then self:drawSplineOffsetStrip(node, -(halfCenter + widthLeft), -halfCenter, dc("PLACE_LEFT"))   end
						if centerOn then self:drawSplineOffsetStrip(node,  -halfCenter,  halfCenter,  dc("PLACE_CENTER")) end
						if rightOn  then self:drawSplineOffsetStrip(node,   halfCenter,  halfCenter + widthRight, dc("PLACE_RIGHT")) end
					end
				end
			end
		else
			local sideOffset = self.uiPlaceOffsetSide and self.uiPlaceOffsetSide:getValue() or 0
			for i = 0, getNumOfChildren(srcSplineTG) - 1 do
				local spline = getChildAt(srcSplineTG, i)
				if self:isSpline(spline) then
					self:drawSplineArea(spline, -sideOffset, sideOffset, dc("PLACE_CENTER"))
				end
			end
		end

	elseif mode == "street" then
		local selectionCount = getNumSelected()
		if selectionCount == 0 then return end

		for s=0,selectionCount-1 do
			local spline = getSelection(s)
			if self:getIsSpline(spline) then
				local segments = self:buildAdaptiveSegments(spline)
				local alignEdges = self:getChoiceBoolean(self.uiGenRoadAlignEdges)
				local verts, _, faces = self:buildMesh(spline, segments, alignEdges)

				if not verts or not faces then return end
				
				local yOffset = 0.5
				local lineOffset  = yOffset + 0.05

				for _, face in ipairs(faces) do
					local v1 = verts[face[1]]
					local v2 = verts[face[2]]
					local v3 = verts[face[3]]

					if v1 and v2 and v3 then
						dbgLine(v1[1],v1[2]+lineOffset,v1[3], "STREET_WIRE", v2[1],v2[2]+lineOffset,v2[3], false)
						dbgLine(v2[1],v2[2]+lineOffset,v2[3], "STREET_WIRE", v3[1],v3[2]+lineOffset,v3[3], false)
						dbgLine(v3[1],v3[2]+lineOffset,v3[3], "STREET_WIRE", v1[1],v1[2]+lineOffset,v1[3], false)
						dbgPoly({v1[1], v1[2] + yOffset, v1[3], v2[1], v2[2] + yOffset, v2[3], v3[1], v3[2] + yOffset, v3[3]}, "STREET_FILL", false)
					end
				end
			end
		end
	end
end

SplineToolkit.new()
