/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.ColorControlPanel : Gtk.Grid {

    private PaintSpill.Models.Color _current_color;
    public PaintSpill.Models.Color current_color {
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
    public int button_size { get; construct; }

    private Gee.Map<PaintSpill.Models.Color, PaintSpill.Widgets.ColorButton> buttons;

    public ColorControlPanel (int button_size = 64) {
        Object (
            expand: true,
            halign: Gtk.Align.CENTER,
            valign: Gtk.Align.CENTER,
            margin: 8,
            enabled: true,
            button_size: button_size
        );
    }

    construct {
        // Create the buttons
        buttons = new Gee.HashMap<PaintSpill.Models.Color, PaintSpill.Widgets.ColorButton> ();
        buttons.set (PaintSpill.Models.Color.GRAPE, new PaintSpill.Widgets.ColorButton (PaintSpill.Models.Color.GRAPE, button_size));
        buttons.set (PaintSpill.Models.Color.BLUEBERRY, new PaintSpill.Widgets.ColorButton (PaintSpill.Models.Color.BLUEBERRY, button_size));
        buttons.set (PaintSpill.Models.Color.LIME, new PaintSpill.Widgets.ColorButton (PaintSpill.Models.Color.LIME, button_size));
        buttons.set (PaintSpill.Models.Color.BANANA, new PaintSpill.Widgets.ColorButton (PaintSpill.Models.Color.BANANA, button_size));
        buttons.set (PaintSpill.Models.Color.STRAWBERRY, new PaintSpill.Widgets.ColorButton (PaintSpill.Models.Color.STRAWBERRY, button_size));
        buttons.set (PaintSpill.Models.Color.BUBBLEGUM, new PaintSpill.Widgets.ColorButton (PaintSpill.Models.Color.BUBBLEGUM, button_size));

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

    private void on_button_clicked (PaintSpill.Models.Color color) {
        if (!enabled) {
            return;
        }
        update_button_sensitivity (color);
        button_clicked (color);
    }

    private void update_button_sensitivity (PaintSpill.Models.Color color) {
        foreach (var entry in buttons.entries) {
            entry.value.set_enabled (entry.key != color);
        }
    }

    public signal void button_clicked (PaintSpill.Models.Color color);

}
