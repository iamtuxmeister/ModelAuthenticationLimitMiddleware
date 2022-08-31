import Foundation
import Vapor
import Fluent


public protocol ModelCredentialsSingleAuthenticatable: ModelCredentialsAuthenticatable { }

extension ModelCredentialsSingleAuthenticatable {
    public static func credentialsSingleAuthenticator(
        database: DatabaseID? = nil
    ) -> Authenticator {
        ModelCredentialsSingleAuthenticator<Self>(database: database)
    }

    var _$username: Field<String> {
        self[keyPath: Self.usernameKey]
    }

    var _$passwordHash: Field<String> {
        self[keyPath: Self.passwordHashKey]
    }
}

private struct ModelCredentialsSingleAuthenticator<User>: CredentialsAuthenticator
    where User: ModelCredentialsSingleAuthenticatable
{
    typealias Credentials = ModelCredentials

    public let database: DatabaseID?

    func authenticate(credentials: ModelCredentials, for request: Request) -> EventLoopFuture<Void> {
        User.query(on: request.db(self.database)).filter(\._$username == credentials.username).first().flatMapThrowing { foundUser in
            guard let user = foundUser else {
                return
            }
            guard try user.verify(password: credentials.password) else {
                return
            }
            let foundSessions = request.application.sessions.memory.storage.sessions.compactMapValues { sessionData in
                sessionData.snapshot.compactMap { (_: String, value: String) in value == "\(user.id!)" }
            }.filter { $1 == [true] }.map { $0.0 }
            
            for session in foundSessions {
                _ = request.application.sessions.memory.deleteSession(session, for: request)
            }
            request.auth.login(user)
        }
    }
}

