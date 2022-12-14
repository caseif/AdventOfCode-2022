ASCII_UPPER_A = 65;
ASCII_LOWER_A = 97;
ASCII_UPPER_Z = 90;

PRIORITY_UPPER_OFF = 27;
PRIORITY_LOWER_OFF = 1;

contents = fileread("input.txt");
lines = strsplit(contents, "\n");

sum_a = 0;
for line_cell = lines
    line = line_cell{1, 1};
    line_len = length(line);

    comp_1 = char(substr(line, 1, line_len / 2));
    comp_2 = char(substr(line, line_len / 2 + 1, line_len / 2));

    shared = intersect(comp_1, comp_2)(1);
    if shared <= ASCII_UPPER_Z
        priority = shared - ASCII_UPPER_A + PRIORITY_UPPER_OFF;
    else
        priority = shared - ASCII_LOWER_A + PRIORITY_LOWER_OFF;
    end

    sum_a += priority;
end

sum_b = 0;
for off = 1:3:length(lines)
    line_1 = lines(off){1, 1};
    line_2 = lines(off + 1){1, 1};
    line_3 = lines(off + 2){1, 1};

    shared = intersect(intersect(line_1, line_2), line_3)(1);
    if shared <= ASCII_UPPER_Z
        priority = shared - ASCII_UPPER_A + PRIORITY_UPPER_OFF;
    else
        priority = shared - ASCII_LOWER_A + PRIORITY_LOWER_OFF;
    end

    sum_b += priority;
end

printf("Part A: %d\n", sum_a);
printf("Part B: %d\n", sum_b);
