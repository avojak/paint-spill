/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class PaintSpill.Widgets.DemoGameBoard : PaintSpill.Widgets.AbstractGameBoard {

    public DemoGameBoard () {
        Object (
            difficulty: PaintSpill.Models.Difficulty.DEMO
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
