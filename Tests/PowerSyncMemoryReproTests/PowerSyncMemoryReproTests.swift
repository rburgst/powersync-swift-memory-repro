import XCTest
import PowerSync
@testable import PowerSyncMemoryRepro

@MainActor
final class PowerSyncMemoryReproTests: XCTestCase {
    private var database: (any PowerSyncDatabaseProtocol)!

    override func tearDown() async throws {
        if let database {
            try? await database.close()
            self.database = nil
        }
        try await super.tearDown()
    }

    func testExecuteSelectOneOnFileBackedDatabase() async throws {
        database = makeDatabase(
            schema: ReproSchema.failedSyncsOnly,
            dbFilename: makeFileBackedDBFilename("powersync-memory-repro")
        )

        let value = try await database.get(
            sql: "SELECT 1",
            parameters: []
        ) { cursor in
            try cursor.getInt(index: 0)
        }

        XCTAssertEqual(value, 1)
    }

    func testExecuteSelectOneOnInMemoryDatabaseWithOneTableSchema() async throws {
        database = makeDatabase(
            schema: ReproSchema.oneTable,
            dbFilename: ":memory:"
        )

        let value = try await database.get(
            sql: "SELECT 1",
            parameters: []
        ) { cursor in
            try cursor.getInt(index: 0)
        }

        XCTAssertEqual(value, 1)
    }

    func testExecuteSelectOneOnInMemoryDatabaseWithFailedSyncsOnlySchema() async throws {
        database = makeDatabase(
            schema: ReproSchema.failedSyncsOnly,
            dbFilename: ":memory:"
        )

        let value = try await database.get(
            sql: "SELECT 1",
            parameters: []
        ) { cursor in
            try cursor.getInt(index: 0)
        }

        XCTAssertEqual(value, 1)
    }
}
