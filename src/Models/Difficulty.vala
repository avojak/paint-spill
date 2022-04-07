/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public enum PaintSpill.Models.Difficulty {

    EASY,
    NORMAL,
    HARD,
    DEMO;

    public string get_display_string () {
        switch (this) {
            case EASY:
                return _("Easy");
            case NORMAL:
                return _("Normal");
            case HARD:
                return _("Hard");
            case DEMO:
                return _("Demo");
            default:
                assert_not_reached ();
        }
    }

    public string get_details_markup () {
        var fullname = _("%s Difficulty").printf (get_display_string ());
        var details = _("%ix%i grid, %i moves").printf (get_num_rows (), get_num_cols (), get_num_moves ());
        return @"$fullname\n<small>$details</small>";
    }

    public int get_num_rows () {
        switch (this) {
            case EASY:
                return 5;
            case NORMAL:
                return 10;
            case HARD:
                return 14;
            case DEMO:
                return 5;
            default:
                assert_not_reached ();
        }
    }

    public int get_num_cols () {
        switch (this) {
            case EASY:
                return 5;
            case NORMAL:
                return 10;
            case HARD:
                return 14;
            case DEMO:
                return 5;
            default:
                assert_not_reached ();
        }
    }

    public int get_num_moves () {
        switch (this) {
            case EASY:
                return 15;
            case NORMAL:
                return 20;
            case HARD:
                return 25;
            case DEMO:
                return 0;
            default:
                assert_not_reached ();
        }
    }

    public int get_square_size () {
        switch (this) {
            case EASY:
                return 98;
            case NORMAL:
                return 49;
            case HARD:
                return 35;
            case DEMO:
                return 32;
            default:
                assert_not_reached ();
        }
    }

    public string get_short_name () {
        switch (this) {
            case EASY:
                return "EASY";
            case NORMAL:
                return "NORMAL";
            case HARD:
                return "HARD";
            case DEMO:
                return "DEMO";
            default:
                assert_not_reached ();
        }
    }

    public static Difficulty get_value_by_short_name (string short_name) {
        switch (short_name) {
            case "EASY":
                return EASY;
            case "NORMAL":
                return NORMAL;
            case "HARD":
                return HARD;
            case "DEMO":
                return DEMO;
            default:
                assert_not_reached ();
        }
    }

    public static Difficulty get_value_by_name (string name) {
        EnumClass enumc = (EnumClass) typeof (Difficulty).class_ref ();
        unowned EnumValue? eval = enumc.get_value_by_name (name);
        if (eval == null) {
            assert_not_reached ();
        }
        return (Difficulty) eval.value;
    }

}
