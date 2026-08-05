# Manual Device Validation

## Device

`flutter devices` detected `Infinix X6731B` (`11099253CJ001349`, Android 14).

## Status

A Profile-mode launch completed successfully: `app-profile.apk` was built (26.4MB), installed, and connected to a Dart VM service/DevTools endpoint. The launch log recorded 114 skipped frames during Android startup while the runtime compiled its first view traversal. No post-startup interaction/frame capture was collected, so no general smoothness claim is made.

## Automated responsive coverage completed

- Home
- Search
- Explore Iraq
- Hotel details
- Destination details
- Room selection
- Booking details, summary, and confirmation

These are tested in RTL with text scale 1.3 at 320, 375, 390, and 430 logical-pixel widths. The Home overflow found at 320px was fixed before this report.

## Manual checks pending a live profile connection

Open/close drawer, province sheet, dates, guests, search results, hotel details, booking flow, confirmation, and Explore Iraq on the unlocked device.
