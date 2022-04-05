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

public class Flood.Widgets.ColorControlPanel : Gtk.Grid {

    private Flood.Models.Color _current_color;
    public Flood.Models.Color current_color {
        get {
            return this._current_color;
        }
        set {
            this._current_color = value;
            update_button_sensitivity (value);
            queue_draw ();
        }
    }

    public bool enabled { get; set; }

    private Gee.Map<Flood.Models.Color, Flood.Widgets.ColorButton> buttons;

    public ColorControlPanel () {
        Object (
            expand: true,
            halign: Gtk.Align.CENTER,
            valign: Gtk.Align.CENTER,
            margin: 8,
            enabled: true
        );
    }

    construct {
        // Create the buttons
        buttons = new Gee.HashMap<Flood.Models.Color, Flood.Widgets.ColorButton> ();
        buttons.set (Flood.Models.Color.GRAPE, new Flood.Widgets.ColorButton (Flood.Models.Color.GRAPE));
        buttons.set (Flood.Models.Color.BLUEBERRY, new Flood.Widgets.ColorButton (Flood.Models.Color.BLUEBERRY));
        buttons.set (Flood.Models.Color.LIME, new Flood.Widgets.ColorButton (Flood.Models.Color.LIME));
        buttons.set (Flood.Models.Color.BANANA, new Flood.Widgets.ColorButton (Flood.Models.Color.BANANA));
        buttons.set (Flood.Models.Color.STRAWBERRY, new Flood.Widgets.ColorButton (Flood.Models.Color.STRAWBERRY));
        buttons.set (Flood.Models.Color.BUBBLEGUM, new Flood.Widgets.ColorButton (Flood.Models.Color.BUBBLEGUM));

        // Connect to signals
        foreach (var entry in buttons.entries) {
            entry.value.clicked.connect (() => {
                on_button_clicked (entry.key);
            });
        }

        // Add to the view
        var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8);
        foreach (var entry in buttons.entries) {
            button_box.add (entry.value);
        }

        attach (button_box, 0, 0);
    }

    private void on_button_clicked (Flood.Models.Color color) {
        if (!enabled) {
            return;
        }
        update_button_sensitivity (color);
        button_clicked (color);
    }

    private void update_button_sensitivity (Flood.Models.Color color) {
        foreach (var entry in buttons.entries) {
            entry.value.set_enabled (entry.key != color);
        }
    }

    public signal void button_clicked (Flood.Models.Color color);

}
