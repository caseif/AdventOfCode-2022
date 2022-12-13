import java.io.*;
import java.lang.*;
import java.math.*;
import java.util.*;
import java.util.regex.*;
import java.util.stream.*;

public class Solve {
    private static final Pattern INIT_ITEMS_PATTERN = Pattern.compile(" +Starting items: (.*)");
    private static final Pattern OPERATION_PATTERN = Pattern.compile(" +Operation: (.*)");
    private static final Pattern DIVISOR_PATTERN = Pattern.compile(" +Test: divisible by (\\d+)");
    private static final Pattern POS_PATTERN = Pattern.compile(" +If true: throw to monkey (\\d+)");
    private static final Pattern NEG_PATTERN = Pattern.compile(" +If false: throw to monkey (\\d+)");

    private static final long ROUNDS_A = 20;
    private static final long ROUNDS_B = 10000;

    private static List<Monkey> monkeysA = new ArrayList<>();
    private static List<Monkey> monkeysB = new ArrayList<>();

    public static void main(String[] args) throws IOException {
        try (var reader = new BufferedReader(new FileReader("input.txt"))) {
            while (true) {
                var monkey = parseMonkey(reader);
                if (monkey == null) {
                    break;
                }
                monkeysA.add(monkey);
                monkeysB.add((Monkey) monkey.clone());
            }
        }

        var lcd = 1;
        for (var monkey : monkeysA) {
            lcd *= monkey.divisor;
        }

        for (long i = 0; i < ROUNDS_A; i++) {
            for (var monkey : monkeysA) {
                var res = monkey.executeRound(lcd, true);
                for (var item : res) {
                    monkeysA.get(item.targetMonkey).giveItem(item.thrownItem);
                }
            }
        }

        for (long i = 1; i <= ROUNDS_B; i++) {
            for (var monkey : monkeysB) {
                var res = monkey.executeRound(lcd, false);
                for (var item : res) {
                    monkeysB.get(item.targetMonkey).giveItem(item.thrownItem);
                }
            }
        }

        var inspectionsA = monkeysA.stream()
                .map(Monkey::getInspectionCount)
                .sorted((a, b) -> b.compareTo(a))
                .collect(Collectors.toList());
        long monkeyBusinessA = inspectionsA.get(0) * inspectionsA.get(1);

        var inspectionsB = monkeysB.stream()
                .map(Monkey::getInspectionCount)
                .sorted((a, b) -> b.compareTo(a))
                .collect(Collectors.toList());
        long monkeyBusinessB = inspectionsB.get(0) * inspectionsB.get(1);

        System.out.println("Part A: " + monkeyBusinessA);
        System.out.println("Part B: " + monkeyBusinessB);
    }

    private static Monkey parseMonkey(BufferedReader reader) throws IOException {
        // skip first line
        if (reader.readLine() == null) {
            return null;
        }

        var initItemsMatcher = INIT_ITEMS_PATTERN.matcher(reader.readLine());
        if (!initItemsMatcher.find()) {
            throw new IllegalArgumentException("Invalid input (initial items)");
        }
        var initItems = Arrays.stream(initItemsMatcher.group(1).split(", "))
                .map(s -> Long.parseLong(s))
                .collect(Collectors.toList());

        var opMatcher = OPERATION_PATTERN.matcher(reader.readLine());
        if (!opMatcher.find()) {
            throw new IllegalArgumentException("Invalid input (operation)");
        }
        var operation = Operation.parse(opMatcher.group(1));

        var divMatcher = DIVISOR_PATTERN.matcher(reader.readLine());
        if (!divMatcher.find()) {
            throw new IllegalArgumentException("Invalid input (divisor)");
        }
        var divisor = Long.parseLong(divMatcher.group(1));

        var posMatcher = POS_PATTERN.matcher(reader.readLine());
        if (!posMatcher.find()) {
            throw new IllegalArgumentException("Invalid input (positive target)");
        }
        var posTarget = Integer.parseInt(posMatcher.group(1));

        var negMatcher = NEG_PATTERN.matcher(reader.readLine());
        if (!negMatcher.find()) {
            throw new IllegalArgumentException("Invalid input (negative target)");
        }
        var negTarget = Integer.parseInt(negMatcher.group(1));

        // skip blank line
        reader.readLine();

        return new Monkey(initItems, operation, divisor, posTarget, negTarget);
    }

    private static class Monkey {
        private final Operation operation;
        private final long divisor;
        private final int posTarget;
        private final int negTarget;

        private Queue<Long> items = new ArrayDeque<>();
        private long inspections;

        public Monkey(List<Long> initialItems, Operation operation, long divisor,
                int posTarget, int negTarget) {
            for (var item : initialItems) {
                this.items.add(item);
            }

            this.operation = operation;
            this.divisor = divisor;
            this.posTarget = posTarget;
            this.negTarget = negTarget;
        }

        private List<ThrownItem> executeRound(long lcd, boolean divideWorry) {
            List<ThrownItem> thrown = new ArrayList<>();

            Long curItem;
            while ((curItem = this.items.poll()) != null) {
                long newItem = this.operation.apply(curItem);
                if (divideWorry) {
                    newItem /= 3;
                }

                newItem %= lcd;

                int targetMonkey;
                if ((newItem % this.divisor) == 0) {
                    targetMonkey = this.posTarget;
                } else {
                    targetMonkey = this.negTarget;
                }

                thrown.add(new ThrownItem(newItem, targetMonkey));

                this.inspections += 1;
            }

            return thrown;
        }

        private void giveItem(long item) {
            this.items.add(item);
        }

        private long getInspectionCount() {
            return this.inspections;
        }

        @Override
        public Object clone() {
            return new Monkey(((ArrayDeque<Long>) items).stream().collect(Collectors.toList()),
                    operation, divisor, posTarget, negTarget);
        }
    }

    private record ThrownItem(long thrownItem, int targetMonkey) { }

    private enum Operator {
        Add,
        Subtract,
        Multiply,
        Divide
    }

    private enum ValueType {
        Old,
        Constant
    }

    private static class Operation {
        private static final Pattern PARSE_PATTERN = Pattern.compile("(old|\\d+) ([+\\-*/]) (old|\\d+)");

        private final Operator operator;
        private final ValueType firstValType;
        private final ValueType secondValType;
        private final Optional<Long> firstValConst;
        private final Optional<Long> secondValConst;

        public Operation(Operator operator, ValueType firstValType, ValueType secondValType,
                Optional<Long> firstValConst, Optional<Long> secondValConst) {
            this.operator = operator;
            this.firstValType = firstValType;
            this.secondValType = secondValType;
            this.firstValConst = firstValConst;
            this.secondValConst = secondValConst;
        }

        public long apply(long curVal) {
            var firstVal = switch (firstValType) {
                case Old -> curVal;
                case Constant -> firstValConst.get();
            };

            var secondVal = switch (secondValType) {
                case Old -> curVal;
                case Constant -> secondValConst.get();
            };

            return switch (operator) {
                case Add -> firstVal + secondVal;
                case Subtract -> firstVal - secondVal;
                case Multiply -> firstVal * secondVal;
                case Divide -> firstVal / secondVal;
            };
        }

        public static Operation parse(String str) {
            var matcher = PARSE_PATTERN.matcher(str);
            if (!matcher.find()) {
                throw new IllegalArgumentException("Invalid parse pattern");
            }

            var firstValGroup = matcher.group(1);
            var operatorGroup = matcher.group(2);
            var secondValGroup = matcher.group(3);

            Optional<Long> firstValConst = Optional.empty();
            var firstValType = switch (firstValGroup) {
                case "old":
                    yield ValueType.Old;
                default:
                    firstValConst = Optional.of(Long.parseLong(firstValGroup));
                    yield ValueType.Constant;
            };

            Optional<Long> secondValConst = Optional.empty();
            var secondValType = switch (secondValGroup) {
                case "old":
                    yield ValueType.Old;
                default:
                    secondValConst = Optional.of(Long.parseLong(secondValGroup));
                    yield ValueType.Constant;
            };

            Operator operator = switch (operatorGroup) {
                case "+" -> Operator.Add;
                case "-" -> Operator.Subtract;
                case "*" -> Operator.Multiply;
                case "/" -> Operator.Divide;
                default -> throw new IllegalArgumentException("Invalid operator");
            };

            return new Operation(operator, firstValType, secondValType, firstValConst, secondValConst);
        }

        @Override
        public String toString() {
            String res = "";
            res += switch (firstValType) {
                case Old -> "old";
                case Constant -> firstValConst.get();
                default -> "???";
            };

            res += switch (operator) {
                case Add -> " + ";
                case Subtract -> " - ";
                case Multiply -> " * ";
                case Divide -> " / ";
            };

            res += switch (secondValType) {
                case Old -> "old";
                case Constant -> secondValConst.get();
                default -> "???";
            };

            return res;
        }
    }
}
