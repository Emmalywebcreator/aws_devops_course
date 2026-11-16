# AWS DevOps Engineering Course

A self-contained static website (one `index.html`, no build step) for the 28-week AWS DevOps course.

## Deploy on Vercel

1. Push this folder to a GitHub repository (or run `deploy.ps1`).
2. In Vercel: **Add New → Project → Import** the repository.
3. Framework preset: **Other**. Leave the build command and output directory empty.
4. Deploy. Every later `git push` to `main` redeploys automatically.

## Updating the course

Replace `index.html` with a newly built version, commit and push.

## Notes

- Learner progress (checklists, completed parts, planner) is stored in each visitor's browser (`localStorage`), not on a server.
- Fonts load from Google Fonts; everything else is in `index.html`.
