# Play Store release notes

These files become the "What's new" text on the Play Store listing. They are
uploaded by the `Deploy to Play internal track` job in
`.github/workflows/build-android.yml` via the `whatsNewDirectory` input. The
`Promote to Play production` job copies the internal release — notes included —
so the same text reaches production without being retyped.

## Rules

- One file per listing language, named `whatsnew-<BCP-47 locale>` with **no
  extension** — the action derives the locale from the filename.
- Plain text only. No Markdown, no HTML.
- **500 characters maximum per file.** Play rejects the upload if any file is
  longer, which fails the release build after the AAB has already been built.
- A locale with no file simply gets no release notes; it does not fail.

## Updating

Edit these files as part of the change that they describe, so the notes land in
the same release as the work. They are read from the commit the release tag
points at, not from `main` at upload time.

The GitHub Release notes are separate: those are generated automatically from
conventional-commit messages by semantic-release. These files are the
user-facing counterpart and are written by hand.

## Current locales

| File | Play locale | App language |
| --- | --- | --- |
| `whatsnew-en-US` | English (United States) | `en` |
| `whatsnew-fr-FR` | French (France) | `fr` |
| `whatsnew-de-DE` | German (Germany) | `de` |

If a language is added to the app, add the matching file here **and** enable
that language on the Play Store listing — the action fails when it uploads
notes for a locale the listing does not have.
