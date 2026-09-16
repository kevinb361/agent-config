---
version: alpha
name: Default Interface
description: Low-light operational design baseline for AI-generated tools, dashboards, consoles, diagrams, and UI mockups.

colors:
  background: "#0A0D0B"
  background-elevated: "#0D1117"
  surface: "#111511"
  surface-raised: "#161B22"
  surface-card: "#1C2128"
  border: "#263026"
  border-strong: "#30363D"
  text: "#D8E0D5"
  text-muted: "#A8B995"
  text-dim: "#6F7A70"
  text-bright: "#F0F6EC"
  primary: "#8FAF6A"
  primary-bright: "#B8D989"
  secondary: "#6F9A9A"
  warning: "#C79545"
  warning-bright: "#D6A24A"
  danger: "#A3473E"
  danger-bright: "#D86A5D"
  info: "#58A6FF"
  purple: "#9F7AEA"
  ok: "#8FAF6A"
  offline: "#5F6B60"

typography:
  headline-lg:
    fontFamily: Inter, Geist, IBM Plex Sans, system-ui, sans-serif
    fontSize: 28px
    fontWeight: 650
    lineHeight: 1.15
    letterSpacing: "-0.02em"
  headline-md:
    fontFamily: Inter, Geist, IBM Plex Sans, system-ui, sans-serif
    fontSize: 20px
    fontWeight: 650
    lineHeight: 1.25
    letterSpacing: "-0.01em"
  body-md:
    fontFamily: Inter, Geist, IBM Plex Sans, system-ui, sans-serif
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.5
  body-sm:
    fontFamily: Inter, Geist, IBM Plex Sans, system-ui, sans-serif
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.45
  label-md:
    fontFamily: Inter, Geist, IBM Plex Sans, system-ui, sans-serif
    fontSize: 12px
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: "0.02em"
  telemetry:
    fontFamily: JetBrains Mono, IBM Plex Mono, SFMono-Regular, Consolas, monospace
    fontSize: 12px
    fontWeight: 500
    lineHeight: 1.35
  code-md:
    fontFamily: JetBrains Mono, IBM Plex Mono, SFMono-Regular, Consolas, monospace
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.45

rounded:
  none: 0px
  xs: 3px
  sm: 4px
  md: 6px
  lg: 8px
  xl: 12px
  full: 9999px

spacing:
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  xxl: 32px
  page: 16px
  panel: 12px
  gutter: 16px

components:
  page:
    backgroundColor: "{colors.background}"
    textColor: "{colors.text}"
  panel:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    rounded: "{rounded.md}"
    padding: 12px
  card:
    backgroundColor: "{colors.surface-card}"
    textColor: "{colors.text}"
    rounded: "{rounded.md}"
    padding: 12px
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.background}"
    rounded: "{rounded.sm}"
    padding: 8px
  button-primary-hover:
    backgroundColor: "{colors.primary-bright}"
  button-secondary:
    backgroundColor: "{colors.surface-raised}"
    textColor: "{colors.text}"
    rounded: "{rounded.sm}"
    padding: 8px
  button-danger:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.text-bright}"
    rounded: "{rounded.sm}"
    padding: 8px
  badge-ok:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.background}"
    rounded: "{rounded.full}"
    padding: 4px
  badge-warning:
    backgroundColor: "{colors.warning}"
    textColor: "{colors.background}"
    rounded: "{rounded.full}"
    padding: 4px
  badge-danger:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.text-bright}"
    rounded: "{rounded.full}"
    padding: 4px
  input:
    backgroundColor: "{colors.surface-raised}"
    textColor: "{colors.text}"
    rounded: "{rounded.sm}"
    padding: 8px
---

# Default Interface

## Overview

This is the default visual baseline for AI-generated interfaces when a project does not define its own DESIGN.md. It is not a brand campaign. It is an operating surface: low-light, quiet, inspectable, and built for tools that may be used while debugging real systems.

The feel should be closer to a durable cockpit, terminal, observability panel, or self-hosted ops console than a glossy SaaS landing page. Prefer boring foundations with carefully chosen accents. The common path should be obvious. Dangerous actions should be visually explicit and hard to trigger accidentally.

Use this baseline for Hermes-related UI, ops-console-style dashboards, agent cockpits, control panels, status pages, technical docs, diagrams, and prototypes unless a project-local design file overrides it.

## Colors

The palette is dark graphite with moss/phosphor instrumentation and warm amber caution lights.

- **Background (`#0A0D0B`, `#0D1117`):** near-black graphite surfaces for low-light use. Avoid pure black unless a terminal/canvas needs it.
- **Surfaces (`#111511`, `#161B22`, `#1C2128`):** quiet layers for panels, cards, menus, filters, and table regions.
- **Borders (`#263026`, `#30363D`):** structure through thin separators, not heavy decoration.
- **Text (`#D8E0D5`, `#F0F6EC`):** readable off-white/gray-green. Muted text should stay readable on laptop screens; do not make metadata decorative and illegible.
- **Primary (`#8FAF6A`, `#B8D989`):** moss/phosphor accent for primary actions, live state, selected nav, and active instrumentation.
- **Secondary (`#6F9A9A`):** restrained cyan/teal for labels, links, and secondary telemetry.
- **Warning (`#C79545`, `#D6A24A`):** amber caution for degraded states, pending attention, and confirmation prompts.
- **Danger (`#A3473E`, `#D86A5D`):** muted red for destructive actions, critical incidents, and failed checks.
- **Info (`#58A6FF`) and purple (`#9F7AEA`):** optional secondary chart/status colors. Use sparingly.

Do not use visible RGB gamer gradients, candy neon, rainbow status palettes, or decorative glow. Any glow should read as instrumentation, not nightlife.

## Typography

Use a modern system sans stack for interface text and a real monospace for code, logs, counters, timestamps, hostnames, IDs, traces, and metrics.

Headlines should be compact and functional, usually 20-28px. Avoid huge marketing typography unless the task is explicitly a landing page. Body text should default around 14px for dashboards and 16px for long-form reading.

Labels can be small and slightly technical, but they must remain readable. Monospace is for precision and scanning, not for making everything look like a fake terminal.

## Layout

Default to operational density: enough information to debug without scrolling through luxury whitespace, but not a wall of undifferentiated boxes.

Use clear lanes:
- top-level navigation grouped by task area
- summary/status region first
- filters and controls close to the thing they affect
- tables/logs/events as first-class views
- detail panels for inspection
- destructive or irreversible controls separated from routine controls

Use a 4/8px-derived spacing rhythm. Favor 12-16px panel padding for dashboards. Use 24-32px only for major page breaks or reading layouts. Keep page width constrained for prose, but allow dashboards and tables to use available width when it improves scanning.

## Elevation & Depth

Prefer flat tonal layering over heavy shadows. Depth should come from surface color, borders, grouping, and hierarchy.

Shadows may be used for menus, popovers, and overlays, but keep them dark, soft, and functional. Avoid floating-card soup. If everything is elevated, nothing is.

## Shapes

Use modest radii: 4px for controls, 6px for panels, 8px for larger containers, full radius only for badges/pills. The shape language should feel durable and engineered, not bubbly.

Avoid mixing aggressively rounded consumer-app shapes with sharp technical tables in the same screen. Pick one controlled shape system and hold it.

## Components

Navigation should be quiet and persistent. Active items use tonal elevation or moss accent, not loud color blocks.

Cards and panels should have clear borders and compact headings. A card must earn its existence; use tables, lists, logs, or plain sections when those communicate better.

Buttons:
- Primary: moss/phosphor; one obvious primary action per region.
- Secondary: graphite/slate; common low-risk actions.
- Warning: amber; caution, pending, degraded, or confirmation states.
- Destructive: muted red; visually separated and usually requires confirmation.

Status badges should be calm but unambiguous:
- OK/live/healthy: moss.
- Warning/degraded/pending: amber.
- Critical/failed/destructive: muted red.
- Offline/unknown/disabled: gray-green/slate.

Tables and logs are important. Make them dense, readable, sortable-looking, and friendly to scanning. Preserve timestamps, hostnames, severities, IDs, and source labels. Use monospace selectively for data columns.

Charts should use muted colors and a small number of series. Highlight the thing that matters; do not make every line equally loud. Prefer clear labels over cute legends.

Forms should be plain, compact, and explicit. Inputs need visible borders and usable focus states. Dangerous form submissions need friction.

For Discord/chat-facing UI, keep interactions snappy and concise. Avoid giant embeds unless the data actually needs it.

## Do's and Don'ts

- Do make live state, source, severity, and recency obvious.
- Do make the common path obvious and the dangerous path explicit.
- Do favor inspectable tables, logs, diffs, and runbook links over decorative dashboards.
- Do use dark graphite, moss, amber, and muted red as the core visual language.
- Do verify contrast, especially muted text on dark surfaces.
- Do design for laptop readability over perfect desktop-monitor aesthetics.
- Do use animations only for state changes, progress, or live updates.
- Don't create flashy SaaS sludge: giant gradients, fake glass, random blobs, or neon confetti.
- Don't hide critical actions behind ambiguous icons or clever gestures.
- Don't over-round, over-shadow, or over-animate.
- Don't use more than one loud accent in the same region.
- Don't make charts pretty at the expense of diagnosis.
- Don't expose every knob equally; curate defaults and group scary controls separately.
- Don't make a UI feel friendly by making it vague. Clarity is the friendly part.
