import Vapor
import FluentPostgreSQL

final class Project : UUIDModel, TimestampModel {
    static var name: String = "projects"
    
    var id: UUID?
    var title: String
    var description: String
    
    var createdAt: Date?
    var updatedAt: Date?
    
    var issues: Children<Project, Issue> {
        return children(\.projectId)
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

extension Project : Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: conn) { builder in
            
            builder.uuidPrimaryKey()
            builder.field(for: \.title, type: .varchar(500))
            builder.field(for: \.description)            
            builder.timestampFields()
            
        }
    }
}

extension Project : Content { }
extension Project : Parameter { }
