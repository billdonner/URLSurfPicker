// URLSurfer - by bill donner

import UIKit
import WebKit

struct URLSurfer {
    var text = "URLSurfer"
}

/**
 Choose a URL by Surfing the Internet
 */
public typealias SurfSig = (URL)->()
public typealias SurfSigS = ([URL])->()

protocol URLPickerDelegate:class {
    func didPickStartOfNewCrawl(url:URL)
    var  pickChoices:[ URL] { get }
}

open class URLSurfPicker {
    private(set) var coord: URLPickerCoordinator
    private(set)  var pvc: URLPickerViewController
    private(set) var nav : URLPickerNavigationController
    private init(_ urls:[URL], foreach:@escaping SurfSig , finally:@escaping SurfSigS) {
        self.coord = URLPickerCoordinator( urls, foreach:foreach, finally:finally)
        self.pvc =   URLPickerViewController( coord )
        self.nav =   URLPickerNavigationController(  pvc)
    }
    
    @available(iOS 13.0.0, *)
    public static func make(_ urls:[URL], foreach:@escaping SurfSig , finally:@escaping SurfSigS)-> URLSurfPicker.URLPickerNavigationController {
        let t = URLSurfPicker(urls,foreach:foreach,finally:finally)
        return t.nav
    }
    
    
    public final class URLPickerNavigationController:UINavigationController {
        
        private override init(rootViewController: UIViewController) {
            super.init(rootViewController:rootViewController)
        }
        
        convenience init(_ rvc: UIViewController) {
            self.init(rootViewController: rvc)
            hidesBarsOnTap = false
            hidesBarsOnSwipe = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
     final class URLPickerCoordinator: URLPickerDelegate {
        var pickChoices:[URL]
        var allPicked:[URL]
        var foreach:SurfSig
        var finally:SurfSigS
        init(_ pickChoices:[URL], foreach:@escaping SurfSig, finally:@escaping SurfSigS) {
            self.pickChoices = pickChoices
            self.finally = finally
            self.foreach = foreach
            self.allPicked = []
        }
        func didPickStartOfNewCrawl(url: URL) {
            foreach(url)
            allPicked.append(url)
        }
        func didPickCancel() {
            finally(allPicked)
        }
    }
     class URLPickerController:UINavigationController {
        
        private override init(rootViewController: UIViewController) {
            super.init(rootViewController:rootViewController)
        }
        convenience init(_ rvc: UINavigationController) {
            self.init(rootViewController: rvc)
            hidesBarsOnTap = false
            hidesBarsOnSwipe = false
            
        }
        required internal init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }
    }
     final class URLPickerViewController: UIViewController, WKNavigationDelegate {
        
        var coordinator: URLPickerCoordinator?
        
        
        private var websites : [URL]!
        private var webView: WKWebView!
        private var progressView: UIProgressView!
        private var currentURLForUser : URL? = nil
        
        deinit {
            // must do this explicitly because not weak
        }
        private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nil, bundle: nil)
        }
        convenience init(_ coordinator:URLPickerCoordinator){
            self.init(nibName: nil, bundle: nil)
            self.coordinator = coordinator
        }
        internal required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        @objc private func goBack() {
            if webView.canGoBack {
                webView.goBack()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        @objc private func goForward() {
            if webView.canGoForward {
                webView.goForward()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        @objc private func selectcurrentURLForUser() {
            print("****** \(currentURLForUser!) ******")
            coordinator?.didPickStartOfNewCrawl(url: currentURLForUser!)
        }
        @objc private func openTapped() {
            let ac = UIAlertController(title: "Pick site to crawl", message: nil, preferredStyle: .actionSheet)
            
            for website in websites {
                ac.addAction(UIAlertAction(title: website.absoluteString, style: .default, handler: openPage))
            }
            ac.addAction(UIAlertAction(title: "Choose...", style: .default) { action in
                self.showAlertWithTextField() { url in
                    if let url = url {  self.webView.load(URLRequest(url:url)) }}
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            present(ac, animated: true)
        }
        
        private func possiblyTryAgain(finally: @escaping ((URL?)->())) {
            let alertController = UIAlertController(title: "Enter a Good URL", message: "that was pretty bad", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in self.showAlertWithTextField(finally: finally)}
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
        }
        private func showAlertWithTextField(finally: @escaping ((URL?)->())) {
            let alertController = UIAlertController(title: "Pick Starting URL", message: "scanning begins at this point", preferredStyle: .alert)
            let openAction = UIAlertAction(title: "Pick", style: .default) { (_) in
                if let txtField = alertController.textFields?.first, let text = txtField.text {
                    // operations
                    print("Text==>" + text)
                    if let url = URL(string:text) {
                        finally(url)
                    }
                    else {
                        self.possiblyTryAgain(finally: finally)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            alertController.addTextField { (textField) in
                textField.placeholder = "URL"
            }
            alertController.addAction(openAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
        override func loadView() {
            
            webView = WKWebView()
            webView.navigationDelegate = self
            view = webView
        }
        
        private func setupToolbar() {
            progressView = UIProgressView(progressViewStyle: .default)
            progressView.sizeToFit()
            let progressButton = UIBarButtonItem(customView: progressView)
            
            let selectpage = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(openTapped))
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
            
            let goright = webView.canGoForward ? UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(goForward)) : spacer
            
            let goleft = webView.canGoBack ? UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(goBack)): spacer
            
            toolbarItems = [progressButton, spacer, refresh,spacer,spacer, goleft,spacer,goright,spacer, selectpage]
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            websites = coordinator?.pickChoices
            let url = websites[0]
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            navigationItem.rightBarButtonItems = [ UIBarButtonItem(title: "Use This", style: .plain, target: self, action: #selector(selectcurrentURLForUser))]
            setupToolbar()
            navigationController?.isToolbarHidden = false
            
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        }
        private func choosePage(action: UIAlertAction) {
            showAlertWithTextField() { url in
                if let url = url {
                    self.currentURLForUser = url //keep it updated
                    self.webView.load(URLRequest(url:url))}
            }
        }
        
        
        private func openPage(action: UIAlertAction) {
            let surl = URL(string: action.title!)
            guard let url = surl else {
                fatalError("Inbuilt page is broken")
            }
            currentURLForUser = url //keep it updated
            webView.load(URLRequest(url: url))
        }
        
        // these are wkwebview delegates
        //MARK: - when finishing load of new page, rebuild toolbar
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            title = webView.title
            setupToolbar()
        }
        
        @available(iOS 13.0, *)
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            if let url = navigationAction.request.url {
                currentURLForUser = url
                decisionHandler(.allow, preferences)
            }
        }
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress" {
                progressView.progress = Float(webView.estimatedProgress)
            }
        }
    }
    
}

