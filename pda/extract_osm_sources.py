#!/usr/bin/env python3
"""
Parse manvel.osm (real-world OSM data for this map's location) and project
every relevant feature (roads, forest, tree rows, water, waterways) into the
map's local meter coordinates, caching the result as sources/osm_features.json.

Run this ONCE, or again only if manvel.osm changes (e.g. you re-trace or add
features in JOSM). compose_pda.py reads the cached JSON and never re-parses
the raw .osm file, which is what keeps regeneration fast.

Calibration: manvel.osm's <bounds> covers the full 8192m MapToPlay DTM export
box (not just the 4096m playable square). Scale is derived directly from that
bounds span; origin is the map center from maptoplay.json; the latitude sign
was determined empirically by overlaying projected OSM landuse=farmland
polygons against this project's own known field geometry
(map/_tmp_fields_geometry.json) -- sign=-1 gave a near-perfect match (see
sources/calibration_check.png). Recorded in sources/calibration.json.

Usage:
  python3 extract_osm_sources.py
"""

import xml.etree.ElementTree as ET
import json

import os
HERE = os.path.dirname(os.path.abspath(__file__))
OSM_PATH = os.path.join(HERE, '..', 'manvel.osm')
tree = ET.parse(OSM_PATH)
root = tree.getroot()
b = root.find('bounds').attrib
minlat,minlon,maxlat,maxlon = float(b['minlat']),float(b['minlon']),float(b['maxlat']),float(b['maxlon'])

nodes = {nd.get('id'): (float(nd.get('lat')), float(nd.get('lon'))) for nd in root.findall('node')}
ways = []
for w in root.findall('way'):
    refs = [nd.get('ref') for nd in w.findall('nd')]
    tags = {t.get('k'): t.get('v') for t in w.findall('tag')}
    coords = [nodes[r] for r in refs if r in nodes]
    ways.append({'tags':tags, 'coords':coords})

deg_per_m_lon = (maxlon-minlon)/8192.0
deg_per_m_lat = (maxlat-minlat)/8192.0
LAT0, LON0 = 48.09429, -97.11109399999998
SIGN = -1  # validated against known field geometry: near-perfect match

calibration = {
    "lat0": LAT0, "lon0": LON0,
    "deg_per_m_lon": deg_per_m_lon, "deg_per_m_lat": deg_per_m_lat,
    "lat_sign": SIGN,
    "source_bounds": {"minlat":minlat,"minlon":minlon,"maxlat":maxlat,"maxlon":maxlon},
    "formula": "x = (lon-lon0)/deg_per_m_lon ; z = lat_sign*(lat-lat0)/deg_per_m_lat",
    "validated_against": "map/_tmp_fields_geometry.json landuse=farmland ways — near-perfect overlay, see /pda/sources/calibration_check.png",
    "notes": "manvel.osm bounds span the full 8192m MapToPlay DTM export box (not just the 4096m playable area); world coords use the playable area's -2048..2048 convention (pixel = world+2048 on the 4096x4096 map rasters)."
}

def proj(lat,lon):
    x = (lon-LON0)/deg_per_m_lon
    z = SIGN*(lat-LAT0)/deg_per_m_lat
    return round(x,2), round(z,2)

def classify(tags):
    if 'highway' in tags:
        return ('road', tags['highway'])
    if tags.get('landuse') == 'forest':
        return ('forest', None)
    if tags.get('natural') == 'tree_row':
        return ('tree_row', None)
    if tags.get('natural') == 'water':
        return ('water', None)
    if 'waterway' in tags:
        return ('waterway', tags['waterway'])
    if tags.get('landuse') == 'farmland':
        return ('farmland_ref', None)  # kept only for reference/validation, not used in render
    if tags.get('landuse') == 'farmyard':
        return ('farmyard_ref', None)
    if 'power' in tags:
        return ('power', None)
    if 'building' in tags:
        return ('building', None)
    return (None, None)

MARGIN = 300  # keep features that dip slightly outside -2048..2048 too, so lines don't get cut short at the edge
features = {'road':[], 'forest':[], 'tree_row':[], 'water':[], 'waterway':[], 'farmland_ref':[], 'farmyard_ref':[], 'power':[], 'building':[]}
for w in ways:
    kind, sub = classify(w['tags'])
    if kind is None or kind not in features:
        continue
    if not w['coords']:
        continue
    pts = [proj(lat,lon) for lat,lon in w['coords']]
    xs = [p[0] for p in pts]; zs=[p[1] for p in pts]
    if max(xs) < -2048-MARGIN or min(xs) > 2048+MARGIN or max(zs) < -2048-MARGIN or min(zs) > 2048+MARGIN:
        continue
    features[kind].append({'sub': sub, 'pts': pts})

for k,v in features.items():
    print(k, len(v))

os.makedirs(os.path.join(HERE, 'sources'), exist_ok=True)
with open(os.path.join(HERE, 'sources', 'calibration.json'),'w') as f:
    json.dump(calibration, f, indent=2)
with open(os.path.join(HERE, 'sources', 'osm_features.json'),'w') as f:
    json.dump(features, f)
print("saved sources")
