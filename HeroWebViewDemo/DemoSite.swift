// Copyright 2026 The Hero Authors

/// A live name of one name service, opened by its button or by the tour.
struct DemoSite: Identifiable, Hashable {
  let service: String
  let name: String
  var id: String { name }

  static let all: [DemoSite] = [
    DemoSite(service: "ENS", name: "vitalik.eth"),
    DemoSite(service: "Handshake", name: "shakeshift/"),
    DemoSite(service: "Solana", name: "bonfida.sol"),
    DemoSite(service: "BNB", name: "venus.bnb"),
    DemoSite(service: "NEAR", name: "thewiki.near"),
    DemoSite(service: "ICP", name: "icpswap.icp"),
    DemoSite(service: "Tezos", name: "kukai.tez"),
    DemoSite(service: "Filecoin", name: "654321.fil"),
    DemoSite(service: "Polkadot", name: "recepayyildiz.dot"),
    DemoSite(service: "Arbitrum", name: "hidayath.arb"),
    DemoSite(service: "Hedera", name: "a.hbar"),
    DemoSite(service: "Unstoppable", name: "brad.crypto"),
    DemoSite(service: "Algorand", name: "pera.algo"),
  ]
}
