# Performance validation

## Device availability

`flutter devices` found the Android handset `Infinix X6731B` (`11099253CJ001349`, Android 14), plus Windows, Chrome and Edge.

## Profile-mode measurement

`flutter run --profile -d 11099253CJ001349` completed: the profile APK was built (26.4MB), installed, and exposed Dart VM Service/DevTools. Android emitted `Skipped 114 frames` during startup while compiling the initial view traversal. No DevTools timeline was captured after startup, so no build/raster averages or general jank conclusion is reported.

## Implemented low-risk improvements

- The reusable hotel card now switches to a narrow vertical arrangement, preventing invalid constraints and expensive exception rendering during scroll.
- Text fields in dense cards use ellipsis and flexible allocation rather than overflow.
- Explore's province field is constrained to its available width.
- Lists remain lazily scrollable where existing screen structure allows.
- Home sections cache their derived lists, search input is debounced, result lists are built lazily, and thumbnail image memory is bounded.

## Remaining work

Run Profile Mode on the connected handset, record DevTools frame charts while opening Home, the province sheet, Explore and Hotel Details, then append measured values. No performance claim is made until that measurement is available.

## Final automated gate

```text
flutter analyze: No issues found! (8.9s)
flutter test: 43 tests passed (01:55)
```
