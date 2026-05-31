# PhotoFramer

Live camera composition coach for travel photos. Frame it right, before you shoot.

PhotoFramer helps you level the phone, place your subject on rule-of-thirds guides, and improve framing in real time — then open the native iPhone Camera for the final shot.

## Requirements

- macOS with **Xcode 15+**
- **iOS 17+** iPhone (physical device recommended; Simulator has limited camera/Vision support)
- Apple ID for code signing (free provisioning works for personal devices)

## Open the project

```bash
open PhotoFramer.xcodeproj
```

1. Select the **PhotoFramer** target → **Signing & Capabilities** → choose your **Team**.
2. Connect an iPhone and run (**⌘R**).

## Architecture

```
PhotoFramer/
├── Camera/          AVFoundation session, preview, photo capture
├── Motion/          Core Motion pitch/roll leveling
├── Vision/          VNDetectHumanRectangles (throttled ~8 fps)
├── Composition/     Score 0–100 + prioritized suggestions
├── UI/              Camera chrome + coaching overlays
├── ViewModels/      FramingViewModel orchestration
└── Theme/           Camera HUD + onboarding colors
```

### Data flow

1. `LevelDetector` updates pitch/roll at 30 Hz.
2. `CameraManager` delivers sample buffers → `PersonDetector` (~8 fps).
3. `CompositionEngine` merges motion, person rect, sky luma → `CompositionState`.
4. SwiftUI overlays + compact score + single coaching caption.
5. **Shutter** → opens `camera://` (native Camera). **Download icon** → in-app capture → Photos.

## Design reference

Stitch mockups live in `stitch_photoframer_ios_ui_design_reference/`. The shipped camera UI mimics **Apple Camera** (black HUD, white shutter); onboarding uses Travel Teal surfaces from `DESIGN.md`.

## Permissions

| Key | Purpose |
|-----|---------|
| `NSCameraUsageDescription` | Live preview + Vision |
| `NSPhotoLibraryAddUsageDescription` | Save in-app captures |

## Manual test checklist (device)

- [ ] Allow / deny camera permission; denied shows Settings path
- [ ] Live preview fills screen
- [ ] Rule-of-thirds grid toggles (top-right grid button)
- [ ] Tilt phone → “Level the phone”, score drops
- [ ] Person in frame → bounding box + move hints
- [ ] Centered subject → “Subject too centered”
- [ ] Score turns green (≥80) when aligned
- [ ] Shutter opens iPhone Camera (or fallback alert)
- [ ] In-app capture saves to Photos + thumbnail updates

## Known limitations (MVP)

- `camera://` URL is undocumented; may fail on some iOS versions (fallback alert shown).
- In-app photos lack native Camera HDR/night processing.
- Back camera only; no video mode or pose templates.
- Sky / landmark detection uses simple heuristics, not scene segmentation.

## Bundle ID

Default: `com.photoframer.app` — change in Xcode before App Store distribution.
