---
name: rulify
description: >
  Review the current session for user preferences and practices
  that should be saved as reusable rules. Rephrase and group
  them for inclusion in claude rules.
---

# Rulifying Preferences

When asked to rulify preferences:

- Review what the user has asked for in this session: commit style, coding conventions, tool preferences, naming choices, workflow habits
- Focus on preferences that are reusable -- things that would apply to other projects, not one-off tasks
- Rephrase each preference to be: precise, unambiguous, well-structured (headings, lists, examples)
- Group related preferences into thematic rules files (e.g. git.md, rust.md, programming.md)
- Present the result as blocks ready to add to claude rules. Don't write them to disk unless asked.
