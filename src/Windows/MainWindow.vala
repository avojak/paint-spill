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

public class Flood.Windows.MainWindow : Hdy.Window {

    public weak Flood.Application app { get; construct; }

    private Flood.Services.ActionManager action_manager;
    private Gtk.AccelGroup accel_group;

    private Flood.Layouts.MainLayout layout;

    public MainWindow (Flood.Application application) {
        Object (
            title: Constants.APP_NAME,
            application: application,
            app: application,
            border_width: 0,
            resizable: true,
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    construct {
        accel_group = new Gtk.AccelGroup ();
        add_accel_group (accel_group);
        action_manager = new Flood.Services.ActionManager (app, this);

        layout = new Flood.Layouts.MainLayout (this);

        add (layout);

        restore_window_position ();

        this.destroy.connect (() => {
            // Do stuff before closing the application
        });

        this.delete_event.connect (before_destroy);

        show_app ();
    }

    private void restore_window_position () {
        move (Flood.Application.settings.get_int ("pos-x"), Flood.Application.settings.get_int ("pos-y"));
        resize (Flood.Application.settings.get_int ("window-width"), Flood.Application.settings.get_int ("window-height"));
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
        int width, height, x, y;

        get_size (out width, out height);
        get_position (out x, out y);

        Flood.Application.settings.set_int ("pos-x", x);
        Flood.Application.settings.set_int ("pos-y", y);
        Flood.Application.settings.set_int ("window-width", width);
        Flood.Application.settings.set_int ("window-height", height);
    }

    public void show_preferences_dialog () {
        
    }

}
