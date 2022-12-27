using System.Collections;

readonly record struct State(uint X, uint Y, uint TimeStep) {
    public override int GetHashCode() {
        var hc = Tuple.Create(X, Y, TimeStep).GetHashCode();
        return hc;
    }
}

class Solve {
    const int KB_BYTES = 1024;
    const int MB_BYTES = KB_BYTES * 1024;
    const int GB_BYTES = MB_BYTES * 1024;

    static Dictionary<uint, List<(uint, bool)>> _rowBlizzards = new Dictionary<uint, List<(uint, bool)>>();
    static Dictionary<uint, List<(uint, bool)>> _colBlizzards = new Dictionary<uint, List<(uint, bool)>>();

    static uint _mapWidth;
    static uint _mapHeight;

    static void ProcessInput() {
        var lines = File.ReadLines("input.txt");

        _mapWidth = (uint) lines.First().Count() - 2;
        _mapHeight = (uint) lines.Count() - 2;

        var lcd = _mapWidth * _mapHeight;

        uint readY = 0;
        foreach (var line in lines) {
            if (line[2] == '#') {
                continue;
            }

            _rowBlizzards.Add(readY, new List<(uint, bool)>());

            uint readX = 0;

            foreach (var c in line.ToCharArray()) {
                if (c == '#') {
                    continue;
                }

                if (!_colBlizzards.ContainsKey(readX)) {
                    _colBlizzards.Add(readX, new List<(uint, bool)>());
                }

                switch (c) {
                    case '^': {
                        _colBlizzards[readX].Add((readY, true));
                        break;
                    }
                    case 'v': {
                        _colBlizzards[readX].Add((readY, false));
                        break;
                    }
                    case '<': {
                        _rowBlizzards[readY].Add((readX, true));
                        break;
                    }
                    case '>': {
                        _rowBlizzards[readY].Add((readX, false));
                        break;
                    }
                }

                readX++;
            }
            readY++;
        }
    }

    static bool HasBlizzard(State state) {
        var x = state.X;
        var y = state.Y;
        var timeStep = state.TimeStep;

        if (x == 0 || y == 0 || x > _mapWidth || y > _mapHeight) {
            return false;
        }

        return _rowBlizzards[y - 1].Contains((((x - 1 - (timeStep % _mapWidth)) + _mapWidth) % _mapWidth, false))
            || _rowBlizzards[y - 1].Contains(((x - 1 + (timeStep % _mapWidth)) % _mapWidth, true))
            || _colBlizzards[x - 1].Contains((((y - 1 - (timeStep % _mapHeight)) + _mapHeight) % _mapHeight, false))
            || _colBlizzards[x - 1].Contains(((y - 1 + (timeStep % _mapHeight)) % _mapHeight, true));
    }

    static uint DistFromGoal(State state, (uint, uint) goal) {
        return (uint) (Math.Abs(goal.Item1 - state.X) + Math.Abs(goal.Item2 - state.Y));
    }

    static uint FindPath(State initialState, (uint, uint) goal) {
        uint bestPath = uint.MaxValue;

        Dictionary<State, uint> gScores = new Dictionary<State, uint>();
        Dictionary<State, State> cameFrom = new Dictionary<State, State>();
        PriorityQueue<State, uint> queue = new PriorityQueue<State, uint>();

        queue.Enqueue(initialState, DistFromGoal(initialState, goal));
        gScores[initialState] = 0;

        var lcd = _mapWidth * _mapHeight;

        while (queue.Count > 0) {
            var curState = queue.Dequeue();

            if (curState.X == goal.Item1 && curState.Y == goal.Item2) {
                var bestRoute = new List<State> { curState };

                var node = curState;
                while (cameFrom.ContainsKey(node)) {
                    node = cameFrom[node];
                    bestRoute.Insert(0, node);
                }

                bestPath = (uint) bestRoute.Count();

                return (uint) bestRoute.Count();
            }

            var newTime = (curState.TimeStep + 1) % lcd;

            var leftState = new State(curState.X - 1, curState.Y, newTime);
            var rightState = new State(curState.X + 1, curState.Y, newTime);
            var upState = new State(curState.X, curState.Y - 1, newTime);
            var downState = new State(curState.X, curState.Y + 1, newTime);
            var stillState = new State(curState.X, curState.Y, newTime);

            List<State> possibleMoves = new List<State>();

            // try moving right
            if (curState.Y > 0 && curState.X < _mapWidth && !HasBlizzard(rightState)) {
                possibleMoves.Add(rightState);
            }

            // try moving down
            if (curState.X > 0 && curState.Y < _mapHeight && !HasBlizzard(downState)) {
                possibleMoves.Add(downState);
            }

            // try moving left
            if (curState.Y > 0 && curState.X > 1 && !HasBlizzard(leftState)) {
                possibleMoves.Add(leftState);
            }

            // try moving up
            if (curState.X > 0 && curState.Y > 1 && !HasBlizzard(upState)) {
                possibleMoves.Add(upState);
            }

            // trying standing still
            if (!HasBlizzard(stillState)) {
                possibleMoves.Add(stillState);
            }

            foreach (var move in possibleMoves) {
                var tentGScore = gScores[curState] + 1;
                if (!gScores.ContainsKey(move) || tentGScore < gScores[move]) {
                    gScores[move] = tentGScore;
                    cameFrom[move] = curState;
                    queue.Enqueue(move, tentGScore + DistFromGoal(move, goal));
                }
            }
        }

        return bestPath;
    }

    static void Main(String[] args) {
        ProcessInput();

        var initialState1 = new State(1, 0, 0);
        var minPath = FindPath(initialState1, (_mapWidth, _mapHeight));

        var ansA = minPath;
        Console.WriteLine($"Part A: {ansA}");

        var lcd = _mapWidth * _mapHeight;

        var initialState2 = new State(_mapWidth, _mapHeight + 1, minPath % lcd);
        var minPathBack = FindPath(initialState2, (1, 1));

        var initialState3 = new State(1, 0, (minPath + minPathBack) % lcd);
        var minPathBackAgain = FindPath(initialState3, (_mapWidth, _mapHeight));

        var ansB = minPath + minPathBack + minPathBackAgain;

        Console.WriteLine($"Part B: {ansB}");
    }
}
