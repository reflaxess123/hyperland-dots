import math
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)

timer_id = None

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    bg_tab = as_rgb(int(draw_data.default_bg))
    active_bg = as_rgb(0x45475a)
    active_fg = as_rgb(0xcdd6f4)
    inactive_bg = as_rgb(0x313244)
    inactive_fg = as_rgb(0x6c7086)

    if tab.is_active:
        tab_bg = active_bg
        tab_fg = active_fg
    else:
        tab_bg = inactive_bg
        tab_fg = inactive_fg

    left_sep = " "
    right_sep = " "

    # Draw left separator (background -> tab color)
    screen.cursor.fg = tab_bg
    screen.cursor.bg = bg_tab
    screen.draw(left_sep)

    # Draw tab content
    screen.cursor.fg = tab_fg
    screen.cursor.bg = tab_bg

    title = f" {index}: {tab.title} "
    if len(title) > max_tab_length - 4:
        title = title[: max_tab_length - 7] + "… "

    screen.draw(title)

    # Draw right separator (tab color -> background)
    screen.cursor.fg = tab_bg
    screen.cursor.bg = bg_tab
    screen.draw(right_sep)

    return screen.cursor.x
