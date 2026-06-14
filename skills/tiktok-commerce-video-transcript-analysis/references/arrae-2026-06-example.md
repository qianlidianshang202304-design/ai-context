# Arrae 2026-06 TikTok Commerce Transcript Analysis Example

Validated project path:

`/Users/kingdom/codex/outputs/arrae_brand_creator_profile_analysis`

## Source And Sample

- Source dataset: `data/v2/videos.json`, derived from `arrae 近90天带货视频情况.xlsx`.
- Final transcript sample: 50 local videos + 50 local automatic transcripts.
- Rank coverage: source sales rank 1-51, with rank 20 skipped because TikTok required login; rank 51 filled the sample.
- Sample totals: 12,232 sales and 12,038,184 views.
- Transcript model: `mlx-community/whisper-tiny`.
- Key caveat: Whisper tiny is not official caption data; Spanish and fast speech need human audio review before formal script reuse.

## Main Findings

- Arrae high-performing scripts sell a GLP support stack, not generic protein powder.
- Dominant angle: `GLP1 Companion/Side Effects` with 31/50 videos.
- Most repeated script chain:
  1. GLP warning hook;
  2. protein for muscle;
  3. electrolytes for nausea/headache/hydration;
  4. collagen for hair/skin;
  5. all-in-one packet;
  6. taste/texture relief;
  7. TikTok Shop deal CTA.

## Pattern Coverage

- Protein / muscle protection: 47/50
- Collagen / hair / skin: 44/50
- Electrolytes / nausea / hydration: 43/50
- Price / deal / urgency CTA: 39/50
- Taste / texture barrier removal: 37/50
- GLP side effects / warning hook: 35/50
- All-in-one / convenience: 26/50
- Personal journey / social proof: 24/50

## Candidate Angles Not Yet In Formal Dictionary

Do not add these to the formal content-angle dictionary without user confirmation:

- `Texture / No Thick Shake Experience`
- `All-in-one Supplement Stack Value`
- `Professional GLP Routine Support`

## Quote Handling Lessons

- Do not label ASR-cleaned lines as exact original quotes.
- Use columns such as `Source expression`, `Source status`, and `Suggested reusable version`.
- For Spanish:
  - keep ASR raw line when uncertain;
  - mark `[待回听确认]`;
  - put polished Spanish in suggested reusable version, not original quote.

## Review Outcome

- Independent review thread Archimedes returned `需修改后通过`.
- Fixes made:
  - changed “原素材句” to “来源表达”;
  - added rank/creator/source status;
  - marked ASR-cleaned and Spanish-unstable lines;
  - added audience strategy-persona boundary;
  - added health-claim boundary;
  - added final review sheet to Excel.
- Final review thread Carver returned `通过`.
