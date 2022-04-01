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

public class Flood.Widgets.GameBoard : Gtk.Grid {

    // TODO: Add some sort of border around the grid

    private int num_rows;
    private int num_cols;

    private Gee.List<Flood.Widgets.Square> squares;
    private Gee.List<int> flooded_indices;

    public Flood.Models.Color current_color { get; set; }

    public GameBoard () {
        Object (
            expand: true,
            orientation: Gtk.Orientation.VERTICAL,
            halign: Gtk.Align.CENTER,
            valign: Gtk.Align.CENTER,
            margin: 8
        );
    }

    construct {
        initialize ();
    }

    private void initialize () {
        num_rows = 14;
        num_cols = 14;

        squares = new Gee.ArrayList<Flood.Widgets.Square> ();
        flooded_indices = new Gee.ArrayList<int> ();

        setup_ui ();

        // Set the top left square as the first flooded square
        current_color = squares.get (0).color;
        flooded_indices.add (0);

        //  flood (current_color);
        update_flooded_indices ();
    }

    private void setup_ui () {
        var square_grid = new Gtk.Grid () {
            expand = true
        };

        for (int row = 0; row < num_rows; row++) {
            for (int col = 0; col < num_cols; col++) {
                Flood.Widgets.Square square = new Flood.Widgets.Square (Flood.Models.Color.get_random ());
                squares.insert (index_for_coord (row, col), square);
                square_grid.attach (square, col, row);
            }
        }

        attach (square_grid, 0, 0);        
    }

    public bool flood (Flood.Models.Color new_color) {
        current_color = new_color;
        foreach (int index in flooded_indices) {
            squares.get (index).color = new_color;
        }
        update_flooded_indices ();
        return flooded_indices.size == (num_rows * num_cols);
    }

    // This is… not ideal… but it works!
    private void update_flooded_indices () {
        Gee.Set<int> new_indices = new Gee.HashSet<int> ();
        do {
            new_indices.clear ();
            foreach (int index in flooded_indices) {
                int row = index / num_rows;
                int col = index % num_cols;
                // Look up
                int? north_neighbor_index = index_for_coord (row - 1, col);
                if (should_flood_neighbor (north_neighbor_index)) {
                    new_indices.add (north_neighbor_index);
                }
                // Look left
                int? west_neighbor_index = index_for_coord (row, col - 1);
                if (should_flood_neighbor (west_neighbor_index)) {
                    new_indices.add (west_neighbor_index);
                }
                // Look down
                int? south_neighbor_index = index_for_coord (row + 1, col);
                if (should_flood_neighbor (south_neighbor_index)) {
                    new_indices.add (south_neighbor_index);
                }
                // Look right
                int? east_neighbor_index = index_for_coord (row, col + 1);
                if (should_flood_neighbor (east_neighbor_index)) {
                    new_indices.add (east_neighbor_index);
                }
            }
            flooded_indices.add_all (new_indices);
        } while (new_indices.size > 0);
    }

    private bool should_flood_neighbor (int? neighbor_index) {
        return neighbor_index != null && !flooded_indices.contains (neighbor_index) && (squares.get (neighbor_index).color == current_color);
    }

    private int? index_for_coord (int row, int col) {
        if (row < 0 || row >= num_rows || col < 0 || col >= num_cols) {
            return null;
        }
        return col + (row * num_cols);
    }

    private bool should_restore_state () {
        return false;
    }

}