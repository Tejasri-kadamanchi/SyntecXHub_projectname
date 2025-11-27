# Simple CLI Calculator

This repository contains a small command-line calculator that supports addition, subtraction, multiplication, division, and a `clear` command.

Usage

- Interactive mode:

```powershell
python calculator.py
```

- Run built-in tests:

```powershell
python calculator.py --test
```

Features
- Supports `+`, `-`, `*`, `/` between two numbers
- `clear` command clears the terminal
- `exit` or `quit` to leave the program
- The calculation logic is separated into `parse_expression` and `evaluate` for testability

Notes
- Invalid inputs show a helpful error message.
- Division by zero is caught and reported as an error.

Files
- `calculator.py`: the CLI and logic
# SyntecXHub_projectname