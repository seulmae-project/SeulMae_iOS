//
//  KPostalViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import UIKit
import WebKit

final class KPostalViewController: UIViewController {
    private let indicator = UIActivityIndicatorView(style: .medium)
    var completeHandler: (([String: Any]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        let contentController = WKUserContentController()
        contentController.add(self, name: "onComplete")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        var urlComponents = URLComponents(string: "https://yonggipo.github.io/kakao-postcode/")!
         var queryItems = urlComponents.queryItems ?? []
         queryItems.append(URLQueryItem(name: "kakaoMap", value: "true"))
        queryItems.append(URLQueryItem(name: "key", value: Bundle.main.javaScriptKey))
         urlComponents.queryItems = queryItems

        if let url = urlComponents.url {
            let request = URLRequest(url: url)
            webView.load(request)
            indicator.startAnimating()
        }
        
        view.addSubview(webView)
        view.addSubview(indicator)

        webView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension KPostalViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let bodyString = message.body as? String,
           let jsonData = bodyString.data(using: .utf8),
           let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            Swift.print(jsonDict)
            completeHandler?(jsonDict)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension KPostalViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
