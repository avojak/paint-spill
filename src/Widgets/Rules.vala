/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

 public class PaintSpill.Widgets.Rules : Gtk.Grid {

    construct {
        var explanation_grid = create_grid ();
        explanation_grid.attach (create_label (_("Fill the board with all the same color paint before running out of moves!"), Granite.STYLE_CLASS_H4_LABEL), 0, 0);
        explanation_grid.attach (create_label (_("Click the round paint buttons to spill a new paint color onto the board starting in the top-left corner.")), 0, 1);
        explanation_grid.attach (create_label (_("Newly adjacent squares of the same color add to the total filled space.")), 0, 2);

        var try_it_out_grid = create_grid ();
        try_it_out_grid.attach (create_label (_("Try it out:"), Granite.STYLE_CLASS_H4_LABEL), 0, 0);

        var zen_mode_grid = create_grid ();
        zen_mode_grid.attach (create_label (_("Looking to relax?"), Granite.STYLE_CLASS_H4_LABEL), 0, 0);
        zen_mode_grid.attach (create_label (_("Try enabling Zen Mode from the menu!")), 0, 1);

        attach (explanation_grid, 0, 0);
        attach (create_separator (), 0, 1);
        attach (try_it_out_grid, 0, 2);
        attach (new PaintSpill.Widgets.DemoGame (), 0, 3);
        attach (create_separator (), 0, 4);
        attach (zen_mode_grid, 0, 5);
    }

    private Gtk.Grid create_grid () {
        return new Gtk.Grid () {
            halign = Gtk.Align.CENTER,
            hexpand = true,
            margin_start = 30,
            margin_end = 30,
            margin_bottom = 10,
            row_spacing = 8,
            column_spacing = 10
        };
    }

    private Gtk.Label create_label (string text, string? style_class = null) {
        var label = new Gtk.Label (text) {
            justify = Gtk.Justification.CENTER,
            halign = Gtk.Align.CENTER,
            max_width_chars = 35,
            wrap = true,
            wrap_mode = Pango.WrapMode.WORD,
            hexpand = true
        };
        if (style_class != null) {
            label.get_style_context ().add_class (style_class);
        }
        return label;
    }

    private Gtk.Separator create_separator () {
        return new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
            margin_start = 30,
            margin_end = 30,
            margin_top = 10,
            margin_bottom = 10
        };
    }

}
