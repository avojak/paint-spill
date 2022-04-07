/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.ColorButton : Gtk.Overlay {

    private Gtk.Button button;
    private Gtk.Revealer revealer;

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

    public PaintSpill.Models.Color color { get; construct; }

    public ColorButton (PaintSpill.Models.Color color, int size = 64) {
        Object (
            height_request: size,
            width_request: size,
            color: color
        );
    }

    construct {
        button = new Gtk.Button ();
        button.get_style_context ().add_class ("circular");
        button.get_style_context ().add_class (color.get_style_class ());
        button.clicked.connect (() => {
            clicked ();
        });

        revealer = new Gtk.Revealer () {
            transition_type = Gtk.RevealerTransitionType.NONE,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER
        };
        revealer.add (new Gtk.Image.from_icon_name (Constants.APP_ID + ".color-fill", Gtk.IconSize.LARGE_TOOLBAR));

        add (button);
        add_overlay (revealer);

        add_style (color.get_style_class (), color.get_value (true), color.get_value (false));
    }

    public void set_enabled (bool enabled) {
        button.sensitive = enabled;
        if (enabled) {
            button.get_style_context ().remove_class ("disabled");
            revealer.set_reveal_child (false);
        } else {
            button.get_style_context ().add_class ("disabled");
            revealer.set_reveal_child (true);
        }
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

    public signal void clicked ();

}
