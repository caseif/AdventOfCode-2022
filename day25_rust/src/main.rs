use std::fs::File;
use std::io::{BufReader, BufRead};

const SNAFU_M2: char = '=';
const SNAFU_M1: char = '-';
const SNAFU_Z: char = '0';
const SNAFU_1: char = '1';
const SNAFU_2: char = '2';

fn snafu_to_dec(snafu: &str) -> i64 {
    let mut dec = 0i64;
    let mut exp = 0u32;
    for c in snafu.chars().rev() {
        let base = match c {
            SNAFU_M2 => -2,
            SNAFU_M1 => -1,
            SNAFU_Z => 0,
            SNAFU_1 => 1,
            SNAFU_2 => 2,
            _ => panic!("Invalid char")
        };

        dec += 5i64.pow(exp) * base;
        exp += 1;
    }

    return dec;
}

fn dec_to_snafu(dec: i64) -> String {
    let mut snafu = String::new();

    let mut remaining = dec;
    let mut exp = 0;
    while remaining > 0 {
        let digit = match (remaining % 5i64.pow(exp + 1)) / 5i64.pow(exp) {
            0 => 0,
            1 => 1,
            2 => 2,
            3 => -2,
            4 => -1,
            _ => panic!("Unexpected remainder")
        };

        snafu = match digit {
            -2 => SNAFU_M2,
            -1 => SNAFU_M1,
            0 => SNAFU_Z,
            1 => SNAFU_1,
            2 => SNAFU_2,
            _ => panic!("Unexpected digit")
        }.to_string() + &snafu;
        remaining -= digit * 5i64.pow(exp);
        exp += 1;
    }

    return snafu;
}

fn main() -> std::io::Result<()> {
    let file = File::open("input.txt")?;
    let reader = BufReader::new(file);

    let mut sum = 0i64;
    for line in reader.lines() {
        sum += snafu_to_dec(&line.unwrap());
    }

    let ans_a = dec_to_snafu(sum);

    println!("Part A: {ans_a}");

    Ok(())
}
