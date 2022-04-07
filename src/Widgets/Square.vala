/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.Square : Gtk.DrawingArea {

    private PaintSpill.Models.Color _color;
    public PaintSpill.Models.Color color {
        get { return this._color; }
        set { this._color = value; queue_draw (); }
    }

    public int size { get; construct; }

    public Square (PaintSpill.Models.Color color, int size = 32) {
        Object (
            color: color,
            size: size
        );
    }

    construct {
        set_size_request (size, size);
        draw.connect (draw_fill_color);
    }

    private bool draw_fill_color (Cairo.Context ctx) {
        // Determine location
        Gtk.Allocation allocation;
        get_allocation (out allocation);
        int width = allocation.width;
        int height = allocation.height;

        // Determine color
        var color = new Granite.Drawing.Color.from_string (color.get_value ());
        ctx.set_source_rgb (color.R, color.G, color.B);

        // Draw
        ctx.move_to (0, 0);
        ctx.rel_line_to (width, 0);
        ctx.rel_line_to (0, height);
        ctx.rel_line_to (-width, 0);
        ctx.close_path ();
        ctx.fill ();

        return false;
    }

}
