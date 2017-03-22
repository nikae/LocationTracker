//
//  activDetiledVC.swift
//  Trail Lab
//
//  Created by Nika on 3/15/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Charts

class activDetiledVC: UIViewController {
    //SegueactivDetiledVC
    @IBOutlet weak var imageView: UIImageView!
   
    @IBOutlet weak var altChartView: LineChartView!
    @IBOutlet weak var paceChartView: LineChartView!
    
    @IBOutlet weak var decView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    var arrADVC: [Trail] = []
    var vcId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        if arrADVC.count > 0 {
        let url = arrADVC[0].pictureURL
        getImage(url!, imageView: imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        headerLabel.text = arrADVC[0].activityName
        scrollView.delaysContentTouches = false
        
            
        var dPace:[Double] = []
        let maxAlt = String(format: "%.2f ft", arrADVC[0].altitudes.max()!)
            
        for i in arrADVC[0].pace {
           dPace.append(Double(i))
        }
        
        //MARK -Charts View
        chartView(chView: altChartView)
        chartView(chView: paceChartView)
        setChartData(alt: arrADVC[0].altitudes, cView: altChartView, lineColor: .black, labelText: "Altitudes with max: \(maxAlt)")
        setChartData(alt: dPace ,cView: paceChartView, lineColor: .black, labelText: "Pace")
        }
        
        decView.clipsToBounds = true
        decView.isUserInteractionEnabled = true
        decView.layer.cornerRadius = decView.frame.height/2
        
//        doneButton.clipsToBounds = true
//        doneButton.layer.cornerRadius = doneButton.frame.height/2
        buttShape(but: doneButton, color: bikeColor())
    }

    //MARK -Chart Method
    
    func chartView(chView: LineChartView) {
        chView.chartDescription?.text = "Tap node for details"
        chView.chartDescription?.textColor = .black
        chView.gridBackgroundColor = .blue
        chView.noDataText = "No data provided"
    }
    
    func setChartData(alt : [Double], cView: LineChartView, lineColor: UIColor, labelText: String) {
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in (0...alt.count - 1) {
            yVals1.append(ChartDataEntry(x: Double(i), y: Double(alt[i])))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: labelText)
        set1.axisDependency = .left
        set1.setColor(lineColor)
        set1.setCircleColor(UIColor.red)
        set1.lineWidth = 1.0
        set1.circleRadius = 1.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.black
        set1.highlightLineWidth = 1
       // set1.highlightEnabled = false
        set1.valueTextColor = UIColor.black
        set1.drawCircleHoleEnabled = true
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.gray)
        
        cView.data = data
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let dest = segue.destination as! CellOutletFromProfileVC
        dest.arr = arrADVC
        dest.vcId = vcId
    }
    
    
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        print("view Tapped")
    }

    @IBAction func doneHit(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goBack", sender: self)
        arrADVC.removeAll()
    }

}
