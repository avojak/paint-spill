/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.Dialogs.RulesDialog : Granite.Dialog {

    public RulesDialog (PaintSpill.Windows.MainWindow main_window) {
        Object (
            deletable: false,
            resizable: false,
            title: _("How to Play %s").printf (Constants.APP_NAME),
            transient_for: main_window,
            modal: true,
            width_request: 300,
            hexpand: false
        );
    }

    construct {
        var body = get_content_area ();

        // Create the header
        var header_title = new Gtk.Label (_("How to Play"));
        header_title.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        header_title.halign = Gtk.Align.CENTER;
        header_title.hexpand = true;
        header_title.margin_end = 10;
        header_title.set_line_wrap (true);

        var header_grid = create_grid ();
        header_grid.attach (header_title, 0, 0);

        body.add (header_grid);
        body.add (new PaintSpill.Widgets.Rules ());

        // Add action buttons
        var start_button = new Gtk.Button.with_label (_("Close"));
        start_button.clicked.connect (() => {
            close ();
        });

        add_action_widget (start_button, 1);
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

}
