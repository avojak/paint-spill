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

public class Flood.Layouts.MainLayout : Gtk.Grid {

    public unowned Flood.Windows.MainWindow window { get; construct; }

    private Gtk.Revealer endgame_revealer;
    private Gtk.Label status_label;
    private Flood.Widgets.GameBoard game_board;
    private Flood.Widgets.ColorControlPanel control_panel;
    private Gtk.Label moves_value;

    private int moves_remaining;

    public MainLayout (Flood.Windows.MainWindow window) {
        Object (
            window: window
        );
    }

    construct {
        initialize ();
    }

    private void initialize () {
        moves_remaining = 25;

        setup_ui ();
    }

    private void setup_ui () {
        var header_bar = new Flood.Widgets.HeaderBar ();

        status_label = new Gtk.Label ("") {
            margin = 8,
            halign = Gtk.Align.CENTER
        };
        status_label.get_style_context ().add_class ("h2");

        endgame_revealer = new Gtk.Revealer () {
            transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN,
            expand = true
        };
        endgame_revealer.add (status_label);

        var moves_grid = new Gtk.Grid () {
            hexpand = true,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.END,
            column_spacing = 8
        };
        var moves_label = new Gtk.Label (_("<b>Moves Remaining:</b>")) {
            use_markup = true
        };
        moves_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        moves_value = new Gtk.Label (@"<b>$moves_remaining</b>") {
            use_markup = true
        };
        moves_value.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        moves_grid.attach (moves_label, 0, 0);
        moves_grid.attach (moves_value, 1, 0);

        game_board = new Flood.Widgets.GameBoard ();
        control_panel = new Flood.Widgets.ColorControlPanel ();
        control_panel.button_clicked.connect (on_color_button_clicked);
        control_panel.current_color = game_board.current_color;

        var base_grid = new Gtk.Grid () {
            expand = true
        };
        base_grid.attach (control_panel, 0, 1, 1, 1);
        base_grid.attach (moves_grid, 1, 0, 1, 1);
        base_grid.attach (game_board, 1, 1, 1, 1);

        attach (header_bar, 0, 0);
        attach (base_grid, 0, 1);

        show_all ();
    }

    private void on_color_button_clicked (Flood.Models.Color color) {
        // Flood the board
        bool fully_flooded = game_board.flood (color);
        // Game over?
        if (fully_flooded) {
            // TODO: Win!
        }
        // Decrement the move count
        decrement_move_count ();
        if (moves_remaining == 0) {
            // TODO: Lose!
        }
    }

    private void decrement_move_count () {
        moves_remaining--;
        moves_value.set_markup (@"<b>$moves_remaining</b>");
    }

    public void new_game () {
        // TODO
    }

}
