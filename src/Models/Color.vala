/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public enum PaintSpill.Models.Color {

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

    public static PaintSpill.Models.Color get_value_by_name (string name) {
        GLib.EnumClass enumc = (GLib.EnumClass) typeof (PaintSpill.Models.Color).class_ref ();
        unowned EnumValue? eval = enumc.get_value_by_name (name);
        if (eval == null) {
            assert_not_reached ();
        }
        return (PaintSpill.Models.Color) eval.value;
    }

    public static PaintSpill.Models.Color get_random () {
        return (PaintSpill.Models.Color) GLib.Random.int_range (0, 6);
    }

}
