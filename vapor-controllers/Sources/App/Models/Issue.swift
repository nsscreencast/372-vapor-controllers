import Vapor
import FluentPostgreSQL

final class Issue : UUIDModel, TimestampModel {
    static var name: String = "issues"
    
    enum Status : String, PostgreSQLEnum {
        case open
        case closed
        case wontFix
    }

    var id: UUID?
    var createdAt: Date?
    var updatedAt: Date?
    
    var subject: String
    var body: String
    var status: Status = .open
    var projectId: UUID
    var project: Parent<Issue, Project> {
        return parent(\.id)!
    }
    var tags: Siblings<Issue, Tag, IssueTag> {
        return siblings()
    }
    
    init(subject: String, body: String, projectId: UUID) {
        self.subject = subject
        self.body = body
        self.projectId = projectId
    }
}

extension Issue : Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: conn) { builder in
            
            builder.uuidPrimaryKey()
            
            builder.field(for: \.subject, type: .varchar(500))
            builder.field(for: \.body)
            builder.field(for: \.status, type: .varchar(100))
            builder.field(for: \.projectId)
            builder.reference(from: \.projectId, to: \Project.id,
                              onUpdate: nil,
                              onDelete: .cascade)
            
            builder.timestampFields()
            
        }
    }
}
