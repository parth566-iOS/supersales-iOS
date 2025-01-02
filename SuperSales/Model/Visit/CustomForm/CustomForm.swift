
import Foundation

struct CustomForm: Codable {

  var ID              : Int?          = nil
  var companyID       : Int?          = nil
  var formName        : String?       = nil
  var createdBy       : Int?          = nil
  var createdTime     : String?       = nil
  var modifiedBy      : Int?          = nil
  var isActive        : Bool?         = nil
  var addPicture      : Bool?         = nil
  var formFields      : [FormFields]? = []
  var customerType    : String?       = nil
  var customerSegment : String?       = nil

  enum CodingKeys: String, CodingKey {

    case ID              = "ID"
    case companyID       = "companyID"
    case formName        = "formName"
    case createdBy       = "createdBy"
    case createdTime     = "createdTime"
    case modifiedBy      = "modifiedBy"
    case isActive        = "isActive"
    case addPicture      = "addPicture"
    case formFields      = "formFields"
    case customerType    = "customerType"
    case customerSegment = "customerSegment"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    ID              = try values.decodeIfPresent(Int.self          , forKey: .ID              )
    companyID       = try values.decodeIfPresent(Int.self          , forKey: .companyID       )
    formName        = try values.decodeIfPresent(String.self       , forKey: .formName        )
    createdBy       = try values.decodeIfPresent(Int.self          , forKey: .createdBy       )
    createdTime     = try values.decodeIfPresent(String.self       , forKey: .createdTime     )
    modifiedBy      = try values.decodeIfPresent(Int.self          , forKey: .modifiedBy      )
    isActive        = try values.decodeIfPresent(Bool.self         , forKey: .isActive        )
    addPicture      = try values.decodeIfPresent(Bool.self         , forKey: .addPicture      )
    formFields      = try values.decodeIfPresent([FormFields].self , forKey: .formFields      )
    customerType    = try values.decodeIfPresent(String.self       , forKey: .customerType    )
    customerSegment = try values.decodeIfPresent(String.self       , forKey: .customerSegment )
 
  }

  init() {

  }

}
