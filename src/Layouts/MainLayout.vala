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

    private Flood.Widgets.GameBoard game_board;
    private Flood.Widgets.ColorControlPanel control_panel;
    private Gtk.Label moves_value;

    public MainLayout (Flood.Windows.MainWindow window) {
        Object (
            window: window
        );
    }

    construct {
        var header_bar = new Flood.Widgets.HeaderBar ();

        var moves_grid = new Gtk.Grid () {
            hexpand = true,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.END,
            column_spacing = 8
        };
        var moves_label = new Gtk.Label (_("Moves Remaining:"));
        moves_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        moves_value = new Gtk.Label ("25");
        moves_value.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        moves_grid.attach (moves_label, 0, 0);
        moves_grid.attach (moves_value, 1, 0);

        game_board = new Flood.Widgets.GameBoard ();
        control_panel = new Flood.Widgets.ColorControlPanel ();
        control_panel.button_clicked.connect ((color) => {
            game_board.flood (color);
        });
        control_panel.current_color = game_board.current_color;

        var base_grid = new Gtk.Grid () {
            expand = true
        };
        base_grid.attach (control_panel, 0, 0, 1, 2);
        base_grid.attach (moves_grid, 1, 0, 1, 1);
        base_grid.attach (game_board, 1, 1, 1, 1);

        attach (header_bar, 0, 0);
        attach (base_grid, 0, 1);

        show_all ();
    }

}
