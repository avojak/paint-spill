/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.DefaultGameBoard : PaintSpill.Widgets.AbstractGameBoard {

    // TODO: Add some sort of border around the grid

    public DefaultGameBoard () {
        Object (
            difficulty: (PaintSpill.Models.Difficulty) PaintSpill.Application.settings.get_int ("difficulty")
        );
    }

    construct {
        game_won.connect (() => {
            if (is_zen_mode_enabled) {
                return;
            }
            increment_stat ("num-games-won");
        });
        game_lost.connect (() => {
            if (is_zen_mode_enabled) {
                return;
            }
            increment_stat ("num-games-lost");
        });
    }

    protected override void on_new_game (bool should_record_loss) {
        difficulty = (PaintSpill.Models.Difficulty) PaintSpill.Application.settings.get_int ("difficulty");
        // Current game is no longer in progress
        PaintSpill.Application.settings.set_boolean ("is-game-in-progress", false);
        // Record a loss if we're interrupting a current game
        if (should_record_loss) {
            increment_stat ("num-games-lost");
        }
    }

    protected override bool should_restore_state () {
        return PaintSpill.Application.settings.get_boolean ("is-game-in-progress");
    }

    protected override void write_state () {
        PaintSpill.Application.settings.set_boolean ("is-game-in-progress", is_game_in_progress);
        if (is_game_in_progress) {
            Gee.List <string> square_colors = new Gee.ArrayList<string> ();
            foreach (var square in squares) {
                square_colors.add (square.color.to_string ());
            }
            var board_state = string.joinv (",", square_colors.to_array ());
            PaintSpill.Application.settings.set_string ("board-state", board_state);
            PaintSpill.Application.settings.set_int ("moves-remaining", moves_remaining);
        } else {
            PaintSpill.Application.settings.set_string ("board-state", "");
            PaintSpill.Application.settings.set_int ("moves-remaining", 0);
        }
    }

    public override void reset_gameplay_statistics () {
        set_int_stat ("num-games-won", 0);
        set_int_stat ("num-games-lost", 0);
    }

    private int get_int_stat (string name) {
        return PaintSpill.Application.settings.get_int (name);
    }

    private void set_int_stat (string name, int value) {
        PaintSpill.Application.settings.set_int (name, value);
    }

    private void increment_stat (string name) {
        set_int_stat (name, get_int_stat (name) + 1);
    }

}
