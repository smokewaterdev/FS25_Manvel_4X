from __future__ import annotations

from pathlib import Path
import xml.etree.ElementTree as ET

REPO_ROOT = Path(__file__).resolve().parent.parent
GAME_DATA = Path(r"C:\Farming Simulator 2025\data")
PERIODS = [
    "EARLY_SPRING", "MID_SPRING", "LATE_SPRING",
    "EARLY_SUMMER", "MID_SUMMER", "LATE_SUMMER",
    "EARLY_AUTUMN", "MID_AUTUMN", "LATE_AUTUMN",
    "EARLY_WINTER", "MID_WINTER", "LATE_WINTER",
]

ET.register_namespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")

CROPS = {
    "wheat": {"folder": "wheat", "file": "wheat.xml", "missions": True, "annual": ((1, 2), (5, 6), ["greenSmall", "greenMiddle", "greenBig", "harvestReady"])},
    "barley": {"folder": "barley", "file": "barley.xml", "missions": True, "annual": ((1, 2), (4, 5), ["greenSmall", "greenBig", "harvestReady"])},
    "canola": {"folder": "canola", "file": "canola.xml", "missions": True, "annual": ((1, 2), (5, 6), ["greenSmall", "greenMiddle", "greenBig", "harvestReady"])},
    "oat": {"folder": "oat", "file": "oat.xml", "missions": True, "annual": ((1, 2), (5, 6), ["greenSmall", "greenMiddle", "greenBig", "harvestReady"])},
    "maize": {"folder": "maize", "file": "maize.xml", "missions": True, "annual": ((2, 2), (7, 8), ["greenSmall", "greenMiddle", "greenBig", "harvestReadyGreen", "harvestReadyGreen2", "harvestReady3"])},
    "sunflower": {"folder": "sunflower", "file": "sunflower.xml", "missions": True, "annual": ((2, 3), (6, 7), ["greenSmall", "greenMiddle", "greenBig", "harvestReady"])},
    "soybean": {"folder": "soybean", "file": "soybean.xml", "missions": True, "annual": ((2, 3), (6, 7), ["greenSmall", "greenMiddle", "greenMiddle2", "harvestReady"])},
    "potato": {"folder": "potato", "file": "potato.xml", "missions": True, "annual": ((1, 2), (6, 7), ["greenSmall", "greenSmall2", "greenMiddle", "greenBig", "harvestReady"])},
    "sugarbeet": {"folder": "sugarbeet", "file": "sugarbeet.xml", "missions": True, "annual": ((1, 2), (6, 8), ["greenSmall", "greenMiddle", "greenMiddle2", "greenBig2", "harvestReady"])},
    "sorghum": {"folder": "sorghum", "file": "sorghum.xml", "missions": False, "annual": ((2, 3), (6, 7), ["greenSmall", "greenMiddle", "greenBig", "harvestReady"])},
    "beetRoot": {"folder": "beetRoot", "file": "beetRoot.xml", "missions": False, "annual": ((2, 3), (6, 7), ["greenSmall", "greenMiddle", "greenBig", "harvestReady"])},
    "carrot": {"folder": "carrot", "file": "carrot.xml", "missions": False, "annual": ((2, 3), (6, 7), ["greenSmall", "greenMiddle", "greenBig", "harvestReady"])},
    "parsnip": {"folder": "parsnip", "file": "parsnip.xml", "missions": False, "annual": ((2, 3), (6, 7), ["greenSmall", "greenMiddle", "greenBig", "harvestReady"])},
    "greenBean": {"folder": "greenBean", "file": "greenBean.xml", "missions": False, "annual": ((2, 3), (5, 6), ["greenSmall", "greenBig", "harvestReady"])},
    "pea": {"folder": "pea", "file": "pea.xml", "missions": False, "annual": ((1, 2), (4, 5), ["greenSmall", "greenBig", "harvestReady"])},
    "spinach": {"folder": "spinach", "file": "spinach.xml", "missions": False, "planting_window": (1, 2)},
    "grass": {"folder": "grass", "file": "grass.xml", "missions": False, "planting_window": (1, 5)},
    "oilseedRadish": {"folder": "oilseedRadish", "file": "oilseedRadish.xml", "missions": False, "oilseed": True},
    "poplar": {"folder": "poplar", "file": "poplar.xml", "missions": False, "planting_window": (1, 3)},
    "cotton": {"folder": "cotton", "file": "cotton.xml", "missions": False, "disable_planting": True},
    "sugarcane": {"folder": "sugarcane", "file": "sugarcane.xml", "missions": False, "disable_planting": True},
    "rice": {"folder": "rice", "file": "rice.xml", "missions": False, "disable_planting": True},
    "riceLongGrain": {"folder": "riceLongGrain", "file": "riceLongGrain.xml", "missions": False, "disable_planting": True},
    "grape": {"folder": "grape", "file": "grape.xml", "missions": False},
    "olive": {"folder": "olive", "file": "olive.xml", "missions": False},
}


def add_update(period: ET.Element, start: str, end: str) -> None:
    ET.SubElement(period, "update", {"startState": start, "endState": end})


def set_annual(root: ET.Element, rule: tuple) -> None:
    plant, harvest, stages = rule
    plant_start, plant_end = plant
    harvest_start, harvest_end = harvest
    expected = harvest_start - plant_end + 1
    if len(stages) != expected:
        raise ValueError(f"Expected {expected} stages, got {len(stages)}")

    seasonal = root.find("./growth/seasonal")
    if seasonal is None:
        raise ValueError("Missing seasonal growth section")
    initial = seasonal.get("initialState")
    seasonal.clear()
    if initial:
        seasonal.set("initialState", initial)

    for index, name in enumerate(PERIODS):
        period = ET.SubElement(seasonal, "period", {"name": name})
        if plant_start <= index <= plant_end:
            period.set("plantingAllowed", "true")
            add_update(period, "invisible", stages[0])
        if plant_end + 1 <= index <= harvest_end:
            for start, end in zip(stages, stages[1:]):
                add_update(period, start, end)
        if index == (harvest_end + 1) % 12 and root.find("./foliageLayer/foliageState[@name='dead']") is not None:
            add_update(period, stages[-1], "dead")


def set_planting_window(root: ET.Element, window: tuple[int, int]) -> None:
    periods = root.findall("./growth/seasonal/period")
    for index, period in enumerate(periods):
        period.attrib.pop("plantingAllowed", None)
        if window[0] <= index <= window[1]:
            period.set("plantingAllowed", "true")


def disable_planting(root: ET.Element) -> None:
    for period in root.findall("./growth/seasonal/period"):
        period.attrib.pop("plantingAllowed", None)


def set_oilseed(root: ET.Element) -> None:
    seasonal = root.find("./growth/seasonal")
    if seasonal is None:
        raise ValueError("Missing oilseed-radish seasonal section")
    initial = seasonal.get("initialState")
    seasonal.clear()
    if initial:
        seasonal.set("initialState", initial)
    for index, name in enumerate(PERIODS):
        period = ET.SubElement(seasonal, "period", {"name": name})
        if 5 <= index <= 7:
            period.set("plantingAllowed", "true")
            add_update(period, "invisible", "greenSmall")


def save_tree(tree: ET.ElementTree, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    ET.indent(tree, space="    ")
    tree.write(path, encoding="utf-8", xml_declaration=True, short_empty_elements=True)


for crop_name, rule in CROPS.items():
    target = REPO_ROOT / "map" / "foliage" / rule["folder"] / rule["file"]
    source = GAME_DATA / "foliage" / rule["folder"] / rule["file"]

    # Preserve ThundRFS RCS definitions after the official prefab has been
    # installed. Rebuilding from $data would silently discard row spacing,
    # destruction states, and the map-local foliage asset paths.
    preserve_local_assets = False
    if target.exists():
        existing_root = ET.parse(target).getroot()
        if existing_root.find("thRowCropSystem") is not None:
            source = target
            preserve_local_assets = True

    tree = ET.parse(source)
    root = tree.getroot()
    fruit_type = root.find("fruitType")
    if fruit_type is None:
        raise ValueError(f"{crop_name}: missing fruitType")
    fruit_type.set("useForFieldMissions", str(rule["missions"]).lower())

    if not preserve_local_assets:
        for element in root.iter():
            for attribute, value in list(element.attrib.items()):
                if not value.startswith("$") and value.lower().endswith((".i3d", ".png", ".dds", ".ogg", ".wav")):
                    element.set(attribute, f"$data/foliage/{rule['folder']}/{value.replace(chr(92), '/')}")

    if "annual" in rule:
        set_annual(root, rule["annual"])
    elif "planting_window" in rule:
        set_planting_window(root, rule["planting_window"])
    elif "disable_planting" in rule:
        disable_planting(root)
    elif "oilseed" in rule:
        set_oilseed(root)

    save_tree(tree, target)

fruit_types_tree = ET.parse(GAME_DATA / "maps" / "maps_fruitTypes.xml")
for entry in fruit_types_tree.findall("./fruitTypes/fruitType"):
    source_filename = entry.get("filename")
    matching = next(
        (
            rule
            for rule in CROPS.values()
            if source_filename == f"$data/foliage/{rule['folder']}/{rule['file']}"
        ),
        None,
    )
    if matching is None:
        raise ValueError(f"No Manvel crop rule for {source_filename}")
    entry.set("filename", f"map/foliage/{matching['folder']}/{matching['file']}")
save_tree(fruit_types_tree, REPO_ROOT / "map" / "config" / "fruitTypes.xml")

field_states = [
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("WHEAT", "HARVESTREADY", "HARVEST_READY"),
    ("MAIZE", "HARVESTREADYGREEN", "SOWN"),
    ("CANOLA", "HARVESTREADY", "HARVEST_READY"),
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("WHEAT", "HARVESTREADY", "HARVEST_READY"),
    ("SUGARBEET", "GREENBIG2", "SOWN"),
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("MAIZE", "HARVESTREADYGREEN", "SOWN"),
    ("WHEAT", "HARVESTREADY", "HARVEST_READY"),
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("CANOLA", "HARVESTREADY", "HARVEST_READY"),
    ("SUNFLOWER", "GREENBIG", "SOWN"),
    ("BARLEY", "HARVESTREADY", "HARVEST_READY"),
    ("POTATO", "GREENBIG", "SOWN"),
    ("MAIZE", "HARVESTREADYGREEN", "SOWN"),
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("WHEAT", "HARVESTREADY", "HARVEST_READY"),
    ("SUGARBEET", "GREENBIG2", "SOWN"),
    ("CANOLA", "HARVESTREADY", "HARVEST_READY"),
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("WHEAT", "HARVESTREADY", "HARVEST_READY"),
    ("MAIZE", "HARVESTREADYGREEN", "SOWN"),
    ("OAT", "HARVESTREADY", "HARVEST_READY"),
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("SUNFLOWER", "GREENBIG", "SOWN"),
    ("WHEAT", "HARVESTREADY", "HARVEST_READY"),
    ("SUGARBEET", "GREENBIG2", "SOWN"),
    ("CANOLA", "HARVESTREADY", "HARVEST_READY"),
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("MAIZE", "HARVESTREADYGREEN", "SOWN"),
    ("WHEAT", "HARVESTREADY", "HARVEST_READY"),
    ("SORGHUM", "GREENBIG", "SOWN"),
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("BARLEY", "HARVESTREADY", "HARVEST_READY"),
    ("MAIZE", "HARVESTREADYGREEN", "SOWN"),
    ("OAT", "HARVESTREADY", "HARVEST_READY"),
    ("WHEAT", "HARVESTREADY", "HARVEST_READY"),
    ("SOYBEAN", "GREENMIDDLE2", "SOWN"),
    ("SUGARBEET", "GREENBIG2", "SOWN"),
    ("POTATO", "GREENBIG", "SOWN"),
]
if len(field_states) != 41:
    raise ValueError(f"Expected 41 field states, got {len(field_states)}")

fields_path = REPO_ROOT / "map" / "config" / "fields.xml"
fields_tree = ET.parse(fields_path)
field_nodes = fields_tree.findall("./fields/field")
for field, (fruit, state, ground) in zip(field_nodes[:41], field_states):
    field.find("fruit").set("type", fruit)
    field.find("fruit").set("growthState", state)
    field.find("ground").set("type", ground)
save_tree(fields_tree, fields_path)

print(f"Generated {len(CROPS)} regional vanilla crop definitions.")
print("Updated 41 loaded field states; PDA Field 38 is wheat and PDA Field 39 is soybeans.")

