//
//  DahboardCell.swift
//  SuperSales
//
//  Created by Apple on 11/03/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

//import Foundation
// @IBOutlet var chartView: HorizontalBarChartView!
import UIKit
import Charts
//import DGCharts
//import SwiftCharts

class DashboardCell: UITableViewCell {
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return "10/10/2021"
////        let record_ARRAY = record_ARRAY.sorted(by: {$0.date < $1.date})
////
////        let date = record_ARRAY[Int(value)].date
////
////        return ReusableClass.typeThreeDateFormat(date: date)
//    }
    

    @IBOutlet weak var heightOfChartView: NSLayoutConstraint!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
  //  @IBOutlet var chartView: HorizontalBarChartView!
    
    
    
    @IBOutlet weak var assignedBarchartView: HorizontalBarChartView!
    
//    @IBOutlet weak var updatedBarChartView: HorizontalBarChartView!
//    @IBOutlet weak var addedBarChartView: HorizontalBarChartView!

    
    
//    var currentChartFor = ChartFor.visitDone
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle =  UITableViewCell.SelectionStyle.none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDashboardVisitData(report:VisitDashboardReport,indexpath:IndexPath){
        self.lbl3.isHidden = true
        self.lbl2.textColor = UIColor.gray
        self.lbl1.text = report.UserName
        self.lbl1.font = UIFont.boldSystemFont(ofSize: 16)
      // self.lbl3.isHidden  = true
        self.lbl2.font = UIFont.systemFont(ofSize: 13)
        self.lbl3.font = UIFont.systemFont(ofSize: 12)
        if let  planned = report.PlannedVisit as? NSInteger{
        self.lbl2.text = String.init(format: "\(planned) planned", [])
        }else{
             self.lbl2.text = ""
        }
        
        var visitCount = [Int]()
        self.assignedBarchartView.isHidden = true
           var updateVisitCount = 0
            if let updatedvisit = report.ActualVisit as? NSInteger{
                if(updatedvisit > 0){
                    //sliderX.value = Float(updatedvisit)
                    self.assignedBarchartView.isHidden = false
                    updateVisitCount = updatedvisit
 
                }
                visitCount.append(updateVisitCount)
//                self.chartView.isHidden = false
                self.lbl3.text?.append(String.init(format:"\(updatedvisit) u",[]))
            }
        var DoneVisit = 0
        
        if let donevisit = report.MissedVisit as? NSInteger{
          //  sliderX.isHidden = true
            self.lbl3.text = String.init(format:"\(donevisit) m",[])
//            self.assignedBarchartView.isHidden = true
          
            if(donevisit > 0){
                self.assignedBarchartView.isHidden = false
                DoneVisit  = donevisit
              //  self.setDataCount(Int(donevisit), range: 50, chart:self.assignedBarchartView)
            }
            visitCount.append(DoneVisit)
        }else{
             self.lbl3.text = ""
            self.assignedBarchartView.isHidden = true
        }
            var doneVisitCount = 0
            if let donevisit = report.UpdatedVisit as? NSInteger{
                if(donevisit  > 0){
                    self.assignedBarchartView.isHidden = false
                    doneVisitCount = donevisit
//                    self.setDataCount(Int(donevisit), range: 50, chart: self.assignedBarchartView)
                
                }
                
                visitCount.append(doneVisitCount)
               
                self.lbl3.text?.append(String.init(format:"\(donevisit) d",[]))
//                self.chartView.getPosition(entry: ChartDataEntry.init(x: 1, y: 5), axis: YAxis.AxisDependency.left)
//                self.assignedBarchartView.fitBars = true
              
           
                
               
               
               // self.chartView.draw(CGRect.init(x: 0, y: 1, width: self.chartView.frame.width-2, height: self.chartView.frame.height-2))
            }
          
           // self.chartView.data = IBarChartDataSet().entryForXValue(3)
           /* let chartConfig = BarsChartConfig(
                valsAxisConfig: ChartAxisConfig(from: 0, to: 8, by: 2)
            )

            let frame = self.chartView.frame
                    
            let chart = BarsChart(
                frame: frame,
                chartConfig: chartConfig,
                xTitle: "X axis",
                yTitle: "Y axis",
                bars: [
                    ("A", 2),
                    ("B", 4.5),
                    ("C", 3),
                    ("D", 5.4),
                    ("E", 6.8),
                    ("F", 0.5)
                ],
                color: UIColor.red,
                barWidth: 20
            )

            self.chartView.addSubview(chart.view)*/
           // self.chart = chart
           
        
        self.setDataCount(visitCount, range: 50, chart: self.assignedBarchartView, typeOfData: "Visit")
        if(report.ColorCode == NSInteger.init(CGFloat(1))){
            lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x35DF8F)
        }else if(report.ColorCode == NSInteger.init(CGFloat(2))){
            lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x45A0CD)
        }else{
            lbl1.textColor = UIColor.gray
        }
//        self.assignedBarchartView.fitBars = true
//        let xAxis = self.assignedBarchartView.xAxis
//        xAxis.labelPosition = .bottom
//        xAxis.labelFont = .boldSystemFont(ofSize: 10)//.systemFont(ofSize: 10)
//        xAxis.drawAxisLineEnabled = true
//        xAxis.granularity = 10
//        self.assignedBarchartView.delegate = self
//        self.assignedBarchartView.drawBarShadowEnabled = false
//        self.assignedBarchartView.drawValueAboveBarEnabled = true
//        self.assignedBarchartView.chartDescription?.enabled = false
//
//        self.assignedBarchartView.dragEnabled = true
//        self.assignedBarchartView.setScaleEnabled(true)
//        self.assignedBarchartView.pinchZoomEnabled = false
        
        // ChartYAxis *leftAxis = chartView.leftAxis;
        
        self.lbl3.isHidden = true
        
       
}
    
    func setDashboardLeadData(leadReport:LeadDashboardReport,indexpath:IndexPath){
        self.lbl3.isHidden = true
        self.lbl2.textColor = UIColor.gray
        self.lbl1.font = UIFont.boldSystemFont(ofSize: 16)
        self.lbl2.font = UIFont.systemFont(ofSize: 13)
        self.lbl3.font = UIFont.systemFont(ofSize: 12)
      //  self.lbl3.isHidden  = true
        self.lbl3.isHidden = false
        
        var leadCount = [Int]()
        var assignedLeadCount = 0
//        if let  planned = leadReport.AssignedLead as? NSInteger{
//        self.lbl2.text = String.init(format: "\(planned) lead", [])
//        }else{
//             self.lbl2.text = ""
//        }
//        if let assigned = leadReport.AssignedLead as? NSInteger{
//            self.lbl3.text = String.init(format:"as \(assigned)")
//            if let generated = leadReport.GeneratedLead as? NSInteger{
//                self.lbl3.text?.append(" ad \(generated)")
//                if let updated = leadReport.UpdatedLead as? NSInteger{
//                    self.lbl3.text?.append("up \(updated  )")
//                }
//            }
//        }
        if let donevisit = leadReport.AssignedLead as? NSInteger{
          //  sliderX.isHidden = true
         //   self.lbl3.text = String.init(format:"\(donevisit) m",[])
            self.assignedBarchartView.isHidden = true
            
            var  strpersonname = [Date]()
            var leadData =  [NSInteger]()
            if(donevisit > 0){
                assignedLeadCount = donevisit
                assignedBarchartView.isHidden = false
         
                leadData.append(donevisit)

           
            }
            leadCount.append(assignedLeadCount)
           
            var generatedLeadCount = 0
            if let updatedvisit = leadReport.GeneratedLead{
                if(updatedvisit > 0){
                  
                    assignedBarchartView.isHidden = false
                 
                    generatedLeadCount = updatedvisit
                    leadData.append(updatedvisit)
                }
                leadCount.append(updatedvisit)

            }
            var updatedLeadCount = 0
            if let donevisit = leadReport.UpdatedLead{
                if(donevisit  > 0){
                   
                    assignedBarchartView.isHidden = false
                    updatedLeadCount = donevisit
                
                    leadData.append(donevisit)
                }
                leadCount.append(updatedLeadCount)
              
              //  self.lbl3.text?.append(String.init(format:"\(donevisit) d",[]))

               
                
              
                
                

            }
          
        }else{
             self.lbl3.text = ""
          
        }
        self.setDataCount(leadCount, range: 50, chart: self.assignedBarchartView, typeOfData: "Lead")
       // self.lbl3.text = String.init(format:"as \(leadReport.AssignedLead) ad\(leadReport.GeneratedLead) u\(leadReport.UpdatedLead)",[])
               if(leadReport.ColorCode == NSInteger.init(CGFloat(1))){
                   lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x35DF8F)
               }else if(leadReport.ColorCode == NSInteger.init(CGFloat(2))){
                   lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x45A0CD)
               }else{
                   lbl1.textColor = UIColor.gray
               }
        self.lbl2.isHidden = true
        self.lbl3.isHidden = true
    }
    
    func setDashboardOrderData(orderReport:OrderDashboardReport,indexpath:IndexPath){
        self.lbl2.textColor = UIColor.gray
        self.lbl3.textColor = UIColor.gray
          self.lbl2.isHidden = false
        self.lbl3.isHidden = false
        self.lbl1.font = UIFont.boldSystemFont(ofSize: 16)
        self.lbl2.font = UIFont.systemFont(ofSize: 13)
        self.lbl3.font = UIFont.systemFont(ofSize: 13)
        if let  planned = orderReport.GeneratedSalesOrder as? NSInteger{
       self.lbl3.text   = String.init(format: "\(planned) Orders", [])
        }else{
          self.lbl3.text  = ""
        }
        if let  amount = orderReport.TotalAmount as? Double{
           //  var rupeeSymbol = india.NumberFormat.CurrencySymbol
            self.lbl2.text =  String.init(format:"\("₹") \(amount)",[])
       //  self.lbl2.text   = String.init(format: "\(Utils().getActiveAccount()?.company?.currCode ?? "$") \(amount)", [])
        }else{
             self.lbl2.text   = ""
        }
       if(orderReport.ColorCode == NSInteger.init(CGFloat(1))){
            lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x35DF8F)
        }else if(orderReport.ColorCode == NSInteger.init(CGFloat(2))){
            lbl1.textColor = Common().UIColorFromRGB(rgbValue:0x45A0CD)
        }else{
            lbl1.textColor = UIColor.gray//Common().UIColorFromRGB(rgbValue:0x000000)
        }
    }
    
    
    //Mark : Chart method
    func setDataCount(_ count: [Int], range: UInt32,chart:HorizontalBarChartView,typeOfData:String) {
       
        let spaceForBar = 1.0
        
        var yVals = [BarChartDataEntry]()
      // var set1 = BarChartDataSet()
        if(typeOfData == "Lead"){
         yVals = [BarChartDataEntry(x: 1.0 * spaceForBar  , y: Double(count[0]) , icon: nil),BarChartDataEntry(x: 2.0 * spaceForBar  , y: Double(count[1]) , icon: nil),BarChartDataEntry(x: 3.0 * spaceForBar  , y: Double(count[2]) , icon: nil)]
          //  [BarChartDataEntry(x: Double(count[0]), y: 1.0 * spaceForBar , icon: nil),BarChartDataEntry(x: Double(count[1]), y: Double(5.0 * spaceForBar), icon: nil),BarChartDataEntry(x: Double(count[2]), y: Double(7.0  * spaceForBar), icon: nil)]//[BarChartDataEntry(x: Double(1)*spaceForBar, y: Double(count))]
           
          
        }else{
            yVals = [BarChartDataEntry.init(x:  1 * spaceForBar, yValues: [Double(count[0]),Double(count[1]),Double(count[2])])]
          //  yVals = [BarChartDataEntry(x: 1 * spaceForBar  , y: Double(count[0]) , icon: nil),BarChartDataEntry(x: 1 * spaceForBar , y: Double(count[0]) + Double(count[1]) , icon: nil),BarChartDataEntry(x:  1 * spaceForBar , y: Double(count[0]) + Double(count[1]) + Double(count[2] )  , icon: nil)]
         //   yVals = [BarChartDataEntry(x: 1 * spaceForBar  , y: Double(count[0]) , icon: nil),BarChartDataEntry(x: Double(count[0])  , y: Double(count[1]) , icon: nil),BarChartDataEntry(x:  Double(count[1]) , y: Double(count[2] )  , icon: nil)]
          //  yVals = [BarChartDataEntry(x: 1 * spaceForBar  , y: Double(count[0]) , icon: nil),BarChartDataEntry(x: 1 * spaceForBar , y: Double(count[1]) , icon: nil),BarChartDataEntry(x:  1 * spaceForBar , y: Double(count[2] )  , icon: nil)]
          
        }
       
        let  set1 = BarChartDataSet(entries: yVals, label: "")
        if(typeOfData == "Lead"){
            self.heightOfChartView.constant = 120
            set1.colors = [UIColor.systemBlue,UIColor.systemGreen,UIColor.systemOrange]
            chart.rightAxis.enabled = false//true
            chart.rightAxis.drawLabelsEnabled = false//true
        }else{
            self.heightOfChartView.constant = 60
            chart.rightAxis.enabled = false
            chart.rightAxis.drawLabelsEnabled = false
            set1.colors = [UIColor.systemGreen,UIColor.systemYellow,UIColor.systemRed]
           
        }
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:15)!)
        data.setValueFont(.boldSystemFont(ofSize: 10))
        data.setValueTextColor(UIColor.white)
        
        
        // For hide border values
        chart.leftAxis.enabled = false
        
        chart.drawBordersEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        
        chart.drawGridBackgroundEnabled = false
        chart.drawValueAboveBarEnabled = false
        chart.delegate = self
        chart.xAxis.granularityEnabled = false
        chart.xAxis.enabled = true
        chart.xAxis.drawLabelsEnabled = true
        chart.legend.enabled = false
        chart.xAxis.granularity =  30.0
       // chart.xAxis.enabled = true
        // for set color
        
        
        // disable zoom
        chart.setScaleEnabled(false)
        chart.dragEnabled = false
        chart.doubleTapToZoomEnabled = false
    
      //  data.barWidth = barWidth
       // chart.drawValueAboveBarEnabled = false
    //    chart.xAxis.labelPosition = .bottom
//        chart.drawGridBackgroundEnabled = false
//        chart.drawBordersEnabled = false
        
        chart.data = data
    }
   //    func setDataDount(_ )
//        func createBarChart(dataPoints: [Date], values: [NSInteger])
//        {
////            var dataPoints1 =  [Date]()
////
////            dataPoints1 = [2017-08-05, 2017-08-06, 2017-08-06, 2017-08-07]
////            dataPoints =  dataPoints1
//        let zoomXMultiplier = 1.0
//        let barWidthMultiplier =  2.0
//        var dataEntries: [BarChartDataEntry] = []
//
//            for index in 0..<dataPoints.count
//            {
//                let dataEntry = BarChartDataEntry(x: Double(index),
//                                                  y: Double(index))
//
//                dataEntries.append(dataEntry)
//            }
//
//           self.assignedBarchartView.xAxis.valueFormatter = self
//
//            self.assignedBarchartView.xAxis.granularity = 1
//
//            self.assignedBarchartView.xAxis.setLabelCount(dataPoints.count, force: false)
//
//            self.assignedBarchartView.animate(yAxisDuration: 1.0, easingOption: .easeInOutQuad)
//
//            let chartDataSet = BarChartDataSet(entries: dataEntries, label: "test")
//            let chartData = BarChartData(dataSet: chartDataSet)
//
//            self.assignedBarchartView.data = chartData
//
//            self.assignedBarchartView.zoom(scaleX: CGFloat(zoomXMultiplier), scaleY: 0.0, x: 0, y: 0)
//
//            self.assignedBarchartView.barData?.barWidth = barWidthMultiplier
//      /*  let barWidth = 5.0//9.0
//        let spaceForBar = 1.0 //10.0
//        
//        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
//            let mult = range + 1
//            let val = Double(arc4random_uniform(mult))
//            return BarChartDataEntry(x: Double(i)*spaceForBar, y: val, icon: UIImage.init(named: "icon_arrow_right"))
//        }
//        
//        let set1 = BarChartDataSet(entries: yVals, label: "DataSet")
//        set1.drawIconsEnabled = false
//        
//        let data = BarChartData(dataSet: set1)
//        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
//        data.barWidth = barWidth
//        data.setValueTextColor(NSUIColor.init(red: 255, green: 0, blue: 0, alpha: 1))
//        switch currentChartFor {
//        case ChartFor.visitDone:
//            self.assignedBarchartView.data = data
//            break
//            
//        case ChartFor.visitUpdated:
//            self.assignedBarchartView.data = data
//            break
//            
//        case ChartFor.visitMissed:
//            self.assignedBarchartView.data = data
//            break
//            
//        case ChartFor.leadAssigned:
//            self.assignedBarchartView.data = data
//            break
//        case ChartFor.leadAdded:
//            self.addedBarChartView.data = data
//            break
//        case ChartFor.leadUpdated:
//            self.updatedBarChartView.data = data
//            break
//            
//        default:
//            break
//        }*/
//       
//    }

}
extension DashboardCell:ChartViewDelegate{
    
}
