---
paths:
  - "**/*.py"
---

# Python Style

## Types

- ALWAYS annotate explicit types for:
  - Function and method parameters and return values
  - Global variables and constants
  - Class variables and instance fields

## Docstrings

- Single-line docstrings keep the quotes on the same line: `"""Summary."""`
- Multi-line docstrings put the opening and closing `"""` on their own lines:
  ```python
  """
  Summary.

  Details.
  """
  ```
- Always separate the docstring from the body with a blank line:
  ```python
  def f() -> None:
      """Summary."""

      ...
  ```
