#!/usr/bin/env python3
"""
Simple command-line calculator supporting +, -, *, / and `clear`.

Usage:
  python calculator.py        # interactive mode
  python calculator.py --test # run built-in tests

Calculations logic is separated into functions for testability.
"""
import re
import sys
import os
from typing import Tuple

NUMBER_EXPR = r'([-+]?\d*\.?\d+)'
EXPR_RE = re.compile(rf'^\s*{NUMBER_EXPR}\s*([+\-*/])\s*{NUMBER_EXPR}\s*$')

def parse_expression(text: str) -> Tuple[float, str, float]:
    """Parse a simple binary expression like `12 + 3.5`.

    Returns (left, operator, right) or raises ValueError on invalid input.
    """
    m = EXPR_RE.match(text)
    if not m:
        raise ValueError("Invalid expression. Expected format: <number> <op> <number>")
    left_s, op, right_s = m.group(1), m.group(2), m.group(3)
    left = float(left_s)
    right = float(right_s)
    return left, op, right

def evaluate(a: float, op: str, b: float) -> float:
    """Evaluate a simple binary operation. Raises ZeroDivisionError for divide-by-zero."""
    if op == '+':
        return a + b
    if op == '-':
        return a - b
    if op == '*':
        return a * b
    if op == '/':
        if b == 0:
            raise ZeroDivisionError('Division by zero')
        return a / b
    raise ValueError(f'Unsupported operator: {op}')

def clear_screen() -> None:
    """Clear the terminal screen."""
    os.system('cls' if os.name == 'nt' else 'clear')

def print_help() -> None:
    print("Commands:")
    print("  Type an expression like: 12 + 3")
    print("  Supported operators: +  -  *  /")
    print("  clear  : clear the screen")
    print("  exit   : quit the program")
    print("  --test : run built-in tests and exit")

def run_tests() -> int:
    """Run basic self-tests for parsing and evaluation. Returns exit code 0 on success."""
    tests_passed = 0
    tests_total = 6
    # evaluate tests
    assert evaluate(1, '+', 2) == 3
    tests_passed += 1
    assert evaluate(5, '-', 3) == 2
    tests_passed += 1
    assert evaluate(4, '*', 2.5) == 10
    tests_passed += 1
    assert evaluate(9, '/', 3) == 3
    tests_passed += 1
    # parse tests
    a, op, b = parse_expression('  -2.5 * 4')
    assert a == -2.5 and op == '*' and b == 4
    tests_passed += 1
    # divide by zero handling
    try:
        evaluate(1, '/', 0)
    except ZeroDivisionError:
        tests_passed += 1

    print(f'Ran {tests_total} tests: {tests_passed} passed, {tests_total-tests_passed} failed')
    return 0 if tests_passed == tests_total else 1

def interactive_loop() -> None:
    print('Simple CLI Calculator')
    print_help()
    while True:
        try:
            text = input('> ').strip()
        except (EOFError, KeyboardInterrupt):
            print('\nExiting.')
            return

        if not text:
            continue
        if text.lower() in ('exit', 'quit'):
            print('Goodbye.')
            return
        if text.lower() == 'help':
            print_help()
            continue
        if text.lower() == 'clear':
            clear_screen()
            continue

        # try to parse and evaluate expression
        try:
            a, op, b = parse_expression(text)
            try:
                result = evaluate(a, op, b)
                # display integer-like floats without trailing .0
                if result == int(result):
                    print(int(result))
                else:
                    print(result)
            except ZeroDivisionError:
                print('Error: Division by zero')
        except ValueError as ve:
            print(f'Error: {ve}')

def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]
    if '--test' in argv:
        return run_tests()
    interactive_loop()
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
