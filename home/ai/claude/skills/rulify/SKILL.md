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
- Skip anything already covered by existing rules. Use what you recall from the current conversation context -- don't read them from disk and don't use the claude-code memory feature.
- Rephrase each preference to be: precise, unambiguous, well-structured (headings, lists, examples)
- Group preferences into top-level sections by language or domain: General, Rust, Nix, Python, Git, etc.
- Within a section, split into subsections when a topic grows beyond its primary concern. E.g. the Rust section might have subsections for Imports, Spacing, and Formatting.
- Present the result as blocks ready to add to claude rules. Don't write them to disk unless asked.
