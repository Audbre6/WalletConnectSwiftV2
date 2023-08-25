import Foundation

struct RelayAuthPayload: JWTClaimsCodable {

    struct Wrapper: JWTWrapper {
        let jwtString: String
    }

    struct Claims: JWTClaims {
        let iss: String
        let sub: String
        let aud: String
        let iat: UInt64
        let exp: UInt64

        let act: String?

        static var action: String? { nil }
    }

    let subject: String
    let audience: String

    init(subject: String, audience: String) {
        self.subject = subject
        self.audience = audience
    }

    init(claims: Claims) throws {
        self.subject = claims.sub
        self.audience = claims.aud
    }

    func encode(iss: String) throws -> Claims {
        return Claims(
            iss: iss,
            sub: subject,
            aud: audience,
            iat: defaultIat(),
            exp: expiry(days: 1),
            act: Claims.action
        )
    }
}
