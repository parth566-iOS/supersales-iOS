
import Foundation

struct FormDropdownValues: Codable {

  var ID                : Int?    = nil
  var customFormID      : Int?    = nil
  var customFormFieldID : Int?    = nil
  var dropdowmSequence  : Int?    = nil
  var dropdownValue     : String? = nil
  var isSelected        : Bool    = false

  enum CodingKeys: String, CodingKey {

    case ID                = "ID"
    case customFormID      = "customFormID"
    case customFormFieldID = "customFormFieldID"
    case dropdowmSequence  = "dropdowmSequence"
    case dropdownValue     = "dropdownValue"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    ID                = try values.decodeIfPresent(Int.self    , forKey: .ID                )
    customFormID      = try values.decodeIfPresent(Int.self    , forKey: .customFormID      )
    customFormFieldID = try values.decodeIfPresent(Int.self    , forKey: .customFormFieldID )
    dropdowmSequence  = try values.decodeIfPresent(Int.self    , forKey: .dropdowmSequence  )
    dropdownValue     = try values.decodeIfPresent(String.self , forKey: .dropdownValue     )
 
  }

  init() {

  }

}