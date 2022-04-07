/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Windows.MainWindow : Hdy.Window {

    public weak PaintSpill.Application app { get; construct; }

    private PaintSpill.Services.ActionManager action_manager;
    private Gtk.AccelGroup accel_group;

    private PaintSpill.Layouts.MainLayout layout;

    public MainWindow (PaintSpill.Application application) {
        Object (
            title: Constants.APP_NAME,
            application: application,
            app: application,
            border_width: 0,
            resizable: false,
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    construct {
        accel_group = new Gtk.AccelGroup ();
        add_accel_group (accel_group);
        action_manager = new PaintSpill.Services.ActionManager (app, this);

        layout = new PaintSpill.Layouts.MainLayout (this);

        add (layout);

        restore_window_position ();

        this.delete_event.connect (before_destroy);

        show_app ();

        set_focus (null);
    }

    private void restore_window_position () {
        move (PaintSpill.Application.settings.get_int ("pos-x"), PaintSpill.Application.settings.get_int ("pos-y"));
    }

    private void show_app () {
        show_all ();
        present ();
    }

    public bool before_destroy () {
        update_position_settings ();
        destroy ();
        return true;
    }

    private void update_position_settings () {
        int x, y;
        get_position (out x, out y);
        PaintSpill.Application.settings.set_int ("pos-x", x);
        PaintSpill.Application.settings.set_int ("pos-y", y);
    }

    public void new_game () {
        layout.new_game ();
    }

    public void show_rules () {
        layout.show_rules_dialog ();
    }

}
