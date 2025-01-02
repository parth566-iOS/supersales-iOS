
import Foundation

struct FormFields: Codable {

  var ID                     : Int?                  = 0
  var customFormID           : Int?                  = 0
  var fieldSequence          : Int?                  = 0
  var fieldName              : String?               = nil
  var fieldTypeID            : Int?                  = 0
  var maxTextCharsAllowed    : Int?                  = 0
  var maxNumericValueAllowed : Int?                  = 0
  var isNegValueAllowed      : Bool?                 = nil
  var isPastDateAllowed      : Bool?                 = nil
  var isFutureDateAllowed    : Bool?                 = nil
  var noOfDropdownValues     : Int?                  = 0
  var noOfCheckboxValues     : Int?                  = 0
  var formDropdownValues     : [FormDropdownValues]? = []
  var inputOrDisplay         : String?               = nil
  var createdBy              : Int?                  = nil
  var mandatoryOrOptional    : Int?                = 0
  enum CodingKeys: String, CodingKey {

    case ID                     = "ID"
    case customFormID           = "customFormID"
    case fieldSequence          = "fieldSequence"
    case fieldName              = "fieldName"
    case fieldTypeID            = "fieldTypeID"
    case maxTextCharsAllowed    = "maxTextCharsAllowed"
    case maxNumericValueAllowed = "maxNumericValueAllowed"
    case isNegValueAllowed      = "isNegValueAllowed"
    case isPastDateAllowed      = "isPastDateAllowed"
    case isFutureDateAllowed    = "isFutureDateAllowed"
    case noOfDropdownValues     = "noOfDropdownValues"
    case noOfCheckboxValues     = "noOfCheckboxValues"
    case formDropdownValues     = "formDropdownValues"
    case inputOrDisplay         = "inputOrDisplay"
    case createdBy              = "createdBy"
    case mandatoryOrOptional    = "mandatoryOrOptional"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    ID                     = try values.decodeIfPresent(Int.self                  , forKey: .ID                     )
    customFormID           = try values.decodeIfPresent(Int.self                  , forKey: .customFormID           )
    fieldSequence          = try values.decodeIfPresent(Int.self                  , forKey: .fieldSequence          )
    fieldName              = try values.decodeIfPresent(String.self               , forKey: .fieldName              )
    fieldTypeID            = try values.decodeIfPresent(Int.self                  , forKey: .fieldTypeID            )
    maxTextCharsAllowed    = try values.decodeIfPresent(Int.self                  , forKey: .maxTextCharsAllowed    )
    maxNumericValueAllowed = try values.decodeIfPresent(Int.self                  , forKey: .maxNumericValueAllowed )
    isNegValueAllowed      = try values.decodeIfPresent(Bool.self                 , forKey: .isNegValueAllowed      )
    isPastDateAllowed      = try values.decodeIfPresent(Bool.self                 , forKey: .isPastDateAllowed      )
    isFutureDateAllowed    = try values.decodeIfPresent(Bool.self                 , forKey: .isFutureDateAllowed    )
    noOfDropdownValues     = try values.decodeIfPresent(Int.self                  , forKey: .noOfDropdownValues     )
    noOfCheckboxValues     = try values.decodeIfPresent(Int.self                  , forKey: .noOfCheckboxValues     )
    formDropdownValues     = try values.decodeIfPresent([FormDropdownValues].self , forKey: .formDropdownValues     )
    inputOrDisplay         = try values.decodeIfPresent(String.self               , forKey: .inputOrDisplay         )
    createdBy              = try values.decodeIfPresent(Int.self                  , forKey: .createdBy              )
    mandatoryOrOptional    = try values.decodeIfPresent(Int.self                  , forKey: .mandatoryOrOptional    )
  }

  init() {

  }

}
