import Vapor
import FluentPostgreSQL

final class Tag : UUIDModel, TimestampModel {
    static var name: String = "tags"
    
    var id: UUID?
    var name: String
    var createdAt: Date?
    var updatedAt: Date?
    
    var issues: Siblings<Tag, Issue, IssueTag> {
        return siblings()
    }
    
    init(name: String) {
        self.name = name
    }
}

extension Tag : Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: conn) { builder in
            builder.uuidPrimaryKey()
            builder.field(for: \.name, type: .varchar(100))
            builder.timestampFields()
        }
    }
}
