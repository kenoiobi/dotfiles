# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook
from qtile_bonsai import Bonsai
import subprocess
import time

mod = "mod1"
terminal = "urxvt"


@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "apostrophe", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "Escape", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "d", lazy.spawn("rofi -show run"), desc="Spawn a command using a prompt widget"),
    Key([mod], "a", lazy.spawn("rofi -show window"), desc="Spawn a command using a prompt widget"),
    Key([mod, "shift"], "d", minimize_all(), desc="Spawn a command using a prompt widget"),

    Key([mod], "q", lazy.group['0'].dropdown_toggle('term')),
    Key([mod], "w", lazy.group['0'].dropdown_toggle('whatsapp')),
    Key([mod, "shift"], "w", lazy.group['0'].dropdown_toggle('discord')),
    Key([mod], "e", lazy.group['0'].dropdown_toggle('legitimuz')),
    Key([mod], "s", lazy.group['0'].dropdown_toggle('slack')),

    Key([mod], "m", lazy.hide_show_bar(), desc="toggle bar"),
    Key([mod], "Tab", lazy.group.focus_back(), desc="Alternate between two most recent windows"),

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer sset Master 1+ toggle"), desc="Mute/Unmute Volume"),
    Key([], "Print", lazy.spawn("flameshot full -c")),
    Key(["shift"], "Print", lazy.spawn("flameshot gui -c")),
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


groups = [
    Group(
        "1",
        layout="max"
    ),
    Group(
        "2",
        matches=Match(wm_class=["Emacs"]),
    ),
    Group(
        "3",
        layout="max",
        matches=Match(wm_class=["zen"]),
    ),
    Group(
        "4",
        layout="max",
        matches=Match(wm_class=["virt-manager", "com-azefsw-audioconnect-desktop-app-MainKt", "Thunar", "btop"]),
    ),
    Group(
        "5",
    ),
    Group("6"),
    Group("7"),
    Group("8"),
    Group("9"),
    ScratchPad("0", [
        DropDown(
            "term",
            "urxvt -e tmux",
            y=0.07, x=0.05, width=0.9, height=0.9
        ),
        DropDown(
            "whatsapp",
            "firefox --no-remote -P aaaa https://web.whatsapp.com",
            y=0.07, x=0.05, width=0.9, height=0.9
        ),
        DropDown(
            "legitimuz",
            "firefox --no-remote -P legitimuz https://web.whatsapp.com",
            y=0.07, x=0.05, width=0.9, height=0.9
        ),
        DropDown(
            "discord",
            "discord",
            y=0.07, x=0.05, width=0.9, height=0.9,
            match=Match(wm_class=['discord'])
        ),
        DropDown(
            "slack",
            "slack",
            y=0.07, x=0.05, width=0.9, height=0.9,
            match=Match(wm_class=['Slack'])
        ),
        ]
    )
]

for i in range(9):
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                groups[i].name,
                lazy.group[groups[i].name].toscreen(),
                desc=f"Switch to groups {groups[i].name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                groups[i].name,
                lazy.window.togroup(groups[i].name, switch_group=True),
                desc=f"Switch to & move focused window to groups {groups[i].name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )



layouts = [
    layout.MonadTall(),
    layout.MonadWide(),
    layout.Max(),
    layout.Floating(margin=0),
    # Plasma(
    #     border_normal='#333333',
    #     border_focus='#00e891',
    #     border_normal_fixed='#006863',
    #     border_focus_fixed='#00e8dc',
    #     border_width=1,
    #     border_width_single=0,
    #     margin=0
    # ),
]

widget_defaults = dict(
    font="sans",
    fontsize=16,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.TaskList(
                    max_title_length=15
                ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),
                widget.Clock(format="%H:%M %p %a %d/%m/%Y"),
            ],
            35,
            background="#292a2e"
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
        )
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

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

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
subprocess.run("~/.config/qtile/autostart.sh", shell=True)
qtile.cmd_spawn("firefox")
qtile.cmd_spawn("redshift")
qtile.cmd_spawn("emacs")
qtile.cmd_spawn("flatpak run app.zen_browser.zen")
qtile.cmd_spawn("virt-manager")
qtile.cmd_spawn("audiorelay")
qtile.cmd_spawn("thunar")
qtile.cmd_spawn("urxvt -name btop -e btop")
