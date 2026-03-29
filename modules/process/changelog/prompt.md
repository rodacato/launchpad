# Module: changelog

## What this installs

`CHANGELOG.md` — Version history following Keep a Changelog format.
Updated every time a release is cut. Works alongside `docs/guides/releasing.md`.

## Before you start

Check if it exists:

```bash
find . -name "CHANGELOG.md" -not -path "*/.git/*"
```

Also check if there's a `releasing.md` guide:

```bash
find . -name "releasing.md" -not -path "*/.git/*"
```

---

## If CHANGELOG.md does NOT exist — Create

1. Ask: "What's the current version of this project? (e.g. 0.1.0)"
2. Ask: "Is there anything already shipped that should be in the initial entry?"
3. Create `CHANGELOG.md` using the template at `modules/process/changelog/template.md`.
   - Replace `{repo}` with the actual GitHub repo path
   - Replace `{version}` with the current version
   - Add any initial shipped changes under that version
   - Leave `[Unreleased]` empty and ready for new changes

If `docs/guides/releasing.md` doesn't exist yet, suggest running the `releasing` module next.

---

## If CHANGELOG.md already exists — Update

1. Read the current file
2. Check the template for format improvements:
   `https://raw.githubusercontent.com/rodacato/launchpad/master/modules/process/changelog/template.md`
3. Common issues to look for:
   - Missing comparison links at the bottom
   - Wrong format for `[Unreleased]` section
   - `rodacato/<!-- repo-name -->` placeholder still present
4. Fix issues, preserve all existing version history

---

## When done

Update `.launchpad/manifest.yml`:
- Add `changelog: "1.0"` under `modules:`

Then delete `LAUNCHPAD_TASK.md`.
