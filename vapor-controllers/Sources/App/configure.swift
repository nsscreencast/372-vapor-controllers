import Vapor
import FluentPostgreSQL

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    try services.register(FluentPostgreSQLProvider())
    
    let pgConfig = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "ben", database: "vapor-tracker")
    let db = PostgreSQLDatabase(config: pgConfig)
    
    var databasesConfig = DatabasesConfig()
    databasesConfig.add(database: db, as: .psql)
    services.register(databasesConfig)
    
    var migrations = MigrationConfig()
    migrations.add(migration: EnableUUIDExtension.self, database: .psql)
    migrations.add(model: Project.self, database: .psql)
    migrations.add(model: Issue.self, database: .psql)
    migrations.add(model: Tag.self, database: .psql)
    migrations.add(model: IssueTag.self, database: .psql)
    services.register(migrations)
}
