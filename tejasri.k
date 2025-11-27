#!/usr/bin/env python3
# Simple command-line calculator
# Save as tejasri.k (or use .py) and run with Python 3

import re
import sys
import os

# Calculation functions (kept separate for testability)
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ZeroDivisionError("division by zero")
    return a / b

# Parse free-form expressions and simple phrases into (float, op, float)
OP_MAP = {
    '+': '+', 'plus': '+',
    '-': '-', 'minus': '-',
    '*': '*', 'x': '*', 'X': '*', 'times': '*', 'into': '*', 'multiply': '*', 'multiplied': '*',
    '/': '/', '÷': '/', 'div': '/', 'divide': '/', 'division': '/', 'over': '/'
}

EXPR_RE = re.compile(r"""
    ^\s*
    (?P<a>[+-]?\d+(\.\d+)?)
    \s*(?P<op>[\+\-\*/xX÷]|[a-zA-Z]+)\s*
    (?P<b>[+-]?\d+(\.\d+)?)
    \s*$
""", re.VERBOSE)

def parse_expression(text):
    """
    Try to parse an expression like:
      "12 + 5", "3.5 into 4", "7 divide 2"
    Returns (a: float, op: str, b: float) or raises ValueError.
    """
    m = EXPR_RE.match(text)
    if not m:
        raise ValueError("Invalid expression format. Use: <number> <operator> <number>")
    a = float(m.group('a'))
    raw_op = m.group('op').strip()
    raw_op_lower = raw_op.lower()
    op = OP_MAP.get(raw_op, OP_MAP.get(raw_op_lower))
    if not op:
        raise ValueError(f"Unknown operator: '{raw_op}'")
    b = float(m.group('b'))
    return a, op, b

def evaluate(a, op, b):
    if op == '+':
        return add(a, b)
    if op == '-':
        return subtract(a, b)
    if op == '*':
        return multiply(a, b)
    if op == '/':
        return divide(a, b)
    raise ValueError(f"Unsupported operator: {op}")

# Helper to clear screen or internal accumulator
def clear_screen():
    # try to clear terminal screen in a cross-platform way
    os.system('cls' if os.name == 'nt' else 'clear')

def menu():
    print("Simple CLI Calculator")
    print("Supported operators: +, -, *, /  (also: plus, minus, into, times, divide, division)")
    print("Commands: 'expr' enter single-line expression, 'step' enter numbers & operator, 'clear', 'exit'")

def run_expression_flow():
    try:
        text = input("Enter expression (e.g. 2 + 3 or 4 into 5): ").strip()
    except (EOFError, KeyboardInterrupt):
        print()
        return
    if not text:
        print("No input provided.")
        return
    try:
        a, op, b = parse_expression(text)
        try:
            result = evaluate(a, op, b)
            print(f"Result: {result}")
        except ZeroDivisionError:
            print("Error: Division by zero is not allowed.")
    except ValueError as e:
        print(f"Input error: {e}")

def run_step_flow():
    # Get first number
    try:
        a_text = input("First number: ").strip()
        if not a_text:
            print("No number entered.")
            return
        a = float(a_text)
    except ValueError:
        print("Invalid number.")
        return
    except (EOFError, KeyboardInterrupt):
        print()
        return

    # Get operator
    try:
        op_text = input("Operator (+, -, *, / or words like plus, into): ").strip()
        if not op_text:
            print("No operator entered.")
            return
    except (EOFError, KeyboardInterrupt):
        print()
        return
    op = OP_MAP.get(op_text, OP_MAP.get(op_text.lower()))
    if not op:
        print("Unknown operator.")
        return

    # Get second number
    try:
        b_text = input("Second number: ").strip()
        if not b_text:
            print("No number entered.")
            return
        b = float(b_text)
    except ValueError:
        print("Invalid number.")
        return
    except (EOFError, KeyboardInterrupt):
        print()
        return

    try:
        result = evaluate(a, op, b)
        print(f"Result: {result}")
    except ZeroDivisionError:
        print("Error: Division by zero is not allowed.")

def main_loop():
    last_cleared = False
    while True:
        menu()
        try:
            choice = input("Choose (expr/step/clear/exit): ").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print("\nExiting.")
            break

        if choice in ('exit', 'quit', 'q'):
            print("Goodbye.")
            break
        if choice == 'expr':
            run_expression_flow()
            last_cleared = False
        elif choice == 'step':
            run_step_flow()
            last_cleared = False
        elif choice == 'clear':
            clear_screen()
            print("Cleared screen.")
            last_cleared = True
        else:
            print("Unknown command. Use 'expr', 'step', 'clear', or 'exit'.")

if __name__ == "__main__":
    main_loop()