import Vapor
import FluentPostgreSQL

struct EnableUUIDExtension : PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return conn.simpleQuery("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";")
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Future<Void>.done(on: conn)
    }
}
