/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.HeaderBar : Hdy.HeaderBar {

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
            widget.set_tooltip_markup (((PaintSpill.Models.Difficulty) index).get_details_markup ());
        });
        difficulty_button.append_text (PaintSpill.Models.Difficulty.EASY.get_display_string ());
        difficulty_button.append_text (PaintSpill.Models.Difficulty.NORMAL.get_display_string ());
        difficulty_button.append_text (PaintSpill.Models.Difficulty.HARD.get_display_string ());
        PaintSpill.Application.settings.bind ("difficulty", difficulty_button, "selected", GLib.SettingsBindFlags.DEFAULT);

        var zen_mode_button = new Granite.SwitchModelButton (_("Zen Mode")) {
            description = _("Unlimited moves, continuous games, no wins or losses"),
            tooltip_text = _("Unlimited moves, continuous games, no wins or losses")
        };
        PaintSpill.Application.settings.bind ("zen-mode", zen_mode_button, "active", GLib.SettingsBindFlags.DEFAULT);

        var new_game_accellabel = new Granite.AccelLabel.from_action_name (
            _("New Game"),
            PaintSpill.Services.ActionManager.ACTION_PREFIX + PaintSpill.Services.ActionManager.ACTION_NEW_GAME
        );

        var new_game_menu_item = new Gtk.ModelButton ();
        new_game_menu_item.action_name = PaintSpill.Services.ActionManager.ACTION_PREFIX + PaintSpill.Services.ActionManager.ACTION_NEW_GAME;
        new_game_menu_item.get_child ().destroy ();
        new_game_menu_item.add (new_game_accellabel);

        var gameplay_stats_menu_item = new Gtk.ModelButton ();
        gameplay_stats_menu_item.text = _("Gameplay Statistics…");

        var help_accellabel = new Granite.AccelLabel.from_action_name (
            _("Help"),
            PaintSpill.Services.ActionManager.ACTION_PREFIX + PaintSpill.Services.ActionManager.ACTION_HELP
        );

        var help_menu_item = new Gtk.ModelButton ();
        help_menu_item.action_name = PaintSpill.Services.ActionManager.ACTION_PREFIX + PaintSpill.Services.ActionManager.ACTION_HELP;
        help_menu_item.get_child ().destroy ();
        help_menu_item.add (help_accellabel);

        var quit_accellabel = new Granite.AccelLabel.from_action_name (
            _("Quit"),
            PaintSpill.Services.ActionManager.ACTION_PREFIX + PaintSpill.Services.ActionManager.ACTION_QUIT
        );

        var quit_menu_item = new Gtk.ModelButton ();
        quit_menu_item.action_name = PaintSpill.Services.ActionManager.ACTION_PREFIX + PaintSpill.Services.ActionManager.ACTION_QUIT;
        quit_menu_item.get_child ().destroy ();
        quit_menu_item.add (quit_accellabel);

        var menu_popover_grid = new Gtk.Grid () {
            margin_top = 3,
            margin_bottom = 3,
            orientation = Gtk.Orientation.VERTICAL,
            width_request = 200
        };
        menu_popover_grid.attach (difficulty_button, 0, 0, 3, 1);
        menu_popover_grid.attach (zen_mode_button, 0, 1, 3, 1);
        menu_popover_grid.attach (new_game_menu_item, 0, 2, 1, 1);
        menu_popover_grid.attach (create_menu_separator (), 0, 3, 1, 1);
        menu_popover_grid.attach (gameplay_stats_menu_item, 0, 4, 1, 1);
        menu_popover_grid.attach (help_menu_item, 0, 5, 1, 1);
        menu_popover_grid.attach (create_menu_separator (), 0, 6, 1, 1);
        menu_popover_grid.attach (quit_menu_item, 0, 7, 1, 1);
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
