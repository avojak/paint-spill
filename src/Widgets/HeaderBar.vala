/*
 * Copyright (c) 2022 Andrew Vojak (avojak)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Authored by: Andrew Vojak <andrew.vojak@gmail.com>
 */

public class Flood.Widgets.HeaderBar : Hdy.HeaderBar {

    public HeaderBar () {
        Object (
            title: Constants.APP_NAME,
            show_close_button: true,
            has_subtitle: false,
            decoration_layout: "close:" // Disable the maximize/restore button
        );
    }

    construct {
        get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        var settings_button = new Gtk.MenuButton () {
            image = new Gtk.Image.from_icon_name ("preferences-system-symbolic", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = _("Menu"),
            relief = Gtk.ReliefStyle.NONE,
            valign = Gtk.Align.CENTER
        };

        var preferences_accellabel = new Granite.AccelLabel.from_action_name (
            _("Preferences…"),
            Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_PREFERENCES
        );

        var preferences_menu_item = new Gtk.ModelButton () {
            action_name = Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_PREFERENCES
        };
        preferences_menu_item.get_child ().destroy ();
        preferences_menu_item.add (preferences_accellabel);

        var quit_accellabel = new Granite.AccelLabel.from_action_name (
            _("Quit"),
            Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_QUIT
        );

        var quit_menu_item = new Gtk.ModelButton () {
            action_name = Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_QUIT
        };
        quit_menu_item.get_child ().destroy ();
        quit_menu_item.add (quit_accellabel);

        var settings_popover_grid = new Gtk.Grid () {
            margin_top = 3,
            margin_bottom = 3,
            orientation = Gtk.Orientation.VERTICAL,
            width_request = 200
        };
        settings_popover_grid.attach (preferences_menu_item, 0, 0, 1, 1);
        settings_popover_grid.attach (create_menu_separator (), 0, 1, 1, 1);
        settings_popover_grid.attach (quit_menu_item, 0, 2, 1, 1);
        settings_popover_grid.show_all ();

        var settings_popover = new Gtk.Popover (null);
        settings_popover.add (settings_popover_grid);

        settings_button.popover = settings_popover;

        pack_end (settings_button);
    }

    private Gtk.Separator create_menu_separator () {
        return new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
            margin_top = 0
        };
    }

}
