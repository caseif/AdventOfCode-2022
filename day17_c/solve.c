#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const size_t AREA_WIDTH = 7;

const unsigned int SPAWN_PADDING_H = 2;
const unsigned int SPAWN_PADDING_V = 3;

const unsigned int TILE_TYPES_COUNT = 5;

const size_t PART_A_TILES = 2022;
const size_t PART_B_TILES = 1000000000000;

typedef struct Pos {
    unsigned int x;
    unsigned int y;
} pos_t;

typedef struct Shape {
    const pos_t *tiles;
    size_t tile_count;
} shape_t;

const pos_t SHAPE_H_LINE[] = { {0, 0}, {1, 0}, {2, 0}, {3, 0} }; // horizontal line
const pos_t SHAPE_CROSS[] = { {1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2} }; // cross
const pos_t SHAPE_BW_L[] = { {0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2} }; // backwards L
const pos_t SHAPE_V_LINE[] = { {0, 0}, {0, 1}, {0, 2}, {0, 3} }; // vertical line
const pos_t SHAPE_SQUARE[] = { {0, 0}, {1, 0}, {0, 1}, {1, 1} }; // square
const shape_t SHAPES[] = {
    { SHAPE_H_LINE, sizeof(SHAPE_H_LINE) / sizeof(pos_t) },
    { SHAPE_CROSS, sizeof(SHAPE_CROSS) / sizeof(pos_t) },
    { SHAPE_BW_L, sizeof(SHAPE_BW_L) / sizeof(pos_t) },
    { SHAPE_V_LINE, sizeof(SHAPE_V_LINE) / sizeof(pos_t) },
    { SHAPE_SQUARE, sizeof(SHAPE_SQUARE) / sizeof(pos_t) }
};

static unsigned int g_next_shape = 0;
static unsigned int g_cur_height = 0;
static pos_t g_cur_shape_tiles[5];
static size_t g_cur_shape_tile_count;

static unsigned char g_rows[1024 * 1024 * 64]; // 64 MiB, this space is required for part B

static char g_input_str[16384];
static size_t g_input_len;
static size_t g_cur_in_off = 0;

const shape_t get_next_shape(void) {
    const shape_t shape = SHAPES[g_next_shape++];
    if (g_next_shape == sizeof(SHAPES) / sizeof(shape_t)) {
        g_next_shape = 0;
    }
    return shape;
}

void spawn_next_shape(void) {
    const shape_t next_shape = get_next_shape();

    g_cur_shape_tile_count = next_shape.tile_count;

    unsigned int spawn_row = g_cur_height + SPAWN_PADDING_V;
    unsigned int spawn_col = SPAWN_PADDING_H;

    for (unsigned int i = 0; i < next_shape.tile_count; i++) {
        pos_t tile = next_shape.tiles[i];

        if (tile.y + spawn_row > sizeof(g_rows) / sizeof(char)) {
            printf("Tower exceeded maximum height\n");
            exit(1);
        }

        g_cur_shape_tiles[i].x = tile.x + spawn_col;
        g_cur_shape_tiles[i].y = tile.y + spawn_row;
    }
}

bool is_pos_occupied(pos_t pos) {
    return (g_rows[pos.y] >> pos.x) & 1;
}

void set_pos_occupied(pos_t pos) {
    g_rows[pos.y] |= (1 << pos.x);
}

void shift_cur_shape(void) {
    bool move_right = g_input_str[g_cur_in_off] == '>';
    g_cur_in_off += 1;
    if (g_cur_in_off >= g_input_len) {
        g_cur_in_off = 0;
    }

    for (size_t i = 0; i < g_cur_shape_tile_count; i++) {
        pos_t tile = g_cur_shape_tiles[i];

        if (tile.x == (move_right ? (AREA_WIDTH - 1) : 0)) {
            return;
        }

        pos_t new_pos = { tile.x + (move_right ? 1 : -1), tile.y };

        if (is_pos_occupied(new_pos)) {
            return;
        }
    }

    for (size_t i = 0; i < g_cur_shape_tile_count; i++) {
        g_cur_shape_tiles[i].x += (move_right ? 1 : -1);
    }
}

bool drop_cur_shape(void) {
    for (size_t i = 0; i < g_cur_shape_tile_count; i++) {
        pos_t tile = g_cur_shape_tiles[i];

        if (tile.y == 0) {
            return true;
        }

        pos_t new_pos = { tile.x, tile.y - 1 };

        if (is_pos_occupied(new_pos)) {
            return true;
        }
    }

    for (size_t i = 0; i < g_cur_shape_tile_count; i++) {
        g_cur_shape_tiles[i].y -= 1;
    }

    return false;
}

void place_cur_shape(void) {
    unsigned int min_y = 10000000;
    unsigned int max_y = 0;
    for (size_t i = 0; i < g_cur_shape_tile_count; i++) {
        set_pos_occupied(g_cur_shape_tiles[i]);

        unsigned int tile_y = g_cur_shape_tiles[i].y;
        if (g_cur_height == 0 || tile_y > g_cur_height - 1) {
            g_cur_height = tile_y + 1;
        }

        if (tile_y < min_y) {
            min_y = tile_y;
        }
        if (tile_y > max_y) {
            max_y = tile_y;
        }
    }
}

void load_input(void) {
    FILE *in_file = fopen("input.txt", "rb");

    if (!in_file) {
        printf("Failed to open input file\n");
        exit(1);
    }

    fseek(in_file, 0, SEEK_END);
    g_input_len = ftell(in_file);

    if (g_input_len > sizeof(g_input_str) - 1) {
        printf("Input file is too large\n");
        exit(1);
    }

    fseek(in_file, 0, SEEK_SET);
    fread(g_input_str, g_input_len, 1, in_file);

    fclose(in_file);

    g_input_str[g_input_len] = '\0';
}

unsigned long long run_sim(size_t tiles, bool resume) {
    if (!resume) {
        g_cur_height = 0;
        g_next_shape = 0;
        g_cur_in_off = 0;
        memset(g_rows, 0, sizeof(g_rows));
    }

    for (unsigned long long i = 0; i < tiles; i++) {
        spawn_next_shape();
        do {
            shift_cur_shape();
        } while (!drop_cur_shape());
        place_cur_shape();
    }

    return g_cur_height;
}

unsigned long long run_part_a(void) {
    return run_sim(PART_A_TILES, false);
}

unsigned long long run_part_b(void) {
    unsigned long long lcd = g_input_len * TILE_TYPES_COUNT;
    unsigned long long interval = 348;

    unsigned long long initial = run_sim(lcd, false);
    unsigned long long subseq = run_sim(lcd * interval, true) - initial;
    unsigned long long rem = run_sim((PART_B_TILES - lcd) % (lcd * interval), true) - subseq - initial;

    unsigned long long ans = initial + (subseq * ((PART_B_TILES - lcd) / (lcd * interval))) + rem;

    return ans;
}


int main(int argc, char **argv) {
    load_input();

    unsigned long long ans_a = run_part_a();
    unsigned long long ans_b = run_part_b();

    printf("Part A: %llu\n", ans_a);
    printf("Part B: %llu\n", ans_b);

    return 0;
}