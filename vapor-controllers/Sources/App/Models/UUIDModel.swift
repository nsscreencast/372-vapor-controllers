import Vapor
import FluentPostgreSQL

protocol UUIDModel : Model, PostgreSQLTable where Self.ID == UUID, Self.Database == PostgreSQLDatabase {
    var id: UUID? { get set }
}

extension UUIDModel {
    static var idKey: IDKey { return \.id }
}

extension SchemaCreator where Model : UUIDModel {
    func uuidPrimaryKey() {
        let pk = PostgreSQLColumnConstraint.primaryKey(default: nil, identifier: nil)
        let defaultUUID = PostgreSQLColumnConstraint.default(.function("uuid_generate_v4"), identifier: nil)
        field(for: \.id, type: .uuid, pk, defaultUUID)
    }
}
