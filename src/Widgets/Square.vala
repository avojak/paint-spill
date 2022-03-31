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

public class Flood.Widgets.Square : Gtk.DrawingArea {

    private Flood.Models.Color _color;
    public Flood.Models.Color color {
        get { return this._color; }
        set { this._color = value; queue_draw (); }
    }

    public Square (Flood.Models.Color color) {
        Object (
            color: color
            //  expand: true
            //  width_request: 8,
            //  height_request: 8
        );
    }

    construct {
        //  color = Flood.Models.Color.BLUEBERRY;
        set_size_request (32, 32);
        draw.connect (draw_fill_color);
    }

    //  protected override bool draw (Cairo.Context ctx) {
    //      base.draw (ctx);
    //      ctx.save ();
    //      draw_fill_color (ctx);
    //      ctx.restore ();
    //      return false;
    //  }

    private bool draw_fill_color (Cairo.Context ctx) {
        // Determine location
        Gtk.Allocation allocation;
        get_allocation (out allocation);
        //  int x = allocation.x;
        //  int y = allocation.y;
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
