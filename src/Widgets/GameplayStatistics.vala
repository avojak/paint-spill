/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.GameplayStatistics : Gtk.Grid {

    public GameplayStatistics () {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            halign: Gtk.Align.CENTER,
            hexpand: true,
            margin: 8,
            row_spacing: 8,
            column_spacing: 8
        );
    }

    construct {
        // Load stats and do calculations
        int num_games_won = get_int_stat ("num-games-won");
        int num_games_lost = get_int_stat ("num-games-lost");
        int total_games = num_games_won + num_games_lost;
        int win_percent = total_games > 0 ? (int) (((double) num_games_won / (double) total_games) * 100) : 0;

        var stats_grid = new Gtk.Grid () {
            orientation = Gtk.Orientation.VERTICAL,
            halign = Gtk.Align.CENTER,
            margin = 8,
            row_spacing = 8,
            column_spacing = 8
        };
        var games_played_value = new Gtk.Label ("<b>%s</b>".printf (total_games.to_string ())) {
            use_markup = true
        };
        games_played_value.get_style_context ().add_class ("h3");
        var games_played_label = new Gtk.Label (_("Number of Games Played")) {
            justify = Gtk.Justification.CENTER,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.START,
            max_width_chars = 10,
            wrap = true,
            wrap_mode = Pango.WrapMode.WORD
        };
        var win_percent_value = new Gtk.Label ("<b>%d%%</b>".printf (win_percent)) {
            use_markup = true
        };
        win_percent_value.get_style_context ().add_class ("h3");
        var win_percent_label = new Gtk.Label (_("Win Percent")) {
            justify = Gtk.Justification.CENTER,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.START,
            max_width_chars = 10,
            wrap = true,
            wrap_mode = Pango.WrapMode.WORD
        };

        stats_grid.attach (games_played_value, 0, 0);
        stats_grid.attach (games_played_label, 0, 1);
        stats_grid.attach (win_percent_value, 1, 0);
        stats_grid.attach (win_percent_label, 1, 1);

        attach (stats_grid, 0, 0);
    }

    private int get_int_stat (string name) {
        return PaintSpill.Application.settings.get_int (name);
    }

}
