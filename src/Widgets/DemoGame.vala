/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.DemoGame : Gtk.Grid {

    private static Gtk.CssProvider provider;

    public DemoGame () {
        Object (
            expand: true,
            halign: Gtk.Align.CENTER
        );
    }

    static construct {
        provider = new Gtk.CssProvider ();
        provider.load_from_resource ("com/github/avojak/paint-spill/ArrowIcon.css");
    }

    construct {
        var endgame_grid = new Gtk.Grid () {
            expand = true,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER,
            row_spacing = 8
        };
        var reset_button = new Gtk.Button.with_label (_("Try It Again"));
        var endgame_label = new Gtk.Label (_("🎉️ Great Job!"));
        endgame_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
        endgame_grid.attach (endgame_label, 0, 0);
        endgame_grid.attach (reset_button, 0, 1);

        var revealer = new Gtk.Revealer () {
            transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN
        };
        revealer.add (endgame_grid);

        var arrow_icon = new Gtk.Image () {
            gicon = new ThemedIcon ("go-next"),
            pixel_size = 24,
            halign = Gtk.Align.START,
            valign = Gtk.Align.START,
            margin_top = 10,
            margin_right = 10
        };
        arrow_icon.get_style_context ().add_class ("arrow-icon");
        arrow_icon.get_style_context ().add_provider (provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        var game_board = new PaintSpill.Widgets.DemoGameBoard ();

        var overlay = new Gtk.Overlay () {
            expand = true,
            halign = Gtk.Align.CENTER
        };
        overlay.add (game_board);
        overlay.add_overlay (arrow_icon);

        var control_panel = new PaintSpill.Widgets.ColorControlPanel (50);
        control_panel.current_color = game_board.current_color;

        attach (overlay, 0, 0);
        attach (control_panel, 0, 1);
        attach (revealer, 0, 2);

        // Connect to signals
        control_panel.button_clicked.connect ((color) => {
            arrow_icon.no_show_all = true;
            arrow_icon.visible = false;
            game_board.flood (color);
        });
        game_board.game_won.connect (() => {
            revealer.set_reveal_child (true);
            control_panel.enabled = false;
        });
        reset_button.clicked.connect (() => {
            arrow_icon.no_show_all = false;
            arrow_icon.visible = true;
            revealer.set_reveal_child (false);
            game_board.new_game (false);
            control_panel.current_color = game_board.current_color;
            control_panel.enabled = true;
        });
    }

}
