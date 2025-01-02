//
//  BeatPlanListCalender.swift
//  SuperSales
//
//  Created by Apple on 10/08/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import FSCalendar
//import KVKCalendar
//import CVCalendar


class BeatPlanListCalender: BaseViewController, FSCalendarDataSource {
   // private weak var calendar: FSCalendar!
   // var arrevent = [Event]()
    var strselectedyear:String!
    var strselectedMonth:String!
    var selectedUserID:NSNumber!
    var userIDForBeatPlantList:NSNumber!
    var labelMy2:UILabel!
    static var calendar = FSCalendar()
    @IBOutlet weak var calenderView: UIView!
//    @IBOutlet weak var menuView: CVCalendarMenuView!
//    @IBOutlet weak var calendarView: CVCalendarView!
////    private var currentCalendar: Calendar?
//    @IBOutlet var calendarView: CVCalendarView!
//
//    @IBOutlet var menuView: CVCalendarMenuView!
//        public var animator: CVCalendarViewAnimator! {
//        return calendarView.animator
//    }
    
    
    //For event
//    var datesWithEvent = ["2021-08-03", "2021-08-06", "2021-08-10", "2015-10-25"]
//    var datesWithMultipleEvents = ["2015-08-08", "2015-10-16", "2015-10-20", "2015-10-28"]
//
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DispatchQueue.main.async {
      
        self.setUI()
//        }
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Function
  
    func setUI(){
       /* let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "fr_FR")
        if let timeZone = TimeZone(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
        self.menuView = CVCalendarMenuView.init(frame: self.menuview.view.frame)

               // CVCalendarView initialization with frame
        self.calendarView = CVCalendarView.init(frame:self.calendarView.frame)

               // Appearance delegate [Unnecessary]
               self.calendarView.calendarAppearanceDelegate = self
        
//        self.calendarView.backgroundColor = UIColor.green
//        self.menuview.view.backgroundColor = UIColor.yellow
//        self.view.backgroundColor = UIColor.red
//
//               // Animator delegate [Unnecessary]
      //        self.calendarView.animatorDelegate = self

               // Menu delegate [Required]
               self.menuView.menuViewDelegate = self

               // Calendar delegate [Required]
               self.calendarView.calendarDelegate = self*/
//        let calendar = CalendarView(frame: self.view.frame)
//        calendar.backgroundColor = .green
//        calendar.dataSource = self
//        self.view.addSubview(calendar)
//        calendar.reloadData()*/
        
        BeatPlanListCalender.calendar = FSCalendar(frame: CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - 200)) // FSCalendar(frame: calenderView.frame)
        BeatPlanListCalender.calendar.scrollEnabled = true
        BeatPlanListCalender.calendar.dataSource = self
        BeatPlanListCalender.calendar.delegate = self
        BeatPlanListCalender.calendar.appearance.headerMinimumDissolvedAlpha = 0
        BeatPlanListCalender.calendar.invalidateIntrinsicContentSize()
       // BeatPlanListCalender.calendar.frame.height = 200
            //  BeatPlanListCalender.calendar
        self.view.addSubview(BeatPlanListCalender.calendar)
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            // Commit frames' updates
//            self.menuView.commitMenuViewUpdate()
//            self.calendarView.commitCalendarViewUpdate()
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
/*extension BeatPlanListCalender:CalendarDelegate,CalendarDataSource{
    func eventsForCalendar() -> [Event] {
        return arrevent
    }
    
    
}*/
/*extension BeatPlanListCalender:CVCalendarViewAppearanceDelegate,AnimatorDelegate,CVCalendarViewDelegate,CVCalendarMenuViewDelegate{
    
 func didSelectDayView(dayView: DayView) {
    performSegue(withIdentifier: "test", sender: self)
  //  performSegue.
  //  peperformSegue withIdentifier: "yourNextViewControllerID", sender: self)
 }

    func selectionAnimation() -> ((DayView, @escaping ((Bool) -> ())) -> ()) {
        return selectionWithBounceEffect()
    }
    
    func deselectionAnimation() -> ((DayView, @escaping ((Bool) -> ())) -> ()) {
        return deselectionWithFadeOutEffect()
    }
    func selectionWithBounceEffect() -> ((DayView, @escaping ((Bool) -> ())) -> ()) {
        return {
            dayView, completion in
            dayView.dayLabel?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            dayView.selectionView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3,
                                       initialSpringVelocity: 0.1,
                                       options: UIView.AnimationOptions.beginFromCurrentState,
                                       animations: {
                dayView.selectionView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                dayView.dayLabel?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: completion)
        }
    }

    func deselectionWithBubbleEffect() -> ((DayView, @escaping ((Bool) -> ())) -> ()) {
        return {
            dayView, completion in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.6,
                                       initialSpringVelocity: 0.8,
                                       options: UIView.AnimationOptions.curveEaseOut, animations: {
                dayView.selectionView!.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { _ in
                UIView.animate(withDuration: 0.2, delay: 0,
                                           options: UIView.AnimationOptions(),
                                           animations: {
                    if let selectionView = dayView.selectionView {
                        selectionView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    }
                }, completion: completion)
            }
        }
    }
    func deselectionWithFadeOutEffect() -> ((DayView, @escaping ((Bool) -> ())) -> ()) {
        return {
            dayView, completion in
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6,
                                       initialSpringVelocity: 0, options: [], animations: {

                // return labels' defaults while circle view disappearing
                dayView.setDeselectedWithClearing(false)

                if let selectionView = dayView.selectionView {
                    selectionView.alpha = 0
                }
            }, completion: completion)
        }
    }

    func deselectionWithRollingEffect() -> ((DayView, @escaping ((Bool) -> ())) -> ()) {
        return {
            dayView, completion in
            UIView.animate(withDuration: 0.25, delay: 0,
                                       options: UIView.AnimationOptions(),
                                       animations: { () -> Void in
                dayView.selectionView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                dayView.selectionView?.alpha = 0.0
            }, completion: completion)
        }
    }
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.monday
    }
    
    
    
    
}*/
extension BeatPlanListCalender:FSCalendarDelegate{
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let beatplanlist = BeatPlanList.globalLimitBeatArr.sorted(by: {
            $0.BeatPlanDate.compare($1.BeatPlanDate) == .orderedAscending
        })
        self.dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
       
        for beat in beatplanlist{
            
            
            var beatplanNameStr = ""
            let strbeatdate = self.dateFormatter.string(from: date)
          
            let datefromstrcaldate = self.dateFormatter.date(from: strbeatdate) ?? Date()
            let dateappendingzerocal = Utils.getNSDateWithAppendingDay(day: 0, date1: datefromstrcaldate, format: "dd-MM-yyyy")
            let beatdate = self.dateFormatter.date(from: beat.BeatPlanDate) ?? Date()
            
            let dateappendingzero = Utils.getNSDateWithAppendingDay(day: 0, date1: beatdate, format: "dd-MM-yyyy")
            //
            
            if let gercal  = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian) as? NSCalendar{
                let sameday = gercal.isDate(dateappendingzero, inSameDayAs: dateappendingzerocal)
                
                if(sameday){
                    labelMy2 = UILabel(frame: CGRect(x: 1, y: cell.bounds.height - 20, width: cell.bounds.width, height: 20))
                    print("day = \(dateappendingzero) , == \(dateappendingzerocal)")
                    let listOfBeatPlanNameForSameDay = beatplanlist.filter(
                        {
                            self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                            
                            return $0.BeatPlanDate == self.dateFormatter.string(from: beatdate)
                        })
                    
                    let listofbeatPlanName = listOfBeatPlanNameForSameDay.map({
                        $0.BeatPlanName
                    })
                    let listofbeatPlanDate = listOfBeatPlanNameForSameDay.map({
                        $0.BeatPlanDate
                    })
                 
                    labelMy2.layer.cornerRadius = cell.bounds.width
                    labelMy2.textColor = UIColor.blue //UIColor.init(named: "#32C77F")
                    labelMy2.textAlignment = .center
                    labelMy2.font = UIFont.systemFont(ofSize: 8)
                    labelMy2.text = listofbeatPlanName.last as? String ?? "r" as! String
                    labelMy2.setMultilineLabel(lbl: labelMy2)
                    if(!cell.subviews.contains(labelMy2)){
                        cell.addSubview(labelMy2)
                    }else{
                        labelMy2.removeFromSuperview()
                    }
                    
                }
                else{
                  //  print("day = \(dateappendingzero) , !== \(dateappendingzerocal)")
                    labelMy2 = UILabel(frame: CGRect(x: 1, y: cell.bounds.height - 20, width: cell.bounds.width, height: 20))
                    labelMy2.layer.cornerRadius = cell.bounds.width
                    labelMy2.textColor = UIColor.blue //UIColor.init(named: "#32C77F")
                    labelMy2.textAlignment = .center
                    labelMy2.font = UIFont.systemFont(ofSize: 8)
                    labelMy2.text = " "
                    if(!cell.subviews.contains(labelMy2)){
                        cell.addSubview(labelMy2)
                        labelMy2.removeFromSuperview()
                    }else{
                        labelMy2.removeFromSuperview()
                    }
                }
                
                
                
                
            }
            
        }
    }

 
  
    func calendarCurrentPageDidChange(_ calender:FSCalendar){
        
    }
    
}
