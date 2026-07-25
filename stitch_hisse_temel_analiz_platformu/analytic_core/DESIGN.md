---
name: Analytic Core
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#45464d'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#76777d'
  outline-variant: '#c6c6cd'
  surface-tint: '#565e74'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#131b2e'
  on-primary-container: '#7c839b'
  inverse-primary: '#bec6e0'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#40000d'
  on-tertiary-container: '#f23d5c'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae2fd'
  primary-fixed-dim: '#bec6e0'
  on-primary-fixed: '#131b2e'
  on-primary-fixed-variant: '#3f465c'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffdadb'
  tertiary-fixed-dim: '#ffb2b7'
  on-tertiary-fixed: '#40000d'
  on-tertiary-fixed-variant: '#92002a'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-ticker:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 30px
    fontWeight: '600'
    lineHeight: 38px
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  data-tabular:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 4px
  container-padding: 24px
  gutter: 16px
  card-gap: 20px
  section-margin: 40px
---

## Brand & Style

The design system is engineered for high-density information processing and professional-grade financial scrutiny. It targets fundamental analysts and institutional investors who require clarity over decoration. 

The aesthetic is **Modern Minimalist with a focus on Data-Utilitarianism**. By utilizing a card-based architecture, the design system organizes disparate data points—such as PEG ratios, revenue growth, and debt-to-equity—into digestible, modular units. The interface avoids the "lifestyle" tropes of consumer fintech, instead opting for a "terminal-lite" experience that feels reliable, objective, and precise. 

Key visual principles include:
- **Rigid Information Hierarchy:** Critical metrics are prioritized through scale and weight, never through loud colors.
- **Intentional Whitespace:** Generous internal padding within data cards to prevent cognitive overload during deep-dive sessions.
- **Functional Transparency:** Using subtle borders and tonal shifts rather than heavy shadows to maintain a flat, professional profile.

## Colors

The palette is anchored in **Slate and Deep Sea** tones to evoke stability and institutional trust. 

- **Primary (#0F172A):** A deep navy used for text, primary navigation, and high-emphasis icons.
- **Success/Positive (#10B981):** A professional emerald green for positive percentage changes, "Buy" signals, and healthy fundamental metrics.
- **Danger/Negative (#F43F5E):** A refined rose-red for "Sell" signals, negative growth, or risk indicators.
- **Surface Neutrals:** Use a range of slate grays (from #F8FAFC for backgrounds to #64748B for secondary text) to create a sophisticated layering system without introducing hue-clash.
- **Accent Slate:** Used for dividers and borders to maintain a structural, blueprint-like feel.

## Typography

The typography system prioritizes legibility of numerical strings. **Inter** provides a neutral, highly readable sans-serif for headlines and prose. To enhance the analytical feel, **JetBrains Mono** is introduced for specific data points (P/E ratios, market caps, price targets) to ensure numbers align perfectly in vertical scans and provide a technical edge.

- **Tickers:** Large, bold, and slightly tracked-in for immediate recognition.
- **Data Tables:** Use the `data-tabular` role for all metrics to ensure digit clarity.
- **Labels:** Small caps with increased tracking are used for field headers (e.g., "MARKET CAP") to differentiate labels from content without increasing visual weight.

## Layout & Spacing

This design system utilizes a **12-column fluid grid** for desktop and a **single-column flow** for mobile. 

- **Grid Logic:** Complex stock dashboards should use a 3-column split on desktop (Sidebar: Navigation | Center: Main Analysis/Charts | Right: News/Watchlist). 
- **The 4px Rule:** All spacing increments must be multiples of 4px to ensure a tight, mathematical rhythm consistent with financial data.
- **Responsive Behavior:** 
    - **Desktop:** 24px margins, 16px gutters.
    - **Tablet:** 16px margins, 12px gutters.
    - **Mobile:** 12px margins, 8px gutters; metrics cards should stack vertically or scroll horizontally in "swipe-chips."

## Elevation & Depth

The design system avoids heavy shadows to maintain a modern, flat profile. Instead, depth is achieved through **Tonal Layering**:

- **Level 0 (Background):** #F8FAFC (Slate-50) – The base canvas.
- **Level 1 (Cards):** #FFFFFF (White) – Primary containers for metrics and news. These feature a 1px border in #E2E8F0 instead of a shadow.
- **Level 2 (Active/Hover):** A subtle, ultra-diffused shadow (0px 4px 12px rgba(15, 23, 42, 0.05)) is used only for interactive cards or dropdowns to indicate "lift."
- **Focus State:** 2px solid stroke in Primary Blue to highlight selected tickers or active input fields.

## Shapes

The design system uses a **Soft (0.25rem)** roundedness approach. This provides a professional balance—avoiding the aggressive sharpness of legacy software while remaining more serious than "bubbly" consumer apps.

- **Cards & Inputs:** 4px (0.25rem) radius.
- **Action Buttons:** 6px (0.375rem) radius for a slightly distinct feel.
- **Tag/Chips:** Fully rounded (pill) to distinguish them as interactive filters or categorical labels.

## Components

### Buttons
- **Primary:** Solid #0F172A background with white text. High contrast, authoritative.
- **Secondary:** Transparent background with #E2E8F0 border.
- **Ghost:** No border or background; used for low-priority actions in data tables.

### Data Cards
- Must include a `label-caps` header.
- The primary metric should be in `headline-md` or `headline-lg`.
- Include a "sparkline" (mini-chart) at the bottom of cards where trend data is relevant.

### Input Fields
- Understated style: 1px border (#CBD5E1) with `body-sm` text.
- Focus state: Border changes to Primary Navy with a 1px inset glow.

### Chips & Badges
- Used for Sector labels (e.g., "Technology") or Status (e.g., "Overvalued").
- Color-coded based on the semantic palette (Green for Bullish, Red for Bearish).

### Progress Bars (Fundamental Ratios)
- Used to show where a stock's current P/E sits within its 5-year range.
- Use a thin 4px track with a Slate-900 indicator.

### List Items (Market News)
- Bordered bottom only.
- Feature a timestamp in `body-sm` (Neutral color) and a bold headline.