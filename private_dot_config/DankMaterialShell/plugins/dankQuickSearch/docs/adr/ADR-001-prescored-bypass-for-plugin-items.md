# ADR-001: Use _preScored to Bypass DMS Scorer for Plugin Items

**Status:** Accepted
**Date:** 2026-04-22
**Applies to:** `DankQuickSearch.qml`

## Context

DMS's Scorer.js filters launcher items by text-matching item names/subtitles against the raw query. For trigger-activated plugins, the query passed to the Scorer is the text after the trigger character (e.g. `yt hello world` for `!yt hello world`). Plugin items whose names don't textually match this query score 0 and are filtered out.

This caused multi-character engine prefixes (`!yt`, `!gh`) to break — the prefix text (`yt`) was included in the Scorer query but didn't match the item names (e.g. "hello world"), so all results were dropped. Single-character prefixes (`!w`, `!g`) happened to pass due to fuzzy matching thresholds.

## Decision

Set `_preScored: 1000` on all items returned by `getItems()`, and `_preScored: 900` on non-selected engine alternatives. This uses DMS's built-in mechanism for plugin items to bypass text scoring entirely.

## Alternatives Considered

- **Patching DMS Scorer.js**: Would fix it at the framework level but the plugin should work with unmodified DMS. `_preScored` is the intended API.
- **Adding keywords to items**: Would require anticipating all possible query fragments. Fragile and doesn't address the fundamental mismatch.
- **Changing engine prefixes to single characters**: Would work around the bug but limits UX and doesn't fix the root cause.

## Consequences

- All engine prefixes work regardless of length.
- Plugin items always appear when the trigger is active, which is the correct behavior — the plugin's own `getItems()` already handles filtering/relevance.
- The 1000/900 scoring ensures the selected engine appears above alternatives.
