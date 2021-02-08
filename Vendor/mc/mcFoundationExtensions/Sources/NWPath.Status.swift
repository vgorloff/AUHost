import Network

extension NWPath.Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .requiresConnection:
            return "requiresConnection"
        case .satisfied:
            return "satisfied"
        case .unsatisfied:
            return "unsatisfied"
        @unknown default:
            return "unknown"
        }
    }
}
