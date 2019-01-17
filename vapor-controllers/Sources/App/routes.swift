import Routing
import Vapor
import FluentPostgreSQL

public func routes(_ router: Router) throws {
    
    /*
     GET /projects  --> index
     GET /projects/:id --> show
     GET /projects/new --> html form
     POST /projects
     GET /projects/:id/edit --> html form
     PUT /projects/:id --> update
     DELETE /projects/:id
     
     /projects/:id/issues
     
     /users/new
     /users
     /user
     
     /admin
    */
    
    try router.grouped("projects").register(collection: ProjectsController())
    
    router.get("_setup") { req -> Future<String> in
        let project = Project(title: "test project", description: "test description")
        return project.create(on: req).flatMap { project in
            let titles = ["Issue #1", "Issue #2", "Issue #3"]
            let issues = try titles.map { try Issue(subject: $0, body: "Test body for issue \($0)", projectId: project.requireID())}
            let futures = issues.map { $0.create(on: req) }
            return futures.flatten(on: req).map { issues in
                return "Created project: \(project.id!) with issues: \(issues.map { $0.id! })"
            }
        }
    }
}
