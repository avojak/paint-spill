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

public enum Flood.Models.Color {

    STRAWBERRY,
    BANANA,
    LIME,
    BLUEBERRY,
    GRAPE,
    BUBBLEGUM;

    private const string STRAWBERRY_100 = "#ff8c82";
    private const string STRAWBERRY_500 = "#c6262e";
    private const string BANANA_100 = "#fff394";
    private const string BANANA_500 = "#f9c440";
    private const string LIME_100 = "#d1ff82";
    private const string LIME_500 = "#68b723";
    private const string BLUEBERRY_100 = "#8cd5ff";
    private const string BLUEBERRY_500 = "#3689e6";
    private const string GRAPE_100 = "#e4c6fa";
    private const string GRAPE_500 = "#a56de2";
    private const string BUBBLEGUM_100 = "#fe9ab8";
    private const string BUBBLEGUM_300 = "#f4679d";
    private const string BUBBLEGUM_500 = "#de3e80";

    public string get_display_string () {
        switch (this) {
            case STRAWBERRY:
                return _("Strawberry");
            case BANANA:
                return _("Banana");
            case LIME:
                return _("Lime");
            case BLUEBERRY:
                return _("Blueberry");
            case GRAPE:
                return _("Grape");
            case BUBBLEGUM:
                return _("Bubblegum");
            default:
                assert_not_reached ();
        }
    }

    public string get_value (bool sensitive = true) {
        switch (this) {
            case STRAWBERRY:
                return sensitive ? STRAWBERRY_500 : STRAWBERRY_100;
            case BANANA:
                return sensitive ? BANANA_500 : BANANA_100;
            case LIME:
                return sensitive ? LIME_500 : LIME_100;
            case BLUEBERRY:
                return sensitive ? BLUEBERRY_500 : BLUEBERRY_100;
            case GRAPE:
                return sensitive ? GRAPE_500 : GRAPE_100;
            case BUBBLEGUM:
                return sensitive ? BUBBLEGUM_300 : BUBBLEGUM_100; // Use the 300 variant here to improve contrast against STRAWBERRY_500
            default:
                assert_not_reached ();
        }
    }

    public string get_style_class () {
        switch (this) {
            case STRAWBERRY:
                return "strawberry";
            case BANANA:
                return "banana";
            case LIME:
                return "lime";
            case BLUEBERRY:
                return "blueberry";
            case GRAPE:
                return "grape";
            case BUBBLEGUM:
                return "bubblegum";
            default:
                assert_not_reached ();
        }
    }

    public static Flood.Models.Color get_random () {
        return (Flood.Models.Color) GLib.Random.int_range (0, 6);
    }

}