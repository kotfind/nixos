# SQL Style

- This applies to SQL in any context -- standalone `.sql` files as well as embedded queries in Rust, Python, or other languages.

- Put SQL keywords on separate lines. E.g.:
  ```sql
  SELECT id, name
  FROM user
  WHERE age >= 18
  ORDER BY id
  ```
