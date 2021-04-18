//
//  ViewController.swift
//  Project04
//
//  Created by Alley Pereira on 15/04/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webview: WKWebView!
    var progressView: UIProgressView!
    var websites: [String]!
    var currentSite: Int!

    override func loadView() {
        super.loadView()
        webview = WKWebView()
        webview.navigationDelegate = self
        view = webview
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard websites != nil && currentSite != nil else {
            // print("Websites not set")
            navigationController?.popViewController(animated: true)
            return
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(openTapped))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: nil,
                                     action: nil)

        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh,
                                      target: webview,
                                      action: #selector(webview.reload))

        let goBack = UIBarButtonItem(title: "Back",
                                     style: .plain,
                                     target: webview,
                                     action: #selector(webview.goBack))

        let goForward = UIBarButtonItem(title: "Forward",
                                        style: .plain,
                                        target: webview,
                                        action: #selector(webview.goForward))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()

        let progressButton = UIBarButtonItem(customView: progressView)

        toolbarItems = [progressButton, spacer, refresh, goBack, goForward]
        navigationController?.isToolbarHidden = false

        webview.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        guard let url = URL(string: "https://" + websites[currentSite]) else { return }
        webview.load(URLRequest(url: url))
        webview.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped() {

        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)

        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {

        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webview.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        title = webview.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webview.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        // filter "about:blank" and show alert
        let urlString = url?.absoluteString ?? "Unknown"

        if urlString != "about:blank" {

            let ac = UIAlertController(title: "URL isn’t allowed", message: "Website \"\(urlString)\" it’s blocked.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }

        decisionHandler(.cancel)
    }
}
