LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE package_dsed IS
    CONSTANT sample_size : INTEGER := 8;

    CONSTANT c0pb : signed := "00000101"; -- 0.0000100111111011111
    CONSTANT c1pb : signed := "00011111"; -- 0.00111110000000001101
    CONSTANT c2pb : signed := "00111001"; -- 0.01110001111111110011
    CONSTANT c3pb : signed := "00011111"; -- 0.00111110000000001101
    CONSTANT c4pb : signed := "00000101"; -- 0.0000100111111011111
    CONSTANT c0pa : signed := "11111111"; -- 1.11111110000000001101
    CONSTANT c1pa : signed := "11100110"; -- 1.1100110000000001101
    CONSTANT c2pa : signed := "01001101"; -- 0.1001100111111011111
    CONSTANT c3pa : signed := "11100110"; -- 1.1100110000000001101
    CONSTANT c4pa : signed := "11111111"; -- 1.11111110000000001101

END package_dsed;