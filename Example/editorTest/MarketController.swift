//
//  ViewController.swift
//  editorTest
//
//  Created by Mohamed Hamed on 5/4/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit
import WebKit
//import iOSPhotoEditor


class MarketController: UIViewController, UITextFieldDelegate {

	//////
	@IBOutlet weak var ContainerWebview: UIView!
	@IBOutlet weak var refreshBtn: UIButton!
	@IBOutlet weak var linkTextfield: UITextField!
	
	//////
	var webView:WKWebView!
	var currentLink:String!
	
    override func viewDidLoad() {
		super.viewDidLoad();
		linkTextfield.delegate = self;
		
		//setting webview
		self.settingWebView();
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		linkTextfield.endEditing(true);
		return true;
	}
	
	func settingWebView (){
		// get link
		currentLink = linkTextfield.text;
		
		//set config webview
		let source = "var meta = document.createElement('meta');meta.name = 'viewport';meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';var head = document.getElementsByTagName('head')[0];head.appendChild(meta);";
		let script = WKUserScript.init(source: source, injectionTime: WKUserScriptInjectionTime(rawValue: 1)!, forMainFrameOnly: true);
		
		
		let userContentController = WKUserContentController.init();
		userContentController .addUserScript(script);
		userContentController.add(self, name: "sylvanasBridge");
		let configuration = WKWebViewConfiguration.init();
		configuration.userContentController = userContentController;
		
		// init & load webview
		let url = NSURL.init(string: currentLink);
		let request = NSURLRequest.init(url: url! as URL);
		webView = WKWebView.init(frame: ContainerWebview.bounds, configuration:configuration);
		webView.navigationDelegate = self;
		webView.uiDelegate = self;
		webView.translatesAutoresizingMaskIntoConstraints = true;
		webView.isOpaque = true;
		webView.scrollView.isScrollEnabled = true;
		webView.scrollView.bounces = true;
		webView.scrollView.bouncesZoom = true;
		webView.load(request as URLRequest);
		ContainerWebview.addSubview(webView);
	}
	
	//MARK - Handle action
	@IBAction func refreshBtnClicked(_ sender: Any) {
		if ((webView) != nil){
			webView.reload();
		}
	}
}


extension MarketController:WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		print(error.localizedDescription);
	}
	
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		print("start load content");
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("finish load content");
	}
}

extension MarketController:WKScriptMessageHandler{
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		//
	}
}
extension MarketController:WKUIDelegate{

}

