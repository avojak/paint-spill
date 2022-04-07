/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Layouts.MainLayout : Gtk.Grid {

    public unowned PaintSpill.Windows.MainWindow window { get; construct; }

    private PaintSpill.Widgets.Dialogs.RulesDialog? rules_dialog = null;
    private PaintSpill.Widgets.Dialogs.VictoryDialog? victory_dialog = null;
    private PaintSpill.Widgets.Dialogs.DefeatDialog? defeat_dialog = null;
    private PaintSpill.Widgets.Dialogs.NewGameConfirmationDialog? new_game_confirmation_dialog = null;
    private PaintSpill.Widgets.Dialogs.GameplayStatisticsDialog? gameplay_statistics_dialog = null;

    private Gtk.Grid moves_grid;
    private Gtk.Revealer endgame_revealer;
    private Gtk.Label status_label;
    private PaintSpill.Widgets.AbstractGameBoard game_board;
    private PaintSpill.Widgets.ColorControlPanel control_panel;
    private Gtk.Label moves_value;

    public MainLayout (PaintSpill.Windows.MainWindow window) {
        Object (
            window: window,
            width_request: 550,
            height_request: 750
        );
    }

    construct {
        var header_bar = new PaintSpill.Widgets.HeaderBar ();
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

        moves_grid = new Gtk.Grid () {
            expand = true,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.END,
            column_spacing = 8
        };
        var moves_remaining_text = _("Moves Remaining:");
        var moves_label = new Gtk.Label (@"<b>$moves_remaining_text</b>") {
            use_markup = true
        };
        moves_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        moves_value = new Gtk.Label (null) {
            use_markup = true
        };
        moves_value.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        moves_grid.attach (moves_label, 0, 0);
        moves_grid.attach (moves_value, 1, 0);

        game_board = new PaintSpill.Widgets.DefaultGameBoard ();
        update_moves_remaining_label (game_board.moves_remaining);
        game_board.updated_move_count.connect (update_moves_remaining_label);
        game_board.game_won.connect (on_game_won);
        game_board.game_lost.connect (on_game_lost);

        control_panel = new PaintSpill.Widgets.ColorControlPanel ();
        control_panel.button_clicked.connect (on_color_button_clicked);
        control_panel.current_color = game_board.current_color;

        var base_grid = new Gtk.Grid () {
            expand = true,
            margin_bottom = 8
        };
        base_grid.attach (endgame_revealer, 0, 0);
        base_grid.attach (moves_grid, 0, 1);
        base_grid.attach (game_board, 0, 2);
        base_grid.attach (control_panel, 0, 3);

        attach (header_bar, 0, 0);
        attach (base_grid, 0, 1);

        PaintSpill.Application.settings.changed.connect ((key) => {
            if (key == "difficulty") {
                var current_difficulty = (int) game_board.difficulty;
                var new_difficulty = PaintSpill.Application.settings.get_int ("difficulty");
                if (current_difficulty == new_difficulty) {
                    return;
                }
                if (!game_board.can_safely_start_new_game ()) {
                    Idle.add (() => {
                        var dialog = new PaintSpill.Widgets.Dialogs.DifficultyChangeWarningDialog (window);
                        int result = dialog.run ();
                        dialog.close ();
                        // Either start a new game, or revert the difficulty
                        if (result == Gtk.ResponseType.OK) {
                            setup_new_game (true);
                        } else {
                            PaintSpill.Application.settings.set_int ("difficulty", current_difficulty);
                        }
                        return false;
                    });
                } else {
                    setup_new_game ();
                }
            }
            if (key == "zen-mode") {
                if (is_zen_mode_enabled () == game_board.is_zen_mode_enabled) {
                    return;
                }
                if (is_zen_mode_enabled ()) {
                    if (game_board.is_game_in_progress) {
                        // Zen mode was turned on with a game in progress
                        Idle.add (() => {
                            var dialog = new PaintSpill.Widgets.Dialogs.NewGameConfirmationDialog (window);
                            int result = dialog.run ();
                            dialog.close ();
                            // Either start a new game, or revert the difficulty
                            if (result == Gtk.ResponseType.OK) {
                                setup_new_game (true);
                                set_moves_visible (false);
                            } else {
                                PaintSpill.Application.settings.set_boolean ("zen-mode", false);
                            }
                            return false;
                        });
                    } else {
                        // Zen mode was turned on without a game in progress
                        setup_new_game ();
                        set_moves_visible (false);
                    }
                } else {
                    if (game_board.is_game_in_progress) {
                        // Zen mode was turned off with a game in progress
                        setup_new_game ();
                        set_moves_visible (true);
                    } else {
                        // Zen mode was turned off without a game in progress
                        setup_new_game ();
                        set_moves_visible (true);
                    }
                }
            }
        });

        set_moves_visible (!is_zen_mode_enabled ());
        show_all ();

        check_first_launch ();
    }

    private void set_moves_visible (bool visible) {
        Idle.add (() => {
            moves_grid.visible = visible;
            moves_grid.no_show_all = !visible;
            return false;
        });
    }

    private bool is_zen_mode_enabled () {
        return PaintSpill.Application.settings.get_boolean ("zen-mode");
    }

    private void update_moves_remaining_label (int moves_remaining) {
        moves_value.set_markup (@"<b>$moves_remaining</b>");
    }

    private void on_color_button_clicked (PaintSpill.Models.Color color) {
        game_board.flood (color);
    }

    private void on_game_won () {
        if (is_zen_mode_enabled ()) {
            setup_new_game ();
            return;
        }
        // Update the UI
        var win_text = "You Win!";
        status_label.set_text (@"🎉️ $win_text");
        endgame_revealer.set_reveal_child (true);

        // Stop processing input to the control panel
        control_panel.enabled = false;

        show_victory_dialog ();
    }

    private void on_game_lost () {
        if (is_zen_mode_enabled ()) {
            setup_new_game ();
            return;
        }
        // Update the UI
        status_label.set_text (_("Game Over"));
        endgame_revealer.set_reveal_child (true);

        // Stop processing input to the control panel
        control_panel.enabled = false;

        show_defeat_dialog ();
    }

    private void check_first_launch () {
        // Show the rules dialog on the first launch of the game
        if (PaintSpill.Application.settings.get_boolean ("first-launch")) {
            Idle.add (() => {
                show_rules_dialog ();
                return false;
            });
            PaintSpill.Application.settings.set_boolean ("first-launch", false);
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
            new_game_confirmation_dialog = new PaintSpill.Widgets.Dialogs.NewGameConfirmationDialog (window);
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
            rules_dialog = new PaintSpill.Widgets.Dialogs.RulesDialog (window);
            rules_dialog.show_all ();
            rules_dialog.destroy.connect (() => {
                rules_dialog = null;
            });
        }
        rules_dialog.present ();
    }

    private void show_victory_dialog () {
        if (victory_dialog == null) {
            victory_dialog = new PaintSpill.Widgets.Dialogs.VictoryDialog (window);
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
            defeat_dialog = new PaintSpill.Widgets.Dialogs.DefeatDialog (window);
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
            gameplay_statistics_dialog = new PaintSpill.Widgets.Dialogs.GameplayStatisticsDialog (window);
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
        var dialog = new PaintSpill.Widgets.Dialogs.ResetGameplayStatisticsWarningDialog (window);
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
