/*
 * Copyright (c) 2022 Andrew Vojak (https://avojak.com)
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

public class Flood.Widgets.Dialogs.DefeatDialog : Granite.Dialog {

    public DefeatDialog (Flood.Windows.MainWindow main_window) {
        Object (
            deletable: false,
            resizable: false,
            title: "Game Over",
            transient_for: main_window,
            modal: true
        );
    }

    construct {
        var body = get_content_area ();

        // Create the header
        var header_grid = new Gtk.Grid () {
            margin_start = 30,
            margin_end = 30,
            margin_bottom = 30,
            column_spacing = 10
        };

        var header_title = new Gtk.Label ("Game Over") {
            halign = Gtk.Align.CENTER,
            hexpand = true,
            margin_end = 10
        };
        header_title.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        header_title.set_line_wrap (true);

        header_grid.attach (header_title, 0, 0);

        // Create the main body
        var body_grid = new Gtk.Grid () {
            halign = Gtk.Align.CENTER,
            margin_start = 30,
            margin_end = 30,
            margin_bottom = 10,
            column_spacing = 10,
            row_spacing = 8
        };

        body_grid.attach (new Flood.Widgets.GameplayStatistics (), 0, 0);
        body_grid.attach (new Gtk.Label ("Would you like to play again?") {
            margin_top = 30,
            margin_bottom = 10
        }, 0, 1);

        body.add (header_grid);
        body.add (body_grid);

        // Add action buttons
        var not_now_button = new Gtk.Button.with_label (_("Not Now"));
        not_now_button.clicked.connect (() => {
            close ();
        });

        var play_again_button = new Gtk.Button.with_label (_("Play Again"));
        play_again_button.get_style_context ().add_class ("suggested-action");
        play_again_button.clicked.connect (() => {
            play_again_button_clicked ();
        });

        add_action_widget (not_now_button, 0);
        add_action_widget (play_again_button, 1);
    }

    public signal void play_again_button_clicked ();

}