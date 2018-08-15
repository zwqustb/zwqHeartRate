//
//  WebVC.swift
//  biniu
//
//  Created by zhangwenqiang on 2018/5/17.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//

import UIKit

class WebVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var cLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var m_pWebview: UIWebView!
    var m_strUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        m_pWebview.delegate = self
        let url = URL.init(string: m_strUrl)
        if url != nil {
            let req = URLRequest.init(url: url!)
            m_pWebview.loadRequest(req)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavgationHidden(false)
        //MBProgressHUD.showWaiting("正在加载数据", to: self.view)
    }
    func setUrl(_ strUrl:String){
        m_strUrl = strUrl
    }
    // MARK: - delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
//        MBProgressHUD.showWaiting("正在加载数据", to: webView)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //MBProgressHUD.closeWaiting()
        cLabelHeight.constant = 0
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        cLabelHeight.constant = 0
        //MBProgressHUD.closeWaiting()
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
