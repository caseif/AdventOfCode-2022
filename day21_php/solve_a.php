<?php

const ROOT_ID = "root";

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

function resolveJob($id, $jobs) {
    if (!array_key_exists($id, $jobs)) {
        throw new Exception("Encountered unknown ID $id");
    }

    $job = $jobs[$id];

    if (!is_null($job->resolvedVal)) {
        return $job->resolvedVal;
    }

    $op1 = resolveJob($job->operand1, $jobs);
    $op2 = resolveJob($job->operand2, $jobs);

    switch ($job->operator) {
        case Operator::Add:
            $res = $op1 + $op2;
            break;
        case Operator::Subtract:
            $res = $op1 - $op2;
            break;
        case Operator::Multiply:
            $res = $op1 * $op2;
            break;
        case Operator::Divide:
            $res = $op1 / $op2;
            break;
    }

    $job->resolvedVal = $res;

    return $res;
}

function computeA($jobs) {
    return resolveJob(ROOT_ID, $jobs);
}

$jobs = parseJobs();

$ansA = computeA($jobs);
echo "Part A: $ansA\n";

?>
