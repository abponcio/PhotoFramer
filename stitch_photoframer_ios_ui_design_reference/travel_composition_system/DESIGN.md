---
name: Travel Composition System
colors:
  surface: '#f2fbff'
  surface-dim: '#c8dee7'
  surface-bright: '#f2fbff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#e4f7ff'
  surface-container: '#dcf1fb'
  surface-container-high: '#d6ecf5'
  surface-container-highest: '#d0e6ef'
  on-surface: '#091e25'
  on-surface-variant: '#40484a'
  inverse-surface: '#1f333a'
  inverse-on-surface: '#def4fe'
  outline: '#70797b'
  outline-variant: '#bfc8ca'
  surface-tint: '#276673'
  primary: '#004752'
  on-primary: '#ffffff'
  primary-container: '#1e5f6b'
  on-primary-container: '#9bd7e5'
  inverse-primary: '#94d0de'
  secondary: '#3d646e'
  on-secondary: '#ffffff'
  secondary-container: '#bde7f2'
  on-secondary-container: '#416872'
  tertiary: '#42403a'
  on-tertiary: '#ffffff'
  tertiary-container: '#595750'
  on-tertiary-container: '#d1cdc4'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#b0ecfa'
  primary-fixed-dim: '#94d0de'
  on-primary-fixed: '#001f25'
  on-primary-fixed-variant: '#004e5a'
  secondary-fixed: '#c0e9f5'
  secondary-fixed-dim: '#a4cdd8'
  on-secondary-fixed: '#001f25'
  on-secondary-fixed-variant: '#234c55'
  tertiary-fixed: '#e7e2d9'
  tertiary-fixed-dim: '#cac6be'
  on-tertiary-fixed: '#1d1c16'
  on-tertiary-fixed-variant: '#494740'
  background: '#f2fbff'
  on-background: '#091e25'
  surface-variant: '#d0e6ef'
typography:
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 30px
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-mono:
    fontFamily: Space Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.05em
  score-display:
    fontFamily: Space Mono
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 48px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  safe-area-inset: 20px
---

## Brand & Style

The design system focuses on a clean, minimal aesthetic that bridges the gap between a high-precision photographic tool and a welcoming travel companion. It prioritizes clarity and calm, ensuring that the interface never competes with the user's view through the lens.

The visual style is a hybrid of **Minimalism** and **Glassmorphism**. High-precision functional elements use sharp, legible typography and fine lines, while interactive overlays leverage frosted-glass effects to maintain context of the live camera feed. This approach ensures the utility feels professional and trustworthy, while the "Sand" and "Teal" palette evokes the natural warmth of travel and exploration.

## Colors

The palette is rooted in the "Travel Teal" spectrum, designed to provide high contrast against a variety of natural backgrounds.

- **Primary Teal** is used for active states and primary actions.
- **Deep Teal** serves as the base for translucent UI panels, providing depth without obscuring the camera view.
- **Sand and Sand Dark** are reserved for non-camera surfaces, such as onboarding and settings, providing a grounded, paper-like tactile feel.
- **Ink and Ink Muted** handle the typographic hierarchy to ensure legibility.
- **Semantic Colors** (Green, Amber, Coral) are strictly reserved for the coaching engine's feedback loop, indicating the quality of the current composition.

## Typography

This design system utilizes **Hanken Grotesk** for all primary UI interactions to achieve a contemporary, professional look that mirrors the precision of modern hardware. Its clean geometry ensures high legibility during outdoor use.

For the coaching "Score" and technical metadata, **Space Mono** is used. The monospaced nature of the font prevents layout jitter when numbers fluctuate rapidly during live composition tracking. 

- Use `headline-lg` for primary headers on sand backgrounds.
- Use `score-display` for the live composition percentage.
- Use `label-mono` for all camera-overlay data points (ISO, Grid type, focal length).

## Layout & Spacing

The layout follows a **Fixed Grid** model optimized for the iPhone 15 Pro aspect ratio. 

- **Camera View:** A full-screen edge-to-edge layout where UI elements are treated as "Floating HUD" components.
- **Safe Zones:** A 20px horizontal margin is maintained for all interactive elements to ensure they are comfortably reachable and do not interfere with the camera's focus/exposure gestures.
- **Gutter:** A 16px gutter is used for multi-column lists in the "Gallery" or "Lessons" views.
- **Vertical Rhythm:** Elements are spaced in multiples of 4px, with 16px being the standard gap between grouped controls (e.g., a group of camera settings).

## Elevation & Depth

Depth is established through **Glassmorphism** rather than traditional shadows. 

1. **The Base Layer:** The live camera feed.
2. **The Overlay Layer:** Translucent panels using `Deep Teal` with an 85% opacity and a 20px backdrop blur. This provides a "frosted" look that separates UI from the background clutter.
3. **The Interaction Layer:** Buttons and active chips use solid `Primary Teal` or `Sand` to appear visually "above" the translucent panels.
4. **Guides:** Lines and markers use a 1px or 1.5px stroke weight with `Teal Muted` to remain visible but non-intrusive.

## Shapes

The design system employs a **Rounded** shape language to feel approachable and modern. 

- **Standard Elements:** 0.5rem (8px) corner radius for small input fields and cards.
- **Pills:** All primary camera controls and HUD badges use a full pill shape (100px radius) to differentiate them from the rectangular frames of the camera's field of view.
- **Selection States:** Subtle 1px borders using `Sand Dark` are applied to containers to provide definition on light backgrounds.

## Components

### Buttons
- **Primary:** Solid `Primary Teal` with `Sand` text. Pill-shaped for camera view, rounded for onboarding.
- **HUD Toggle:** Translucent `Deep Teal` (85% opacity) with white or `Sand` icons. 

### Chips & Indicators
- **Coaching Score:** A pill-shaped badge using a backdrop blur. The border color of the pill dynamically changes between `Good Green`, `Adjust Amber`, and `Critical Coral` based on the composition score.
- **Status Chips:** Small, monospaced labels used for technical data.

### Lists & Menus
- **Settings:** Clean rows on a `Sand` background, separated by `Sand Dark` 1px dividers.
- **Camera Tray:** A horizontal scrolling list of composition guides (Rule of Thirds, Golden Ratio, etc.) using translucent square icons.

### Input Fields
- **Search/Text:** Minimalist design with a `Sand Dark` bottom border or a subtle `Sand Dark` filled container with 8px corner radius.

### Guides & Grids
- **Line Weight:** 1px stroke. 
- **Active State:** When a subject is locked, the guide line thickens to 2px and transitions to `Primary Teal`.