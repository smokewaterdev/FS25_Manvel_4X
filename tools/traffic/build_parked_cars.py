#!/usr/bin/env python3
"""
Generate an importable `parkedCars` group for the Farmers Market lot.

FS25's traffic system spawns a static parked vehicle at every
`<TransformGroup name="parkedCar">` under a `parkedCars` group inside the
registered `trafficSystem` group. Which vehicles are eligible comes from
`probabilityParked` in map/config/trafficSystem.xml -- currently 1 on the four
passenger models (vehicle01/03/11/19) and 0 on every truck and bus, so this lot
fills with cars only. That's the right look for a farmers market; flip a truck's
probabilityParked to 1 if you want one sitting there.

Lot corners were read off the in-game position display, which runs 0..4096 on
this map while the i3d world runs -2048..+2048 -- hence the -2048 conversion
below. Same offset we used to decode junction coordinates from screenshots.

Cars are laid out as a single row along the lot's front edge, nose-in (facing
across the lot's depth, away from the market side you drive in from), spaced
evenly and inset from both ends so no car overhangs the lot. Y is sampled from
the real terrain heightmap per car rather than assumed flat.

IMPORTANT: after importing, drag the `parkedCars` group onto the REGISTERED
trafficSystem node in the Scenegraph. This map also has an inert leftover
trafficSystem stub (it carries no onCreate UserAttribute and holds no curves);
parked cars placed under that one never spawn.

Usage:
  python3 build_parked_cars.py [mod_root] [out_i3d]
"""
import sys, os
import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
HEIGHT_SCALE = 255.0
INGAME_OFFSET = 2048.0  # in-game display is 0..4096; world is -2048..+2048

# Lot corners as read in-game (X, Z), before the offset conversion.
FRONT_LEFT = (737.0, 2408.0)
FRONT_RIGHT = (710.0, 2408.0)
BACK_RIGHT = (710.0, 2415.0)

NUM_CARS = 7
SPACING_M = 3.5     # centre-to-centre across the row
CAR_YAW_DEG = 0.0   # a row along X parks cars facing +/-Z; add 180 to flip
                    # them nose-out (matches how the base game's own mapUS
                    # parkedCar rows sit at yaw ~0)

# Sized for the LONGEST vehicle that can park here, not for a car. FS assigns
# vehicles to parkedCar nodes at random, so any slot can receive the ~8m
# tipperTruck once its probabilityParked is non-zero -- a 5.5m car stall at
# 3m spacing would have left a grain truck clipping the cars either side.
# 8m depth and 3.5m spacing means whatever lands in whatever slot fits.
#
# The row is positioned so a full-length vehicle ends flush at the BACK edge
# and overhangs the FRONT instead: the surveyed lot is only 7m deep, so a
# truck has to stick out somewhere, and the front is the open gravel apron
# you turn in from. Overhanging the back would push it into the treeline.
# Cars, being shorter, simply sit with a little space behind them.
STALL_DEPTH_M = 8.0


def to_world(p):
    return (p[0] - INGAME_OFFSET, p[1] - INGAME_OFFSET)


def load_dem_sampler(mod_root):
    dem = np.array(Image.open(os.path.join(mod_root, "map", "data", "dem.png"))).astype(np.float64)
    h, w = dem.shape

    def sample(x, z):
        px = min(max(x + 2048.0, 0.0), w - 1.0001)
        pz = min(max(z + 2048.0, 0.0), h - 1.0001)
        x0, z0 = int(px), int(pz)
        fx, fz = px - x0, pz - z0
        v = (dem[z0, x0] * (1 - fx) * (1 - fz) + dem[z0, x0 + 1] * fx * (1 - fz)
             + dem[z0 + 1, x0] * (1 - fx) * fz + dem[z0 + 1, x0 + 1] * fx * fz)
        return v / 65535.0 * HEIGHT_SCALE

    return sample


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "..")
    out_path = sys.argv[2] if len(sys.argv) > 2 else os.path.join(HERE, "parked_cars.i3d")
    sample_height = load_dem_sampler(mod_root)

    fl, fr, br = to_world(FRONT_LEFT), to_world(FRONT_RIGHT), to_world(BACK_RIGHT)
    width = abs(fl[0] - fr[0])
    depth = abs(br[1] - fr[1])
    print(f"lot: front-left {fl}, front-right {fr}, back-right {br}")
    print(f"     {width:.1f}m wide x {depth:.1f}m deep")

    # centre a fixed-spacing row on the lot's width
    lo, hi = sorted((fl[0], fr[0]))
    x_mid = (lo + hi) / 2.0
    span = (NUM_CARS - 1) * SPACING_M
    x0, x1 = x_mid - span / 2.0, x_mid + span / 2.0
    margin = (width - span) / 2.0
    if margin < 1.0:
        print(f"  WARNING: only {margin:.1f}m margin at each end of the row")
    # a full-length vehicle ends flush at the back edge, overhang goes forward
    z_front, z_back = fr[1], br[1]
    into_lot = 1.0 if z_back > z_front else -1.0
    z_center = z_back - into_lot * (STALL_DEPTH_M / 2.0)
    print(f"     row span {span:.1f}m at {SPACING_M}m spacing, {margin:.1f}m margin each end")
    print(f"     stall depth {STALL_DEPTH_M}m from back edge z={z_back:.1f}; "
          f"a full-length vehicle overhangs the front by {STALL_DEPTH_M - depth:.1f}m")

    nodes = []
    node_id = 2
    for i in range(NUM_CARS):
        t = i / (NUM_CARS - 1) if NUM_CARS > 1 else 0.5
        x = x0 + (x1 - x0) * t
        y = sample_height(x, z_center)
        nodes.append(
            f'            <TransformGroup name="parkedCar" '
            f'translation="{x:.3f} {y:.3f} {z_center:.3f}" '
            f'rotation="0 {CAR_YAW_DEG:g} 0" nodeId="{node_id}"/>'
        )
        node_id += 1
        print(f"  car {i + 1}: ({x:.2f}, {y:.2f}, {z_center:.2f})")

    spacing = SPACING_M
    print(f"\n{NUM_CARS} cars, {spacing:.2f}m apart, centred at z={z_center:.2f}")

    i3d = f'''<?xml version="1.0" encoding="iso-8859-1"?>
<i3D name="manvel_parked_cars" version="1.6" xsi:noNamespaceSchemaLocation="http://i3d.giants.ch/schema/i3d-1.6.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <Files/>
    <Materials/>
    <Shapes/>
    <Scene>
        <TransformGroup name="parkedCars" nodeId="1">
{chr(10).join(nodes)}
        </TransformGroup>
    </Scene>
</i3D>
'''
    with open(out_path, "w", encoding="iso-8859-1") as f:
        f.write(i3d)
    print(f"wrote {out_path}")


if __name__ == "__main__":
    main()
