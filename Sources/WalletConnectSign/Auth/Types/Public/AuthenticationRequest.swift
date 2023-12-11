import Foundation

public struct AuthenticationRequest: Equatable, Codable {
    public let id: RPCID
    public let topic: String
    public let payload: AuthenticationPayload
    public let requester: AppMetadata
}