# Laura Sofia Lozano Diaz

# Sistemas de interaccion - Project #5

A basic data representation using visuals and sound

- Visually, the data is represented in rows. Each row has 4 sub-rows, consisting of 4 colors: gray, red, green and blue. Each data value is assigned a row in the following way:

1. Take a value. This value will be in row #0.
2. Take the value and apply modulus 4 (value % 4).
3. This value represents how many sub-rows there will be, assign subsequent values to the rows in increasing order.

The shades of color are represented by the value in a logarithmic way. The values are relative to the maximum value in the data sheet.

- Accoustically, each value is given a midi instrument depending of the row they are in:

1. First row (gray): piano.
2. Second row (red): ocarina.
3. Third row (green): synth drums.
4. Fourth row (blue): taiko drums.

The pitch of the note is represented by the value in a logarithmic way. The notes are assined between the values 0 and 100 (midi pitch).

There is a delay of 0.5 seconds between each column in the row.