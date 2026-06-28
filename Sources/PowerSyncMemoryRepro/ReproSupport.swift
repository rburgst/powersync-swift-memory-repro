import Foundation
import PowerSync

public enum ReproTable {
    public static let failedSyncs = "failed_syncs"
}

public enum ReproSchema {
    public static let oneTable = Schema(
        Table(
            name: "items",
            columns: [
                .text("name")
            ]
        )
    )

    public static let failedSyncsOnly = Schema(
        Table(
            name: ReproTable.failedSyncs,
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
    )
}

public struct StdoutLogWriter: LogWriterProtocol {
    public init() {}

    public func log(severity: LogSeverity, message: String, tag: String?) {
        let tagText = tag.map { "[\($0)] " } ?? ""
        print("POWERSYNC \(severity.stringValue) \(tagText)\(message)")
    }
}

public func makeDatabase(
    schema: Schema = ReproSchema.failedSyncsOnly,
    dbFilename: String
) -> any PowerSyncDatabaseProtocol {
    PowerSyncDatabase(
        schema: schema,
        dbFilename: dbFilename,
        logger: DefaultLogger(
            minSeverity: .debug,
            writers: [StdoutLogWriter()]
        )
    )
}

public func makeFileBackedDBFilename(_ prefix: String) -> String {
    "\(prefix)-\(UUID().uuidString).sqlite"
}
