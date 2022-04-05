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

public enum Flood.Models.Difficulty {

    EASY,
    NORMAL,
    HARD;

    public string get_display_string () {
        switch (this) {
            case EASY:
                return _("Easy");
            case NORMAL:
                return _("Normal");
            case HARD:
                return _("Hard");
            default:
                assert_not_reached ();
        }
    }

    public string get_details_markup () {
        return _("%s Difficulty\n<small>%ix%i grid, %i moves</small>".printf (get_display_string (), get_num_rows (), get_num_cols (), get_num_moves ()));
    }

    public int get_num_rows () {
        switch (this) {
            case EASY:
                return 5;
            case NORMAL:
                return 10;
            case HARD:
                return 14;
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
            default:
                assert_not_reached ();
        }
    }

    public int get_num_moves () {
        switch (this) {
            case EASY:
                return 12;
            case NORMAL:
                return 20;
            case HARD:
                return 25;
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
