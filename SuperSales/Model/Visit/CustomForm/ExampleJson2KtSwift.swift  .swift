
import Foundation

struct VisitCustomFormJson: Codable {

  var status  : String? = nil
  var message : String? = nil
  var data    : [CustomForm]? = []

  enum CodingKeys: String, CodingKey {

    case status  = "status"
    case message = "message"
    case data    = "data"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    status  = try values.decodeIfPresent(String.self , forKey: .status  )
    message = try values.decodeIfPresent(String.self , forKey: .message )
    data    = try values.decodeIfPresent([CustomForm].self , forKey: .data    )
 
  }

  init() {

  }

}

extension Encodable {
    func asDictionary() throws -> Data {
        let data = try JSONEncoder().encode(self)
        return data
    }
}
