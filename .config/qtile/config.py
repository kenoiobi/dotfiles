from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook
from libqtile.log_utils import logger
import subprocess
import time

mod = "mod4" # only sane mod key :pray:
terminal = "st" # only sane terminal

# workspace groups global variables, it would be done like this in C, but its not as correct in py, not sure how to go from here
curr_group = 0
workspace_groups = [0, 0, 0, 0, 0]

# TODO: move these to another file
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()

@lazy.screen.function
def my_workspace(screen, index):
    global curr_group
    global workspace_groups
    
    workspace_groups[curr_group] = index # 1
    
    logger.warning(curr_group)
    
    final = index # 1
    for i in range(curr_group): 
        final = final + 5 # 1

    final = str(final + 1)
    if final == screen.group.name:
        return

    screen.toggle_group(final)


@lazy.screen.function
def my_group(screen, index):
    global curr_group
    global workspace_groups

    curr_group = index # 1

    final = workspace_groups[curr_group] # 0

    for i in range(curr_group):
        final = final + 5

    final = str(final + 1)
    screen.toggle_group(final)

@lazy.screen.function
def my_workspace_move(screen, index):
    global curr_group
    global workspace_groups

    final = index
    for i in range(curr_group):
        final = final + 5

    final = str(final + 1)
    screen.group.current_window.togroup(final)


@lazy.screen.function
def my_group_move(screen, index):
    global curr_group
    global workspace_groups

    final = workspace_groups[index]
    for i in range(index):
        final = final + 5
    
    final = str(final + 1)
    
    screen.group.current_window.togroup(final)


keys = [
    # starting and killing
    Key([mod], "Return", lazy.spawn("st"), desc="Launch terminal"),
    Key([mod], "Escape", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Spawn a command using a prompt widget"),
    Key([mod], "a", lazy.spawn("rofi -show window"), desc="Spawn a command using a prompt widget"),

    # qtile management
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Shutdown Qtile"),

    # layout management
    Key([mod, "control"], "Return", lazy.layout.swap_main(), desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "apostrophe", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window",),
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "shift"], "d", minimize_all(), desc="Spawn a command using a prompt widget"),
    Key([mod], "m", lazy.hide_show_bar(), desc="toggle bar"),
    Key([mod], "Tab", lazy.screen.toggle_group(), desc="Alternate between two most recent windows"),

    # media
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer sset Master 1+ toggle"), desc="Mute/Unmute Volume"),
    Key([], "Print", lazy.spawn("flameshot full")),
    Key(["shift"], "Print", lazy.spawn("flameshot gui")),

    # scratchpads
    Key(['mod1'], "q", lazy.group['0'].dropdown_toggle('term')),
    Key(['mod1'], "w", lazy.group['0'].dropdown_toggle('whatsapp')),
    Key(['mod1', "shift"], "w", lazy.group['0'].dropdown_toggle('discord')),
    Key(['mod1'], "e", lazy.group['0'].dropdown_toggle('dolphin')),
    Key(['mod1'], "s", lazy.group['0'].dropdown_toggle('slack')),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


# five groups per workspace group
groups = [
    Group(
        "1",
        layout="max"
    ),
    Group(
        "2",
        matches=Match(wm_class=["Emacs"]),
        layout="max",
    ),
    Group(
        "3",
        layout="max",
    ),
    Group(
        "4",
        layout="max",
    ),
    Group(
        "5",
    ),
    Group("6"),
    Group("7"),
    Group("8"),
    Group("9"),
    Group("10"),
    Group("11", screen_affinity=1),
    # five scratchpads, like any sane person (/s)
    ScratchPad("0", [
        DropDown(
            "term",
            "st -e tmux",
            y=0.07, x=0.05, width=0.9, height=0.9,
            opacity=1
        ),
        DropDown(
            "whatsapp",
            'chromium --user-data-dir=/home/kayon/chrome/whats --app=https://web.whatsapp.com --class="whatsapp"',
            y=0.07, x=0.05, width=0.9, height=0.9,
            opacity=1
        ),
        DropDown(
            "dolphin",
            "dolphin",
            y=0.07, x=0.05, width=0.9, height=0.9,
            opacity=1
        ),
        DropDown(
            "discord",
            "discord",
            y=0.07, x=0.05, width=0.9, height=0.9,
            match=Match(wm_class=['discord']),
            opacity=1
        ),
        DropDown(
            "slack",
            "slack",
            y=0.07, x=0.05, width=0.9, height=0.9,
            match=Match(wm_class=['Slack']),
            opacity=1
        ),
        ]
    )
]

# main workspace switch keys
keys.extend([
    Key([mod], "q", my_workspace(0)),
    Key([mod], "w", my_workspace(1)),
    Key([mod], "e", my_workspace(2)),
    Key([mod], "r", my_workspace(3)),
    Key([mod], "t", my_workspace(4)),
])

# move to workspace
keys.extend([
    Key([mod, "control"], "q", my_workspace_move(0)),
    Key([mod, "control"], "w", my_workspace_move(1)),
    Key([mod, "control"], "e", my_workspace_move(2)),
    Key([mod, "control"], "r", my_workspace_move(3)),
    Key([mod, "control"], "t", my_workspace_move(4)),
])

# change workspace group
keys.extend([
    Key([mod], "1", my_group(0)),
    Key([mod], "2", my_group(1)),
])

# move to workspace last selected on workspace group
keys.extend([
    Key([mod, "control"], "1", my_group_move(0)),
    Key([mod, "control"], "2", my_group_move(1)),
])


# i only like 3 layouts
layouts = [
    layout.MonadTall(
        margin=25
    ),
    # layout.MonadWide(),
    layout.Max(),
    layout.Floating(
        margin=2,
        border_width=8,
        border_focus="#000000",
        border_normal="#000000",
    ),
]

widget_defaults = dict(
    font="sans",
    fontsize=16,
    padding=3,
)
extension_defaults = widget_defaults.copy()

# bar config only on main monitor
screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.Sep(
                    background="141820",
                    foreground="141820"
                ),
                widget.GroupBox(
                    highlight_method="block",
                    fontsize=16,
                    padding_x=5,
                    padding_y=7,
                ),

                widget.Spacer(),
                widget.Prompt(),
                widget.TaskList(
                    borderwidth=0,
                    fontsize=16,
                    icon_size=30,
                    padding_y=5,
                    padding_x=10,
                ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Spacer(),
                widget.Sep(padding=10),
                widget.Clock(format="%H:%M"),
                widget.Sep(padding=10),
                widget.Clock(format="%p %a %d/%m/%Y"),
                widget.Sep(padding=10),
                widget.Systray(),
                widget.Sep(
                    background="141820",
                    foreground="141820",
                    padding=10,
                ),
            ],
            35,
            background="141820",
        ),
    ),
    Screen()
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# from here on, qtile default config, haven't changed anything
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

wmname = "LG3D"
