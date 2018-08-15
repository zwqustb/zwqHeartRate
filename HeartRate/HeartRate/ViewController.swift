//
//  ViewController.swift
//  HeartRate
//
//  Created by zhangwenqiang on 2018/8/2.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//

import UIKit
import SciChart
class ViewController: UIViewController {

    @IBOutlet weak var lText: UILabel!
    @IBOutlet weak var ChartParentView: UIView!
    var sciChartSurface: SCIChartSurface?
    var m_pHRModule:HeartRateModule?
    var timerSec = 0.0
    var timeAdd = 0.1
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.perform(#selector(initSciview), with: nil,  afterDelay:0.1)
        self.title = "心率监测"
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillDisappear(_ animated: Bool) {
        m_pHRModule?.stopMeasure()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.initSciview()
        m_pHRModule?.startMeasure()
    }
    @objc func initSciview() {
        sciChartSurface = SCIChartSurface(frame: ChartParentView.bounds)
        sciChartSurface?.translatesAutoresizingMaskIntoConstraints = true
        
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
            lText.text = "请用手指盖住摄像头"
        }else{
            lText.text = "有效帧数\(nFrame),心率\(nPulse),HRV\(nHRV),时间\(nSec)s"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: click
    @IBAction func onSliderChanged(_ sender: UISlider) {
        m_pHRModule?.setTorchLevel(sender.value)
    }
    @IBAction func clickTorch(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else{
             sender.isSelected = true
        }
        m_pHRModule?.setTorchState(sender.isSelected)
    }
    @IBAction func clickFps(_ sender: UISegmentedControl) {
        let nFps = sender.selectedSegmentIndex == 0 ? 10 : 30
        m_pHRModule?.setFps(Int32(nFps))
    }
    @IBAction func clickAbout(_ sender: UIButton) {
        let pWeb = WebVC.init(nibName: "WebVC", bundle: nil)
        pWeb.m_strUrl = "https://www.jianshu.com/p/a3be642221b2"
        pushView(pWeb)
    }
    
    @IBAction func clickNewWindow(_ sender: UIButton) {
        let pVC = CameraHeartRateVC.init(nibName: "CameraHeartRateVC", bundle: nil)
        pushView(pVC)
    }
}

