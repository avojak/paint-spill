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

        var menu_button = new Gtk.MenuButton () {
            image = new Gtk.Image.from_icon_name ("preferences-system-symbolic", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = _("Menu"),
            relief = Gtk.ReliefStyle.NONE,
            valign = Gtk.Align.CENTER
        };

        var difficulty_button = new Granite.Widgets.ModeButton () {
            margin = 12
        };
        difficulty_button.mode_added.connect ((index, widget) => {
            widget.set_tooltip_markup (((Flood.Models.Difficulty) index).get_details_markup ());
        });
        difficulty_button.append_text (Flood.Models.Difficulty.EASY.get_display_string ());
        difficulty_button.append_text (Flood.Models.Difficulty.NORMAL.get_display_string ());
        difficulty_button.append_text (Flood.Models.Difficulty.HARD.get_display_string ());
        Flood.Application.settings.bind ("difficulty", difficulty_button, "selected", GLib.SettingsBindFlags.DEFAULT);

        var new_game_accellabel = new Granite.AccelLabel.from_action_name (
            _("New Game"),
            Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_NEW_GAME
        );

        var new_game_menu_item = new Gtk.ModelButton ();
        new_game_menu_item.action_name = Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_NEW_GAME;
        new_game_menu_item.get_child ().destroy ();
        new_game_menu_item.add (new_game_accellabel);

        var gameplay_stats_menu_item = new Gtk.ModelButton ();
        gameplay_stats_menu_item.text = "Gameplay Statistics…";

        var help_accellabel = new Granite.AccelLabel.from_action_name (
            _("Help"),
            Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_HELP
        );

        var help_menu_item = new Gtk.ModelButton ();
        help_menu_item.action_name = Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_HELP;
        help_menu_item.get_child ().destroy ();
        help_menu_item.add (help_accellabel);

        var quit_accellabel = new Granite.AccelLabel.from_action_name (
            _("Quit"),
            Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_QUIT
        );

        var quit_menu_item = new Gtk.ModelButton ();
        quit_menu_item.action_name = Flood.Services.ActionManager.ACTION_PREFIX + Flood.Services.ActionManager.ACTION_QUIT;
        quit_menu_item.get_child ().destroy ();
        quit_menu_item.add (quit_accellabel);

        var menu_popover_grid = new Gtk.Grid () {
            margin_top = 3,
            margin_bottom = 3,
            orientation = Gtk.Orientation.VERTICAL,
            width_request = 200
        };
        menu_popover_grid.attach (difficulty_button, 0, 0, 3, 1);
        menu_popover_grid.attach (new_game_menu_item, 0, 1, 1, 1);
        menu_popover_grid.attach (create_menu_separator (), 0, 2, 1, 1);
        menu_popover_grid.attach (gameplay_stats_menu_item, 0, 3, 1, 1);
        menu_popover_grid.attach (help_menu_item, 0, 4, 1, 1);
        menu_popover_grid.attach (create_menu_separator (), 0, 5, 1, 1);
        menu_popover_grid.attach (quit_menu_item, 0, 6, 1, 1);
        menu_popover_grid.show_all ();

        var menu_popover = new Gtk.Popover (null);
        menu_popover.add (menu_popover_grid);

        menu_button.popover = menu_popover;

        pack_end (menu_button);

        gameplay_stats_menu_item.clicked.connect (() => {
            gameplay_statistics_menu_item_clicked ();
        });
    }

    private Gtk.Separator create_menu_separator () {
        return new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
            margin_top = 0
        };
    }

    public signal void gameplay_statistics_menu_item_clicked ();

}
