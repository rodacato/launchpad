# .notdefined.yml template
# Spec: https://github.com/rodacato/rodacato/blob/master/docs/guides/notdefined-yml-spec.md
# Copy this content to .notdefined.yml in the project root and fill in all fields.

tagline: "<!-- max 10 words -->"
description: >
  <!-- 2-4 sentences. What it does, who it's for, why it exists.
       Casual tone. First person or impersonal, never corporate. -->
version: "0.1.0"

# Uncomment when you have branding assets
# icon: docs/branding/icon.svg
# icon_dark: docs/branding/icon-dark.svg
# background_color: "#000000"   # accent primary from BRANDING.md

# Uncomment when you have screenshots
# screenshot: docs/screenshots/main.png
# screenshots:
#   - path: docs/screenshots/dashboard.png
#     alt: "Description of what's shown"

category: product       # product | utility
status: active          # active | maintenance | paused
lang: "<!-- Ruby | Python | JavaScript | Go | ... -->"
stack:
  - "<!-- primary framework -->"
  - "<!-- database or key dependency -->"
  - "<!-- other key tech -->"
tags:
  - "<!-- tag1 -->"
  - "<!-- tag2 -->"
  - "<!-- tag3 -->"

repo: https://github.com/{owner}/{repo}
# url: https://{project}.notdefined.dev
