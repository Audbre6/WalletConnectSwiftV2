import Foundation
import WalletConnectUtils
import WalletConnectPairing

public struct PushSubscription: Codable, Equatable {
    public let topic: String
    public let relay: RelayProtocolOptions
    public let metadata: AppMetadata
}