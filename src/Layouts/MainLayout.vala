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

public class Flood.Layouts.MainLayout : Gtk.Grid {

    public unowned Flood.Windows.MainWindow window { get; construct; }

    private Flood.Widgets.Dialogs.RulesDialog? rules_dialog = null;
    private Flood.Widgets.Dialogs.VictoryDialog? victory_dialog = null;
    private Flood.Widgets.Dialogs.DefeatDialog? defeat_dialog = null;
    private Flood.Widgets.Dialogs.NewGameConfirmationDialog? new_game_confirmation_dialog = null;
    private Flood.Widgets.Dialogs.GameplayStatisticsDialog? gameplay_statistics_dialog = null;

    private Gtk.Revealer endgame_revealer;
    private Gtk.Label status_label;
    private Flood.Widgets.AbstractGameBoard game_board;
    private Flood.Widgets.ColorControlPanel control_panel;
    private Gtk.Label moves_value;

    public MainLayout (Flood.Windows.MainWindow window) {
        Object (
            window: window
        );
    }

    construct {
        initialize ();
    }

    private void initialize () {
        setup_ui ();
    }

    private void setup_ui () {
        var header_bar = new Flood.Widgets.HeaderBar ();
        header_bar.gameplay_statistics_menu_item_clicked.connect (() => {
            show_gameplay_statistics_dialog ();
        });

        status_label = new Gtk.Label ("") {
            margin = 8,
            halign = Gtk.Align.CENTER
        };
        status_label.get_style_context ().add_class ("h2");

        endgame_revealer = new Gtk.Revealer () {
            transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN,
            expand = true
        };
        endgame_revealer.add (status_label);

        var moves_grid = new Gtk.Grid () {
            expand = true,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.END,
            column_spacing = 8
        };
        var moves_label = new Gtk.Label (_("<b>Moves Remaining:</b>")) {
            use_markup = true
        };
        moves_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        moves_value = new Gtk.Label (null) {
            use_markup = true
        };
        moves_value.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        moves_grid.attach (moves_label, 0, 0);
        moves_grid.attach (moves_value, 1, 0);

        game_board = new Flood.Widgets.DefaultGameBoard ();
        update_moves_remaining_label (game_board.moves_remaining);
        game_board.updated_move_count.connect (update_moves_remaining_label);
        game_board.game_won.connect (on_game_won);
        game_board.game_lost.connect (on_game_lost);

        control_panel = new Flood.Widgets.ColorControlPanel ();
        control_panel.button_clicked.connect (on_color_button_clicked);
        control_panel.current_color = game_board.current_color;

        var base_grid = new Gtk.Grid () {
            expand = true
        };
        base_grid.attach (endgame_revealer, 0, 0);
        base_grid.attach (moves_grid, 0, 1);
        base_grid.attach (game_board, 0, 2);
        base_grid.attach (control_panel, 0, 3);

        attach (header_bar, 0, 0);
        attach (base_grid, 0, 1);

        Flood.Application.settings.changed.connect ((key) => {
            if (key == "difficulty") {
                var current_difficulty = (int) game_board.difficulty;
                var new_difficulty = Flood.Application.settings.get_int ("difficulty");
                if (current_difficulty == new_difficulty) {
                    return;
                }
                if (!game_board.can_safely_start_new_game ()) {
                    Idle.add (() => {
                        var dialog = new Flood.Widgets.Dialogs.DifficultyChangeWarningDialog (window);
                        int result = dialog.run ();
                        dialog.close ();
                        // Either start a new game, or revert the difficulty
                        if (result == Gtk.ResponseType.OK) {
                            setup_new_game (true);
                        } else {
                            Flood.Application.settings.set_int ("difficulty", current_difficulty);
                        }
                        return false;
                    });
                } else {
                    setup_new_game ();
                }
            }
        });

        show_all ();

        check_first_launch ();
    }

    private void update_moves_remaining_label (int moves_remaining) {
        moves_value.set_markup (@"<b>$moves_remaining</b>");
    }

    private void on_color_button_clicked (Flood.Models.Color color) {
        game_board.flood (color);
    }

    private void on_game_won () {
        // Update the UI
        status_label.set_text ("🎉️ You Win!");
        endgame_revealer.set_reveal_child (true);

        // Stop processing input to the control panel
        control_panel.enabled = false;

        show_victory_dialog ();
    }

    private void on_game_lost () {
        // Update the UI
        status_label.set_text ("Game Over");
        endgame_revealer.set_reveal_child (true);

        // Stop processing input to the control panel
        control_panel.enabled = false;

        show_defeat_dialog ();
    }

    private void check_first_launch () {
        // Show the rules dialog on the first launch of the game
        if (Flood.Application.settings.get_boolean ("first-launch")) {
            Idle.add (() => {
                show_rules_dialog ();
                return false;
            });
            Flood.Application.settings.set_boolean ("first-launch", false);
        }
    }

    private void setup_new_game (bool should_record_loss = false) {
        endgame_revealer.set_reveal_child (false);
        control_panel.enabled = true;
        game_board.new_game (should_record_loss);
        control_panel.current_color = game_board.current_color;
    }

    public void new_game () {
        // TODO: Check for open dialogs
        if (game_board.can_safely_start_new_game ()) {
            setup_new_game ();
            return;
        }
        if (new_game_confirmation_dialog == null) {
            new_game_confirmation_dialog = new Flood.Widgets.Dialogs.NewGameConfirmationDialog (window);
            new_game_confirmation_dialog.show_all ();
            new_game_confirmation_dialog.response.connect ((response_id) => {
                if (response_id == Gtk.ResponseType.OK) {
                    setup_new_game (true);
                }
                new_game_confirmation_dialog.close ();
            });
            new_game_confirmation_dialog.destroy.connect (() => {
                new_game_confirmation_dialog = null;
            });
        }
        new_game_confirmation_dialog.present ();
    }

    public void show_rules_dialog () {
        if (rules_dialog == null) {
            rules_dialog = new Flood.Widgets.Dialogs.RulesDialog (window);
            rules_dialog.show_all ();
            rules_dialog.destroy.connect (() => {
                rules_dialog = null;
            });
        }
        rules_dialog.present ();
    }

    private void show_victory_dialog () {
        if (victory_dialog == null) {
            victory_dialog = new Flood.Widgets.Dialogs.VictoryDialog (window);
            victory_dialog.show_all ();
            victory_dialog.play_again_button_clicked.connect (() => {
                victory_dialog.close ();
                setup_new_game ();
            });
            victory_dialog.destroy.connect (() => {
                victory_dialog = null;
            });
        }
        victory_dialog.present ();
    }

    private void show_defeat_dialog () {
        if (defeat_dialog == null) {
            defeat_dialog = new Flood.Widgets.Dialogs.DefeatDialog (window);
            defeat_dialog.show_all ();
            defeat_dialog.play_again_button_clicked.connect (() => {
                defeat_dialog.close ();
                setup_new_game ();
            });
            defeat_dialog.destroy.connect (() => {
                defeat_dialog = null;
            });
        }
        defeat_dialog.present ();
    }

    private void show_gameplay_statistics_dialog () {
        if (gameplay_statistics_dialog == null) {
            gameplay_statistics_dialog = new Flood.Widgets.Dialogs.GameplayStatisticsDialog (window);
            gameplay_statistics_dialog.show_all ();
            gameplay_statistics_dialog.reset_button_clicked.connect (() => {
                gameplay_statistics_dialog.close ();
                Idle.add (() => {
                    show_gameplay_statistics_warning_dialog ();
                    return false;
                });
            });
            gameplay_statistics_dialog.destroy.connect (() => {
                gameplay_statistics_dialog = null;
            });
        }
        gameplay_statistics_dialog.present ();
    }

    private void show_gameplay_statistics_warning_dialog () {
        var dialog = new Flood.Widgets.Dialogs.ResetGameplayStatisticsWarningDialog (window);
        int result = dialog.run ();
        dialog.close ();
        if (result == Gtk.ResponseType.OK) {
            game_board.reset_gameplay_statistics ();
        }
        Idle.add (() => {
            show_gameplay_statistics_dialog ();
            return false;
        });
    }

}
