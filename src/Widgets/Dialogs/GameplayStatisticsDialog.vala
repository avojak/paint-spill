/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.Dialogs.GameplayStatisticsDialog : Granite.Dialog {

    public GameplayStatisticsDialog (PaintSpill.Windows.MainWindow main_window) {
        Object (
            deletable: false,
            resizable: false,
            title: _("Gameplay Statistics"),
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

        var header_title = new Gtk.Label (_("Gameplay Statistics")) {
            halign = Gtk.Align.CENTER,
            hexpand = true,
            margin_end = 10
        };
        header_title.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        header_title.set_line_wrap (true);

        header_grid.attach (header_title, 0, 0);

        body.add (header_grid);
        body.add (new PaintSpill.Widgets.GameplayStatistics ());

        // Add action buttons
        var close_button = new Gtk.Button.with_label (_("Close"));
        close_button.clicked.connect (() => {
            close ();
        });
        var reset_button = new Gtk.Button.with_label (_("Reset…"));
        reset_button.set_tooltip_text (_("Reset Gameplay Statistics"));
        reset_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        reset_button.clicked.connect (() => {
            reset_button_clicked ();
        });
        add_action_widget (reset_button, Gtk.ResponseType.DELETE_EVENT);
        add_action_widget (close_button, Gtk.ResponseType.CLOSE);

        close_button.grab_focus ();
    }

    public signal void reset_button_clicked ();

}
