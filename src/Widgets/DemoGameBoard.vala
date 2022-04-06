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

public class Flood.Widgets.DemoGameBoard : Flood.Widgets.AbstractGameBoard {

    public DemoGameBoard () {
        Object (
            difficulty: Flood.Models.Difficulty.DEMO
        );
    }

    protected override void on_new_game (bool should_record_loss) {
        // Do nothing
    }

    protected override bool should_restore_state () {
        return false;
    }

    protected override void write_state () {
        // Do nothing
    }

    public override void reset_gameplay_statistics () {
        // Do nothing
    }

}
