---
description: "Run a launchpad infra skill: devcontainer, kamal, caddy"
---

Read `skills/$ARGUMENTS/SKILL.md` and follow its instructions exactly.

If `$ARGUMENTS` is empty or not one of: devcontainer, kamal, caddy — respond with:

```
Usage: /launchpad:infra <skill>

Available skills:
  devcontainer   Create or update .devcontainer/
  kamal          Create or update config/deploy.yml
  caddy          Create or update Caddyfile
```
