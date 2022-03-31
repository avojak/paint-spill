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

public class Flood.Widgets.ColorButton : Gtk.Button {

    /*
     * This class is directly derived from https://github.com/cassidyjames/palette/blob/main/src/Widgets/ColorButton.vala
     */

    private const string BUTTON_CSS = """
        .%s {
            background: %s;
        }
        .%s.disabled {
            background: %s;
        }
    """;

    public Flood.Models.Color color { get; construct; }

    public ColorButton (Flood.Models.Color color, int size = 64) {
        Object (
            height_request: size,
            width_request: size,
            color: color,
            tooltip_text: color.get_display_string ()
        );
    }

    construct {
        unowned var style_context = get_style_context ();
        style_context.add_class ("circular");
        style_context.add_class (color.get_style_class ());

        add_style (color.get_style_class (), color.get_value (true), color.get_value (false));
    }

    private void add_style (string class_name, string bg_color, string disabled_bg_color) {
        var provider = new Gtk.CssProvider ();
        try {
            var colored_css = BUTTON_CSS.printf (
                class_name,
                bg_color,

                class_name,
                disabled_bg_color
            );
            provider.load_from_data (colored_css, colored_css.length);

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        } catch (GLib.Error e) {
            warning (e.message);
        }
    }

}
