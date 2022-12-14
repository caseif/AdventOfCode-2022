open Printf

type assignment = {first: int; last: int}

let read_whole_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

let parse_assn assn =
  let bounds = String.split_on_char '-' assn in
  { first = int_of_string (List.nth bounds 0); last = int_of_string (List.nth bounds 1) }

let parse_assns lst =
  (parse_assn (List.nth lst 0), parse_assn (List.nth lst 1))

let rec process_lines lst =
  match lst with
  | [] -> []
  | lh :: lt -> parse_assns (String.split_on_char ',' lh) :: process_lines lt

let fully_overlaps a b =
  (a.first >= b.first && a.last <= b.last) || (b.first >= a.first && b.last <= a.last)

let overlaps a b =
  (a.first >= b.first && a.first <= b.last) || (b.first >= a.first && b.first <= a.last)

let rec get_fully_overlapping_assns lst =
  match lst with
    | [] -> []
    | lh :: lt -> if fully_overlaps (fst lh) (snd lh)
      then lh :: get_fully_overlapping_assns lt
      else get_fully_overlapping_assns lt

let rec get_overlapping_assns lst =
  match lst with
    | [] -> []
    | lh :: lt -> if overlaps (fst lh) (snd lh)
      then lh :: get_overlapping_assns lt
      else get_overlapping_assns lt

let contents = read_whole_file "input.txt";;
let lines = String.split_on_char '\n' contents;;
let pairs = process_lines lines;;

let full_overlaps = get_fully_overlapping_assns pairs;;
let overlaps = get_overlapping_assns pairs;;

printf "Part A: %d\n" (List.length full_overlaps);;
printf "Part B: %d\n" (List.length overlaps);;
