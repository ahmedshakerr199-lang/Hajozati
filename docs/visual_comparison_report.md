# Visual Comparison Report

| Area | Reference evidence | Flutter implementation | Status |
| --- | --- | --- | --- |
| Font | Tajawal-first stack | Tajawal theme and primary UI text | Close |
| Header | White, ~64px, logo right/menu left on mobile | White 64px header with responsive brand and menu | Close |
| Hero | Deep teal field, white headline, orange emphasis | `heroStart`/`heroEnd` gradient and white Tajawal heading | Close |
| Search | Rounded white surface, category pills, outlined fields, orange CTA | Responsive rounded search panel with the same hierarchy | Close |
| Featured rail | Horizontal property cards | Lazy horizontal `ListView.builder` with shared cards | Close |
| Mobile navigation | Four white bottom items, active home | Four-item semantic bottom navigation | Close |
| Drawer | Brand, close, home/explore/favorites/bookings/login | Same content and hierarchy | Close |

## Required differences

No reference source assets or proprietary icon package were imported. Material icons and the app's existing mock images remain in use. This avoids adding unlicensed assets while preserving the visual hierarchy.

## Removed feature audit

A full source/documentation search found no references to Nearby, Geolocator, location permissions, or the removed “قريبة مني” feature.
