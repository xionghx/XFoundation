//
//  WebVC.swift
//  DepositExpress
//
//  Created by xionghuanxin on 09/01/2018.
//  Copyright © 2018 xionghuanxin. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import Kanna

class WKWebVC: BaseVC {
	var image: UIImage
	init(image: UIImage) {
		self.image = image
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	lazy var progressView:UIProgressView = {
		let view = UIProgressView(frame: CGRect(x: 0, y: 0, width: App.width, height: 1))
		view.progressTintColor = UIColor.app.navigationBar
		view.trackTintColor = UIColor.white
		return view
	}()
//	lazy var backItem:UIBarButtonItem = {
//		let button = UIButton(type: .custom)
//		button.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
//		button.setTitle("返回", for: .normal)
////		button.setImage(UIImage.init(named: "nav_back"), for: .normal)
////		button.setImage(UIImage.init(named: "nav_back"), for: .highlighted)
//		button.imageView?.snp.makeConstraints({ (make) in
//			make.left.equalTo(button)
//			make.height.equalTo(18)
//			make.width.equalTo(18)
//			make.centerY.equalTo(button)
//		})
//		button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//		button.setTitleColor(UIColor.white, for: .normal)
//		button.addTarget(self, action: #selector(backButonClicked), for: .touchUpInside)
//
//		let item = UIBarButtonItem.init(customView: button)
//		return item
//	}()
//	lazy var closeItem:UIBarButtonItem = {
//		let button = UIButton(type: .custom)
//		button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//		button.setTitle("关闭", for: .normal)
//		button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//		button.setTitleColor(UIColor.white, for: .normal)
//		button.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
//
//		let item = UIBarButtonItem.init(customView: button)
//		return item
//	}()
	lazy var indicator:Indicator = {
		let indicator = Indicator.init(frame: CGRect(x: 0, y: 0, width: view.frame.maxX, height: view.frame.maxY))
		return indicator
	}()
    @objc var url : String?
    lazy var webView:WKWebView = {

		let view = WKWebView()
		view.uiDelegate = self
		view.navigationDelegate = self
		view.allowsBackForwardNavigationGestures = true
		view.contentMode = UIView.ContentMode.scaleAspectFit
		view.scrollView.showsVerticalScrollIndicator = false
		view.scrollView.showsHorizontalScrollIndicator = false
		view.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
		view.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
		view.configuration.userContentController.add(self, name: "gologin")
//		view.configuration.preferences.javaScriptEnabled = true
//		view.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
		let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fh"), style: .plain, target: self, action: #selector(closeButtonClicked))
		leftBarButtonItem.tintColor = UIColor.white
		navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.app.navigationBar), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationItem.leftBarButtonItem = leftBarButtonItem

		setupSubView()
        loadData()
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		webView.stopLoading()
		webView.removeObserver(self, forKeyPath: "estimatedProgress")
		webView.removeObserver(self, forKeyPath: "title")
		let cache = URLCache.shared
		cache.removeAllCachedResponses()
		cache.diskCapacity = 0
		cache.memoryCapacity = 0
		super.viewDidDisappear(animated)
	}

    func setupSubView()  {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        view.addSubview(progressView)
    }

    func loadData()  {
//		if let htmlString = htmlString {
//			webView.loadHTMLString(htmlString, baseURL: nil)
//			return
//		}
		
		guard let urlString = url, let url = URL(string: urlString) else {
			return
		}

		let request = URLRequest(url: url)
        webView.load(request)
    }
	
	
//	@objc func backButonClicked() {
//		if self.webView.canGoBack {
//			self.webView.goBack()
//		}else{
//			self.dismiss(animated: true, completion: nil)
//		}
//
//	}
	@objc func closeButtonClicked(){
		if self.webView.canGoBack {
			self.webView.goBack()
		} else {
			self.dismiss(animated: true, completion: nil)

		}
	}
	


// MARK:<KVO>
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			guard self.webView == object as! WKWebView else{
				super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
				return
			}
			progressView.alpha = 1.0
			progressView.setProgress(Float(webView.estimatedProgress), animated: true)
			guard webView.estimatedProgress >= 10 else{
				return
			}
			UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseInOut, animations: {
				self.progressView.alpha = 0
			}, completion: { (finished) in
				self.progressView.setProgress(0, animated: false)
			})
		}else if keyPath == "title" {
			guard self.webView == object as! WKWebView else{
				super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
				return
			}
			if let title = self.webView.title {
				self.title = title
			}
		}else{
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
		}
	}
}
// MARK: <WKUIDelegate,WKNavigationDelegate>
extension WKWebVC:WKUIDelegate,WKNavigationDelegate{
	
	

	func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
		
	}
	//开始加载
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		print("WKWebView开始加载")
		self.view.addSubview(indicator)
		indicator.startAnimating()
	}
	//开始返回内容
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		print("WKWebView开始内容返回")

		indicator.stopAnimating()
	}
	//加载完成
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("WKWebView加载完成")
		indicator.stopAnimating()
//		navigationItem.leftBarButtonItems = [backItem,closeItem]
	}
	//加载失败
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print("WKWebView加载失败")
		indicator.stopAnimating()
//		Alert.showTip("加载失败")
	}
	
	//提示框
	func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		
//		UIAlertController.simpleAlert(title: "提示", message: message, controller: self)
	}
	//弹出框
	func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
		
//		UIAlertController.alert(title: "提示", message: message, controller: self) {
//			completionHandler(true)
//		}
	}
	//输入框
	func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
		
//		UIAlertController.inputPan(title: prompt, message: nil, defaultText: defaultText, controller: self) { (text) in
//			completionHandler(text)
//		}
	}
	
	//处理 target = "__blank"
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		
		print(navigationAction.request)
 		if let frame = navigationAction.targetFrame,frame.isMainFrame {
			
		}else{
			webView.evaluateJavaScript("var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}", completionHandler: nil)
		}

		decisionHandler(.allow)

	}

	func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
		
	}

}

class Indicator: UIActivityIndicatorView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.style = .whiteLarge
		self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}


extension WKWebVC: WKScriptMessageHandler {


	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		self.dismiss(animated: true) {

		}
	}

}
