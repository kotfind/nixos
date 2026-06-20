---
name: apply-rulify
description: >
  Take the output of /rulify and add it as rules
  in the claude rules directory.
---

# Applying Rulified Rules

- Confirm the working directory is the system configuration repo. If not, tell the user and stop.
- Read existing rules to avoid duplicates. Merge new sections into existing files when the topic matches.
- Write each top-level section from the /rulify output as a new section in the matching rules file.
