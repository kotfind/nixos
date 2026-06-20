---
name: apply-rulify
description: >
  Take the output of /rulify and add it as rules
  in the claude rules directory.
---

# Applying Rulified Rules

- Confirm the working directory is the system configuration repo. If not, tell the user and stop.
- Read existing rules. Merge new content into existing sections when it extends the same topic without contradiction.
- If a new rule conflicts with an existing one, tell the user and ask for clarification before writing anything.
- Write each top-level section from the /rulify output as a new section in the matching rules file.
