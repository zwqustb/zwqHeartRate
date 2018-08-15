//
//  CameraHeartRateVC.swift
//  HeartRate
//
//  Created by zhangwenqiang on 2018/8/7.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//

import UIKit

class CameraHeartRateVC: UIViewController {
    @IBOutlet weak var ChartParentView: UIView!
    @IBOutlet weak var lHR: UILabel!
    @IBOutlet weak var lHRA: UILabel!
    @IBOutlet weak var cicleProgress: HWCircleView!
    var sciChartSurface: SCIChartSurface?
    var m_pHRModule:HeartRateModule?
    var timerSec = 0.0
    var timeAdd = 0.1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "心率监测"
        cicleProgress.initParam()
        cicleProgress.progressColor = UIColor.init(red: 54.0/255.0, green: 216/255.0, blue: 63/255.0, alpha: 1)
        cicleProgress.padding = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        m_pHRModule?.stopMeasure()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.initSciview()
        m_pHRModule?.startMeasure()
        m_pHRModule?.setTorchLevel(0.1)
    }
    @objc func initSciview() {
        sciChartSurface = SCIChartSurface(frame: ChartParentView.bounds)
        sciChartSurface?.translatesAutoresizingMaskIntoConstraints = true
//
        
        ChartParentView.addSubview(sciChartSurface!)
        
        HeartRateChart.initChartView(sciChartSurface)
        
        m_pHRModule = HeartRateModule.init()
        m_pHRModule?.startMeasure()
        Timer.scheduledTimer(timeInterval: timeAdd, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    @objc func onTimer(){
        timerSec += timeAdd
        HeartRateChart.drawPoints(m_pHRModule?.points as! [Any]?, onView: sciChartSurface)
        let nFrame = m_pHRModule?.getFrame() ?? 0
        let nPulse = Int(m_pHRModule?.getPulse() ?? 0)
        let nHRV = m_pHRModule?.getHRV() ?? 0
        let nSec = Int(timerSec)
        if nFrame == 0{
            cicleProgress.progress = 0
            timerSec = 0
//            lText.text = "请用手指盖住摄像头"
        }else{
            let maxSec = 30.0
            let nProgress = timerSec > maxSec ? 1 : timerSec/maxSec
            cicleProgress.progress = CGFloat(nProgress)
//            lText.text = "有效帧数\(nFrame),心率\(nPulse),HRV\(nHRV),时间\(nSec)s"
        }
        lHR.text = "\(nPulse)"
        lHRA.text = "\(nHRV)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
