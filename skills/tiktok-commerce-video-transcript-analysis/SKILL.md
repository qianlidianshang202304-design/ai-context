---
name: tiktok-commerce-video-transcript-analysis
description: Use when analyzing TikTok/Tabcut/FastMoss commerce video lists for creator collaboration portraits, local TikTok video download, Whisper transcript extraction, impulse-buy quote mining, script commonality analysis, visual evidence reports, and source-data packaging. Applies to workflows that start from Excel/JSON rows with TikTok video links, creator fields, sales/views/ROAS metrics, and require audited conclusions rather than title-only guesses.
---

# TikTok Commerce Video Transcript Analysis

Use this skill for TikTok Shop / Tabcut / FastMoss creator-video analysis where the output needs to be backed by local video files, transcripts, screenshots, metrics, and an independent review.

## Core Rules

- Do not infer video content from titles alone when local video download/transcript is feasible.
- Keep metrics sourced: sales, revenue, views, likes, ROAS, rank coverage, and failure counts must trace back to the source workbook/JSON or manifest.
- Distinguish transcript types:
  - official captions, if available;
  - automatic Whisper transcript;
  - ASR-cleaned excerpt;
  - suggested reusable script.
- Do not present ASR-cleaned or translated lines as exact original quotes.
- Mark uncertain words with `[待回听确认]`.
- Health/medical-style claims from creators are evidence of messaging, not medical facts or brand claims.
- Audience labels are strategy personas, not platform demographic truth, unless backend audience data is provided.
- New creator/audience/content dictionary values are candidates only until the user explicitly confirms them.
- Run an independent review thread before final delivery; if it returns “需修改后通过”, fix the issues and run a final pass or clearly record the final verification status.

## Workflow

1. Read the source workbook/JSON and build a ranked sample list by the requested metric, usually estimated sales first.
2. Normalize each sample into:
   - rank;
   - creator handle;
   - TikTok video URL;
   - title;
   - creator type;
   - audience labels;
   - primary messaging angle;
   - sales/revenue/views/likes/ROAS.
3. Download videos with `yt-dlp`.
   - Start without proxy.
   - If needed, retry with `HTTPS_PROXY=http://127.0.0.1:7897 HTTP_PROXY=http://127.0.0.1:7897`.
   - Record failures and continue scanning until the target count is met or the source is exhausted.
4. Generate local transcripts.
   - Prefer official subtitle/caption if `yt-dlp` exposes it.
   - Otherwise use local Whisper/MLX Whisper.
   - Keep raw JSON and readable timestamped TXT.
5. Extract visual evidence.
   - Use existing screenshots/contact sheets when available.
   - For downloaded videos, extract representative frames with ffmpeg.
   - Describe only what is visible.
6. Mine script evidence.
   - Extract candidate impulse-buy sentences from transcripts.
   - Cluster into themes such as GLP warning hook, protein/muscle, collagen/hair/skin, electrolytes/nausea, all-in-one, taste/texture, deal/CTA, professional authority, family/Familismo.
   - Separate original transcript line, ASR-cleaned excerpt, and suggested reusable version.
7. Build deliverables.
   - Analysis report in Markdown or HTML.
   - Excel workbook for sample list, coverage stats, candidate quotes, reusable templates, gaps, and review record.
   - Screenshot/video evidence directory.
   - Manifest and failure JSON.
   - Independent AI review record.
   - Zip packages: light package without videos, full package with videos if size is acceptable.

## Recommended Output Structure

```
outputs/<project>/
  visual_report/
    <report>.html
    <report>.md
    assets/
  transcripts/
    topN/
      txt/
      raw_json/
      topN_transcript_manifest.json
      topN_failures.json
      topN_script_phrase_analysis.json
      topN_impulse_quote_candidates.csv
      topN_analysis.xlsx
  screenshots/
    videos/
    profiles/
  downloads/
    videos/
  review/
    independent_ai_review.md
  packages/
    *_light.zip
    *_full.zip
```

## Review Checklist

Before final answer:

- Sample count and rank coverage match the manifest.
- Every metric in the report can be traced to a source file.
- Every quoted “original/source expression” can be traced to a transcript or is clearly marked as ASR-cleaned/translated/suggested.
- Visual claims are backed by screenshots or frames.
- Audience tags are marked as strategy personas if no backend data exists.
- Candidate dictionary additions are not written into formal dictionaries without user confirmation.
- Review file states:
  - independent AI ran: yes/no;
  - review input files;
  - findings;
  - edits made;
  - remaining uncertainty.

## Arrae Reference

For a validated example of this workflow, read `references/arrae-2026-06-example.md` only when working on similar supplement/TikTok Shop creator transcript analysis.
