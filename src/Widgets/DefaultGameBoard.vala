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

public class Flood.Widgets.DefaultGameBoard : Flood.Widgets.AbstractGameBoard {

    // TODO: Add some sort of border around the grid

    //  public Flood.Models.Difficulty difficulty { get; set; }
    //  public Flood.Models.Color current_color { get; set; }
    //  public int moves_remaining { get; set; }

    //  private int num_rows;
    //  private int num_cols;
    //  private bool is_game_in_progress;

    //  private Gee.List<Flood.Widgets.Square> squares;
    //  private Gee.List<int> flooded_indices;

    public DefaultGameBoard () {
        Object (
            difficulty: (Flood.Models.Difficulty) Flood.Application.settings.get_int ("difficulty")
        );
    }

    construct {
        game_won.connect (() => {
            increment_stat ("num-games-won");
        });
        game_lost.connect (() => {
            increment_stat ("num-games-lost");
        });
    }

    protected override void on_new_game (bool should_record_loss) {
        difficulty = (Flood.Models.Difficulty) Flood.Application.settings.get_int ("difficulty");
        // Current game is no longer in progress
        Flood.Application.settings.set_boolean ("is-game-in-progress", false);
        // Record a loss if we're interrupting a current game
        if (should_record_loss) {
            increment_stat ("num-games-lost");
        }
    }

    protected override bool should_restore_state () {
        return Flood.Application.settings.get_boolean ("is-game-in-progress");
    }

    protected override void write_state () {
        Flood.Application.settings.set_boolean ("is-game-in-progress", is_game_in_progress);
        if (is_game_in_progress) {
            Gee.List <string> square_colors = new Gee.ArrayList<string> ();
            foreach (var square in squares) {
                square_colors.add (square.color.to_string ());
            }
            var board_state = string.joinv (",", square_colors.to_array ());
            Flood.Application.settings.set_string ("board-state", board_state);
            Flood.Application.settings.set_int ("moves-remaining", moves_remaining);
        } else {
            Flood.Application.settings.set_string ("board-state", "");
            Flood.Application.settings.set_int ("moves-remaining", 0);
        }
    }

    public override void reset_gameplay_statistics () {
        set_int_stat ("num-games-won", 0);
        set_int_stat ("num-games-lost", 0);
    }

    private int get_int_stat (string name) {
        return Flood.Application.settings.get_int (name);
    }

    private void set_int_stat (string name, int value) {
        Flood.Application.settings.set_int (name, value);
    }

    private void increment_stat (string name) {
        set_int_stat (name, get_int_stat (name) + 1);
    }

}
