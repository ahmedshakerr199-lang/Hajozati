# Hajozati UI redesign audit

## Scope and reference review

The supplied reference is the owner-authorized design source: `https://hujuzati-booking-app-0e3h.bolt.host/`.
The automated review environment could not establish a secure connection to that host, so pixel measurements could not be captured programmatically. The implementation uses the supplied Hajozati identity and maps the reference's stated booking-first hierarchy to the existing Flutter capabilities without fabricating unavailable pages or services.

## Current Flutter pages and mapping

| Flutter page | Reference role | Preserved capability |
|---|---|---|
| SplashPage | Brand entry | Timed transition to home |
| HomePage | Booking landing page | Discover, search and hotel entry points |
| SearchPage | Search/results | Suggestions and existing search view model |
| ExploreIraqPage / DestinationDetailsPage | Discover destinations | Existing filters, destination routes and state handling |
| HotelDetailsPage | Hotel detail | Detail loading, booking draft creation and similar hotels |
| RoomSelectionPage / BookingDetailsPage / BookingSummaryPage | Booking flow | `bookingId` contract and coordinator-owned draft |
| BookingConfirmationPage | Confirmation | Repository-backed confirmed-booking read flow |

There are no login, onboarding, favourites, bookings-list, profile, or settings pages in the current Flutter route table; none were invented during the redesign.

## Central design tokens

| Token | Value / use |
|---|---|
| Primary | `#0F4C5C` – navigation, primary actions and icons |
| Accent | `#E36414` – prices, labels and active emphasis |
| Background / surface | `#F4F7F6` / `#FFFFFF` |
| Text / muted | `#1D2D44` / `#64748B` |
| Success / warning / danger | `#2E9E5B` / `#D99A0B` / `#D63B3B` |
| Typography | Cairo 800 for hierarchy; Tajawal for body text |
| Spacing | 4, 8, 12, 16, 20, 24, 32 px |
| Radius | 14 px fields; 20 px cards; 28 px hero images; pill labels |
| Shadow | low-opacity primary shadow, 18px blur and 8px vertical offset |
| Motion | 180ms and 280ms ease-out timings |

## Shared components

`HajozatiCard`, `SectionHeader`, `HajozatiStateView`, `HajozatiNetworkImage`, and `HotelPreviewCard` centralize branded cards, section hierarchy, loading/empty/error states, image fallbacks and hotel presentation. Screens use these instead of local, one-off visual recipes.

## Functional safeguards

- Existing domain, repository, use-case and coordinator contracts remain unchanged.
- Booking navigation continues to carry IDs only.
- Arabic and RTL remain application-wide defaults.
- No Halabja province or Spa amenity was added.
- Image failures use a branded fallback; no insecure network URLs were introduced.
