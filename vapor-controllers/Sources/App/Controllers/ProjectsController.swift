import Vapor
import FluentPostgreSQL

final class ProjectsController : RouteCollection {
    func boot(router: Router) throws {
        router.get(use: index)
        router.get(Project.parameter, use: show)
        router.post(use: create)
        router.put(Project.parameter, use: update)
        router.delete(Project.parameter, use: delete)
    }
    
    private func index(_ req: Request) throws -> Future<[Project]> {
        return Project.query(on: req)
            .sort(\.createdAt, .descending)
            .all()
    }
    
    private func show(_ req: Request) throws -> Future<Project> {
        return try req.parameters.next(Project.self)
    }
    
    private func create(_ req: Request) throws -> Future<Project> {
        let project = Project(title: "New Project", description: "New Description")
        return project.save(on: req)
    }
    
    private func update(_ req: Request) throws -> Future<Project> {
        return try req.parameters.next(Project.self)
            .flatMap { project in
                project.title = project.title + " UPDATED"
                return project.save(on: req)
        }
    }
    
    private func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Project.self)
            .flatMap { project in
                return project.delete(on: req).transform(to: .noContent)
        }
    }
}
