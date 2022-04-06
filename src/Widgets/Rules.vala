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

 public class Flood.Widgets.Rules : Gtk.Grid {

    construct {
        var explanation_grid = create_grid ();
        explanation_grid.attach (create_label (_("Flood the board with all the same color paint before running out of moves!"), Granite.STYLE_CLASS_H4_LABEL), 0, 0);
        explanation_grid.attach (create_label (_("Click the round paint buttons to spill a new paint color onto the board starting in the top-left corner.")), 0, 1);
        explanation_grid.attach (create_label (_("Newly adjacent squares of the same color add to the total flooded space.")), 0, 2);

        //  // Explain the keys
        //  var accelerator_grid = create_grid ();
        //  accelerator_grid.attach (new Granite.AccelLabel ("Undo a typed letter", "Delete"), 0, 2);
        //  accelerator_grid.attach (new Granite.AccelLabel ("Submit your guess", "Return"), 0, 3);

        // Explain the color changes
        //  var square_colors_grid = create_grid ();
        //  square_colors_grid.attach (create_label ("The letter is in the correct position."), 0, 0);
        //  square_colors_grid.attach (new Flood.Widgets.Square () {
        //      letter = 'A',
        //      state = Flood.Models.State.CORRECT
        //  }, 1, 0);
        //  square_colors_grid.attach (create_label ("The letter does not appear anywhere in the answer."), 0, 1);
        //  square_colors_grid.attach (new Flood.Widgets.Square () {
        //      letter = 'B',
        //      state = Flood.Models.State.INCORRECT
        //  }, 1, 1);
        //  square_colors_grid.attach (create_label ("The letter appears in the answer, but not in the position that you have guessed."), 0, 2);
        //  square_colors_grid.attach (new Flood.Widgets.Square () {
        //      letter = 'C',
        //      state = Flood.Models.State.CLOSE
        //  }, 1, 2);

        var try_it_out_grid = create_grid ();
        try_it_out_grid.attach (create_label (_("Try it out:"), Granite.STYLE_CLASS_H4_LABEL), 0, 0);

        attach (explanation_grid, 0, 0);
        //  attach (accelerator_grid, 0, 1);
        attach (create_separator (), 0, 1);
        attach (try_it_out_grid, 0, 2);
        attach (new Flood.Widgets.DemoGame (), 0, 3);
        attach (create_separator (), 0, 4);
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
