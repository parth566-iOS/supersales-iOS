//
//  UIHelper.swift
//  SuperSales
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class UIHelper: NSObject {
    
    
    
    class func setCornerRadiusForBtn(btn:UIView,radius:Int)->UIView {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = CGFloat(radius)
        return btn
    }
    
    
    //    func setcornerRedius(rad:Int){
    //
    //        self.layer.cornerRadius =  CGFloat(rad)
    //    }
    
}

extension NSMutableAttributedString{
    func stratributed(bold:String,normal:String)->NSMutableAttributedString{
        let bold = NSMutableAttributedString.init(string: bold, attributes:[NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
        bold.append(NSMutableAttributedString.init(string: normal, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)] ))
        
        return bold
    }
}
struct Checker {
    
    static func isEmptyfor(content:String) -> Bool? {
        
        guard content.trimString.isEmpty else {
            print("Not Empty")
            return true
        }
        
        print("Empty")
        return false
    }
    
}


// String Extenion here for Validate trim String
extension String {
    
    // public typealias Index = String.CharacterView.Index
    
    //...
    
    //    public subscript (i: Index) -> Character { get }
    
    //    func tail(s: String,count:Int) -> String {
    //        return s.substringFromIndex(s.startIndex.advanced(by:count))
    //    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    
    var trimString:String {
        // return  self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet)
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func substring(from: Int) -> String {
        guard count >= from else { return self }
        let fromIndex = index(startIndex, offsetBy: from)
        return String(self[fromIndex..<endIndex])
    }
    
}

extension UILabel{
    /*@IBInspectable  var cornerRadius: Double {
     get {
     return Double(self.layer.cornerRadius)
     }set {
     self.layer.masksToBounds = true
     self.layer.cornerRadius = CGFloat(newValue)
     }
     }*/
    func setMultilineLabel(lbl:UILabel) {
        lbl.numberOfLines = 0
        //        lbl.translatesAutoresizingMaskIntoConstraints = true
      //  lbl.preferredMaxLayoutWidth = lbl.bounds.size.width
        //lbl.frame.size.width
        lbl.lineBreakMode = .byWordWrapping
       
        
    }
    
    
    
    
    /*class PaddingLabel: UILabel {
     
     var topInset: CGFloat
     var bottomInset: CGFloat
     var leftInset: CGFloat
     var rightInset: CGFloat
     
     required init(withInsets top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
     self.topInset = top
     self.bottomInset = bottom
     self.leftInset = left
     self.rightInset = right
     super.init(frame: CGRect.zero)
     }
     
     required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }
     
     override func drawText(in rect: CGRect) {
     let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
     super.drawText(in: rect.inset(by: insets))
     }
     
     override var intrinsicContentSize: CGSize {
     get {
     var contentSize = super.intrinsicContentSize
     contentSize.height += topInset + bottomInset
     contentSize.width += leftInset + rightInset
     return contentSize
     }
     }
     
     }*/
    
    
    
}
extension UISearchBar{
    func setBottomBorder(color:UIColor) {
        let border = UIView()
        border.frame = CGRect.init(x: 0.0, y: self.frame.height-1, width: self.frame.width, height: 1.0)
        //  border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        self.addSubview(border)
        //       tv.addSubview(border)
        //       self.superview?.addSubview(border)
        //            border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //            border.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //            border.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //            border.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        //        let bottomLine = CALayer()
        //        bottomLine.frame = CGRect.init(x: 0.0, y: tv.frame.height-1, width: tv.frame.width, height: 1.0)
        //        //CGRectMake(0.0, tf.frame.height - 1, tf.frame.width, 1.0)
        //        bottomLine.backgroundColor = UIColor.black.cgColor
        //        tv.layoutIfNeeded()
        //      //  tv.borderStyle = UITextField.BorderStyle.none
        //        //tv.layer.addSublayer(bottomLine)
        //        tv.addSubview(bottomLine)
    }
}
extension UIImageView{
    /*
     @IBInspectable  var cornerRadius: Double {
     get {
     return Double(self.layer.cornerRadius)
     }set {
     self.layer.masksToBounds = true
     self.layer.cornerRadius = CGFloat(newValue)
     }
     }*/
    
}
extension UIView{
    func setShadow(){
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3
    }
    @IBInspectable  var cornerRedius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = CGFloat(newValue)
        }
        
        
    }
    
    
    
    
    
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0 ,cornerradius:CGFloat) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            border.layer.cornerRadius = cornerradius
            addSubview(border)
            addConstraints(formats.flatMap {
                            NSLayoutConstraint.constraints(withVisualFormat: $0,
                                                           options: [],
                                                           metrics: ["inset": inset, "thickness": thickness],
                                                           views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
}

extension Date{
   
        static var yesterday: Date { return Date().dayBefore }
        static var tomorrow:  Date { return Date().dayAfter }
        var dayBefore: Date {
            return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
        }
        var dayAfter: Date {
            return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
        }
        var noon: Date {
            return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
        }
        var month: Int {
            return Calendar.current.component(.month,  from: self)
        }
        var isLastDayOfMonth: Bool {
            return dayAfter.month != month
        }
    
    func isSameDayAs(date2:Date)->Bool{
        let dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "yyyyMMdd"
        dateFormater.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
        let selfdate = Int(dateFormater.string(from: self ))
        let date2date = Int(dateFormater.string(from: date2))
        if(selfdate == date2date){
            return true
        }
        
        
        return false
    }
    
    func isEndDateIsSmallerThanCurrent(checkendDate:Date)->Bool
    {
        let enddate = checkendDate
        let currentdate = Date()
        let distancebtwdates = Int(enddate.timeIntervalSince(currentdate))
        let secondsInMinutes = 60
        let secondsbtwdates = distancebtwdates / secondsInMinutes
        if(secondsbtwdates == 0){
            return false
        }else if(secondsbtwdates < 0){
            return true
        }else{
            return false
        }
    }
    
    
   
    
    func isEndDateIsSmallerThanCurrent(firstDate:Date,seconddate:Date)->Bool
    {
//        let enddate = checkendDate
//        let currentdate = Date()
        let distancebtwdates = Int(seconddate.timeIntervalSince(firstDate))
        let secondsInMinutes = 60
        let secondsbtwdates = distancebtwdates / secondsInMinutes
        if(secondsbtwdates == 0){
            return false
        }else if(secondsbtwdates < 0){
            return true
        }else{
            return false
        }
    }
    
    func getCurrentMonth()->String{
        let dateformatter = DateFormatter.init()
        let calenderhelper = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let localehelper = Locale.init(identifier: "en_US")
        dateformatter.locale = localehelper
        dateformatter.calendar = calenderhelper
        dateformatter.dateFormat = "MM"
        return dateformatter.string(from: self)
    }
    
    func getCurrentYear()->String{
        let dateformatter = DateFormatter.init()
        let calenderhelper = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let localehelper = Locale.init(identifier: "en_US")
        dateformatter.locale = localehelper
        dateformatter.calendar = calenderhelper
        dateformatter.dateFormat = "yyyy"
        return dateformatter.string(from: self)
    }
    
    func dateCompareValue()->Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dateStr = dateFormatter.string(from: self)
        
        return Int(dateStr) ?? 0
        
        //return 0
    }
}
extension UITextField{
    func setImageRight(image:UIImage){
        let imageView = UIImageView()
        //  var image = UIImage(named: "email.png");
        imageView.image = image
        self.rightView = imageView
        rightViewMode = .always
    }
    
    func setAttributedPlaceHolder(color:UIColor,text:String){
        self.attributedPlaceholder = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor : color])
    }

    func setCommonFeature(){
        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        self.leftViewMode = .always
    }
   
//    myTextField.attributedPlaceholder = NSAttributedString(
//        string: "Placeholder Text",
//        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//    )
//    Swift 3:
//
//    myTextField.attributedPlaceholder = NSAttributedString(
//        string: "Placeholder Text",
//        attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]
//    )
    
    
    
    
    
}
extension UITextView{
    
    
    func setFlexibleHeight(){
        var frame = self.frame
        if(self.text.count == 0){
            frame.size.height = 70
            
            self.frame = frame
        }else{
        frame.size.height = self.contentSize.height
        
        self.frame = frame
        }
        // self.translatesAutoresizingMaskIntoConstraints = true
        // self.sizeToFit()
        self.isScrollEnabled = false
    }
    
    @objc func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func setBottomBorder(tv:UITextView) {
        let border = UIView()
        border.frame = CGRect.init(x: 0.0, y: tv.frame.height-1, width: tv.frame.width, height: 1.0)
        //  border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor.red
        //       tv.addSubview(border)
        //       self.superview?.addSubview(border)
        //            border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //            border.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //            border.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //            border.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        //        let bottomLine = CALayer()
        //        bottomLine.frame = CGRect.init(x: 0.0, y: tv.frame.height-1, width: tv.frame.width, height: 1.0)
        //        //CGRectMake(0.0, tf.frame.height - 1, tf.frame.width, 1.0)
        //        bottomLine.backgroundColor = UIColor.black.cgColor
        //        tv.layoutIfNeeded()
        //      //  tv.borderStyle = UITextField.BorderStyle.none
        //        //tv.layer.addSublayer(bottomLine)
        //        tv.addSubview(bottomLine)
    }
    
    //    func setImageRight(image:UIImage){
    //        let imageView = UIImageView()
    //      //  var image = UIImage(named: "email.png");
    //        imageView.image = image
    //        self.rightView = imageView
    //        rightViewMode = .always
    //    }
    
}

@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    //    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    //        var textRect = super.leftViewRect(forBounds: bounds)
    //        textRect.origin.x += leftPadding
    //        return textRect
    //    }
    
    
    
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    
    
    // Provides left padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= leftPadding //leftPadding
        //textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    // @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else  {
            if  let rimage = rightImage{
                rightViewMode = UITextField.ViewMode.always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.contentMode = .scaleAspectFit
                imageView.image = rimage
                // imageView.backgroundColor = UIColor.red
                // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
                imageView.tintColor = color // leftView = imageView
                rightView = imageView
                // leftView = imageView
            }else{
                leftViewMode = UITextField.ViewMode.never
                leftView = nil
            }
        }
        
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}

extension UIButton{
    //    @IBInspectable override var cornerRadius: Double {
    //        get {
    //            return Double(self.layer.cornerRadius)
    //        }set {
    //            self.layer.cornerRadius = CGFloat(newValue)
    //        }
    //    }
    
    //    @IBInspectable var titletextColor: UIColor {
    //        get {
    //            return titletextColor
    //        }set {
    //             self.currentTitleColor = titletextColor
    //        }
    //    }
    
    @IBInspectable open var bgColor: UIColor {
        get {
            return self.backgroundColor ?? UIColor.Appthemegreencolor
        }set {
            self.backgroundColor = bgColor
        }
    }
    
    
    func setrightImage(){
        self.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        // self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (self.titleLabel?.frame.width)!, bottom: 0, right: 0)
    }
    func setleftImage(){
        self.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .leftToRight ? .forceRightToLeft : .forceLeftToRight
        // self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (self.titleLabel?.frame.width)!, bottom: 0, right: 0)
    }
    func setbtnFor(title:String,type:String){
        if(type == Constant.kPositive){
            self.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.setTitle(title, for: UIControl.State.normal)
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            self.backgroundColor = UIColor.Appthemegreencolor
            self.translatesAutoresizingMaskIntoConstraints = false
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }else if(type == Constant.kNegative){
            self.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.setTitle(title, for: UIControl.State.normal)
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            self.backgroundColor = UIColor.systemRed
            // self.frame.size.height = 40
            self.translatesAutoresizingMaskIntoConstraints = false
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }else if(type == Constant.kNutral){
            self.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.setTitle(title, for: UIControl.State.normal)
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            self.backgroundColor = UIColor.Appskybluecolor
            // self.frame.size.height = 40
            self.translatesAutoresizingMaskIntoConstraints = false
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
}

extension Date{
    public static let D_MINUTE =  60
    func dateByAddingMinutes(min:Int)->Date{
        let  timeInterval = self.timeIntervalSinceReferenceDate + Double(Date.D_MINUTE) * Double(min)
        let date = Date.init(timeIntervalSinceReferenceDate: timeInterval)
        return date
        // let newdate = date
    }
}
class ButtonWithImage: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}

class TextFieldWithPadding: UITextField {
    
    //    @IBInspectable open var padding : UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) {
    //        didSet{
    //            self.setTextField()
    //        }
    //    }
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 5,
        bottom: 0,
        right: 0
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
}
