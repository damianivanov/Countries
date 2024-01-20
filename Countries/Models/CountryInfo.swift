struct QueryResponse: Decodable {
    let batchComplete: String
    let query: Query

    enum CodingKeys: String, CodingKey {
        case batchComplete = "batchcomplete"
        case query
    }
}

struct Query: Decodable {
    let pages: [String: Page]
}

struct Page: Decodable {
    let pageid: Int
    let ns: Int
    let title: String
    let extract: String
}
