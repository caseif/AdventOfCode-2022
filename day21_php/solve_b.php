<?php

const ROOT_ID = "root";
const HUMAN_ID = "humn";

enum JobType {
    case Constant;
    case Arith;
}

enum Operator {
    case Add;
    case Subtract;
    case Multiply;
    case Divide;
}

class Job {
    public JobType $type;
    public ?string $operand1;
    public ?string $operand2;
    public ?Operator $operator;
    public ?int $resolvedVal;
}

class Expression {
}

class Atom extends Expression {
    public float $coeff;
    public float $constVal;
    public bool $inverted;

    public function __construct($coeff, $constVal, $inverted = false) {
        $this->coeff = $coeff;
        $this->constVal = $constVal;
        $this->inverted = $inverted;
    }

    public function __toString() {
        if ($this->coeff == 0) {
            return "".$this->constVal;
        }

        $repr = $this->coeff.($this->inverted ? "/" : "")."x";
        if ($this->constVal > 0) {
            $repr = $repr." + ".$this->constVal;
        } else if ($this->constVal < 0) {
            $repr = $repr." - ".$this->constVal;
        }

        return $repr;
    }
}

class Operation extends Expression {
    public Operator $operator;
    public Expression $lhs;
    public Expression $rhs;

    public function __construct($operator, $lhs, $rhs) {
        $this->operator = $operator;
        $this->lhs = $lhs;
        $this->rhs = $rhs;
    }
}

function parseJob($line) {
    $job = new Job();

    preg_match("/^([a-z]{4}): (?:(\d+)|(?:([a-z]{4}) ([+\-*\/]) ([a-z]{4})))$/", $line, $matches);

    $id = $matches[1];

    if (count($matches) == 3) {
        $job->type = JobType::Constant;
        $job->resolvedVal = intval($matches[2]);
        $id = $matches[1];
        $constVal = $matches[2];
    } else {
        $job->type = JobType::Arith;
        $job->resolvedVal = null;
        $job->operand1 = $matches[3];
        $job->operand2 = $matches[5];

        $op1 = $matches[3];
        $op2 = $matches[5];

        switch ($matches[4]) {
            case "+":
                $job->operator = Operator::Add;
                break;
            case "-":
                $job->operator = Operator::Subtract;
                break;
            case "*":
                $job->operator = Operator::Multiply;
                break;
            case "/":
                $job->operator = Operator::Divide;
                break;
        }
    }

    return [$id, $job];
}

function parseJobs() {
    $jobs = [];

    $handle = fopen("input.txt", "r");
    while (($line = fgets($handle)) !== false) {
        $parsed = parseJob($line);
        $jobs[$parsed[0]] = $parsed[1];
    }
    fclose($handle);

    return $jobs;
}

function convertToExpr($id, $jobs) {
    if (!array_key_exists($id, $jobs)) {
        throw new Exception("Encountered unknown ID $id");
    }

    $job = $jobs[$id];

    if ($id == HUMAN_ID) {
        return new Atom(1, 0, false); // return algebraic term "x"
    }

    if (!is_null($job->resolvedVal)) {
        return new Atom(0, $job->resolvedVal); // return constant
    }

    $lhs = convertToExpr($job->operand1, $jobs);
    $rhs = convertToExpr($job->operand2, $jobs);

    return new Operation($job->operator, $lhs, $rhs);
}

function simplifyAddition($lhs, $rhs) {
    // basically just add the constant terms of both atoms together
    if ($lhs->coeff != 0) {
        return new Atom($lhs->coeff, $lhs->constVal + $rhs->constVal, $lhs->inverted);
    } else if ($rhs->coeff != 0) {
        return new Atom($rhs->coeff, $rhs->constVal + $lhs->constVal, $rhs->inverted);
    } else {
        return new Atom(0, $lhs->constVal + $rhs->constVal);
    }
}

function simplifyMultiplication($lhs, $rhs) {
    // use the distributive property to multiply the coefficient and constant terms
    // of the algebraic side with the constant term of the non-algebraic side
    if ($lhs->coeff != 0) {
        return new Atom($lhs->coeff * $rhs->constVal, $lhs->constVal * $rhs->constVal, $lhs->inverted);
    } else if ($rhs->coeff != 0) {
        return new Atom($rhs->coeff * $lhs->constVal, $rhs->constVal * $lhs->constVal, $rhs->inverted);
    } else {
        return new Atom(0, $lhs->constVal * $rhs->constVal);
    }
}

function simplifySubtraction($lhs, $rhs) {
    if ($lhs->coeff != 0) {
        // rewrite (ax + b) - C as (ax + b) + (-C)
        return simplifyAddition($lhs, new Atom(0, $rhs->constVal * -1));
    } else if ($rhs->coeff != 0) {
        // rewrite C - (ax + b) as C + ((ax + b) * -1)
        return simplifyAddition($lhs, simplifyMultiplication($rhs, new Atom(0, -1)));
    } else {
        return new Atom(0, $lhs->constVal - $rhs->constVal);
    }
}

function simplifyDivision($lhs, $rhs) {
    if ($lhs->coeff != 0) {
        // rewrite (ax + b) / C as (ax + b) * (1 / C)
        return simplifyMultiplication($lhs, new Atom(0, 1 / (float) $rhs->constVal));
    } else if ($rhs->coeff != 0) {
        // rewrite C / (ax + b) as C * ((C / a)x^(-1) + (C / b))
        return simplifyMultiplication(new Atom($lhs->constVal / (float) $rhs->coeff,
                $lhs->constVal / (float) $rhs->constVal, !$rhs->inverted));
    } else {
        return new Atom(0, $lhs->constVal / (float) $rhs->constVal);
    }
}

function simplify($expr) {
    if ($expr instanceof Atom) {
        return $expr;
    } else {
        $oper = $expr->operator;
        $lhs = simplify($expr->lhs);
        $rhs = simplify($expr->rhs);

        switch ($oper) {
            case Operator::Add:
                return simplifyAddition($lhs, $rhs);
            case Operator::Subtract:
                return simplifySubtraction($lhs, $rhs);
            case Operator::Multiply:
                return simplifyMultiplication($lhs, $rhs);
            case Operator::Divide:
                return simplifyDivision($lhs, $rhs);
            default:
                throw new Exception("Unknown operator");
        }
    }
}

function computeB($jobs) {
    $rootJob = $jobs[ROOT_ID];
    $lTree = convertToExpr($rootJob->operand1, $jobs);
    $rTree = convertToExpr($rootJob->operand2, $jobs);

    $lAtom = simplify($lTree);
    $rAtom = simplify($rTree);

    if ($lAtom->coeff != 0) {
        $ansB = ($rAtom->constVal - $lAtom->constVal) / $lAtom->coeff;
        if ($lAtom->inverted) {
            $ansB = 1 / (float) $ansB;
        }
    } else {
        $ansB = ($lAtom->constVal - $rAtom->constVal) / $rAtom->coeff;
        if ($rAtom->inverted) {
            $ansB = 1 / (float) $ansB;
        }
    }

    return $ansB;
}

$jobs = parseJobs();

$ansB = computeB($jobs);
echo "Part B: $ansB\n";

?>
