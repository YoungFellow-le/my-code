#!/bin/python3

from Xlib import display
from Xlib.ext import randr
from sys import argv as a

# Make sure that params are correct
if not (len(a) == 2 and (a[1].lower() == "primary" or a[1].lower() == "secondary")):
    print("ERROR: Invalid usage")
    print(f"Correct usage: {a[0]} primary|secondary")
    exit()

# Get all the modes
def find_mode(id, modes):
    for mode in modes:
        if id == mode.id:
            return "{}x{}".format(mode.width, mode.height)

# Get info on all the screens
def get_display_info():
    d = display.Display(':0')
    screen_count = d.screen_count()
    default_screen = d.get_default_screen()
    result = []
    screen = 0
    info = d.screen(screen)
    window = info.root

    res = randr.get_screen_resources(window)
    for output in res.outputs:
        params = d.xrandr_get_output_info(output, res.config_timestamp)
        if not params.crtc:
            continue
        crtc = d.xrandr_get_crtc_info(params.crtc, res.config_timestamp)
        modes = set()
        for mode in params.modes:
            modes.add(find_mode(mode, res.modes))
        result.append({
            'name': params.name,
            'resolution': "{}x{}".format(crtc.width, crtc.height),
            'available_resolutions': list(modes)
        })

    return result


monitor = 0 if a[1].lower() == "primary" else 1
modes = get_display_info()[monitor].get('available_resolutions')
_set = False

if monitor == 0:
    res_to_set = "1600x900"
elif monitor == 1:
    res_to_set = "1920x1080"
    
if res_to_set in modes:
    _set = True

print(_set)