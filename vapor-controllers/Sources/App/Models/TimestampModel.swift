import Vapor
import FluentPostgreSQL

protocol TimestampModel : Model {
    var createdAt: Date? { get set }
    var updatedAt: Date? { get set }
}

extension TimestampModel {
    static var createdAtKey: TimestampKey? { return \.createdAt }
    static var updatedAtKey: TimestampKey? { return \.updatedAt }
}

extension SchemaCreator where Model : TimestampModel {
    func timestampFields() {
        field(for: \.createdAt)
        field(for: \.updatedAt)
    }
}
