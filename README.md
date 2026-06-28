# PowerSync Swift `:memory:` Repro

Minimal standalone Swift package reproducing a PowerSync crash on the first real DB operation when `dbFilename: ":memory:"` is used under XCTest with a minimal `failed_syncs` schema.

## Requirements

- macOS
- Xcode / Swift toolchain able to run `swift test`

## Dependency

- `https://github.com/powersync-ja/powersync-swift`
- pinned to `1.6.0`

## Quick start

```bash
swift test --filter PowerSyncMemoryReproTests/testExecuteSelectOneOnFileBackedDatabase
swift test --filter PowerSyncMemoryReproTests/testExecuteSelectOneOnInMemoryDatabaseWithOneTableSchema
swift test --filter PowerSyncMemoryReproTests/testExecuteSelectOneOnInMemoryDatabaseWithFailedSyncsOnlySchema
```

## Repro commands

Control case:

```bash
swift test --filter PowerSyncMemoryReproTests/testExecuteSelectOneOnFileBackedDatabase
```

Expected:

- passes

In-memory control with unrelated schema:

```bash
swift test --filter PowerSyncMemoryReproTests/testExecuteSelectOneOnInMemoryDatabaseWithOneTableSchema
```

Expected:

- passes

Crash repro:

```bash
swift test --filter PowerSyncMemoryReproTests/testExecuteSelectOneOnInMemoryDatabaseWithFailedSyncsOnlySchema
```

Expected:

- process exits non-zero after a PowerSync exception during schema bootstrap
- top-level error typically includes:

```text
powersync_replace_schema
powersync_drop_view
```

## Observed behavior

- `SELECT 1` against the in-memory `failed_syncs` schema crashes.
- Equivalent file-backed DB works.
- A one-table control schema also works in memory.

So the minimal triggering schema found so far is:

```swift
Table(
    name: "failed_syncs",
    columns: [
        .text("user_id"),
        .text("timerecord_id"),
        .text("upload_data"),
        .text("error"),
        .text("created_at"),
        .text("updated_at"),
        .text("created_by"),
        .text("updated_by")
    ]
)
```

## Files

- `Sources/PowerSyncMemoryRepro/ReproSupport.swift`
- `Tests/PowerSyncMemoryReproTests/PowerSyncMemoryReproTests.swift`
- `GITHUB_ISSUE.md`
- `LICENSE`
