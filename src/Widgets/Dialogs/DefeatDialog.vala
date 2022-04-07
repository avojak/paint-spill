/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.Dialogs.DefeatDialog : Granite.Dialog {

    public DefeatDialog (PaintSpill.Windows.MainWindow main_window) {
        Object (
            deletable: false,
            resizable: false,
            title: _("Game Over"),
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

        var header_title = new Gtk.Label (_("Game Over")) {
            halign = Gtk.Align.CENTER,
            hexpand = true,
            margin_end = 10
        };
        header_title.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        header_title.set_line_wrap (true);

        header_grid.attach (header_title, 0, 0);

        // Create the main body
        var body_grid = new Gtk.Grid () {
            halign = Gtk.Align.CENTER,
            margin_start = 30,
            margin_end = 30,
            margin_bottom = 10,
            column_spacing = 10,
            row_spacing = 8
        };

        body_grid.attach (new PaintSpill.Widgets.GameplayStatistics (), 0, 0);
        body_grid.attach (new Gtk.Label (_("Would you like to play again?")) {
            margin_top = 30,
            margin_bottom = 10
        }, 0, 1);

        body.add (header_grid);
        body.add (body_grid);

        // Add action buttons
        var not_now_button = new Gtk.Button.with_label (_("Not Now"));
        not_now_button.clicked.connect (() => {
            close ();
        });

        var play_again_button = new Gtk.Button.with_label (_("Play Again"));
        play_again_button.get_style_context ().add_class ("suggested-action");
        play_again_button.clicked.connect (() => {
            play_again_button_clicked ();
        });

        add_action_widget (not_now_button, 0);
        add_action_widget (play_again_button, 1);
    }

    public signal void play_again_button_clicked ();

}
