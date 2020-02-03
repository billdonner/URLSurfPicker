# URLSurfPicker

0.0.6

A UIKit based Swift Package to permit user to surf the web visually 
       and select a url of interest
       
````swift

// present a URLSurfer and then
    var vc: URLSurfPicker.URLPickerNavigationController?
    func dism() {
        if vc != nil { vc?.dismiss(animated:true) { print("dismissed \(vc!)"); return }
        }
    }
    
    vc = URLSurfPicker.make([URL(string:"https://billdonner.com/halfdead/")!,  URL(string:"https://www.swiftbysundell.com/")!,URL(string:"https://www.hackingwithswift.com/")!, URL(string:"https://google.com")!],
                                 foreach: {[weak self] url in
                                    guard let self=self else {return}
                                    
                                    self.step1Results.text =  "\(url) picked"
                                    self.topMessage.text = "Step 2- Crawl for Interesting Files"
                                    self.hiddenset(false,true,true)
                                    self.buttset (false,true,false)
                                    self.resultset(true,false,false)
                                    self.view.setNeedsDisplay()
                                     dism()
                                    },
                                 finally: { allurl in print ("gotall \(allurl)") })
    present(vc!, animated: true)


````
