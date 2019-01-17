import Vapor
import FluentPostgreSQL

final class IssueTag : ModifiablePivot, UUIDModel {
    
    static var name = "issue_tag"
    
    typealias Left = Issue
    typealias Right = Tag
    
    static var idKey: WritableKeyPath<IssueTag, UUID?> = \.id
    static var leftIDKey: WritableKeyPath<IssueTag, UUID> = \.issueId
    static var rightIDKey: WritableKeyPath<IssueTag, UUID> = \.tagId
        
    var id: UUID?
    var issueId: UUID
    var tagId: UUID
    
    init(_ left: Issue, _ right: Tag) throws {
        issueId = try left.requireID()
        tagId = try right.requireID()
    }
    
}

extension IssueTag : Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: conn) { builder in
            builder.uuidPrimaryKey()
            builder.field(for: \.issueId)
            builder.field(for: \.tagId)
            builder.reference(from: \.issueId, to: \Issue.id, onUpdate: nil, onDelete: .cascade)
            builder.reference(from: \.tagId, to: \Tag.id, onUpdate: nil, onDelete: .cascade)
        }
    }
}
