# URLSurfPicker

0.0.6

A UIKit based Swift Package to permit user to surf the web visually 
       and select a url of interest
       
````swift

// present a URLSurfer and then
    let vc : UINavigationController =  URLSurfPicker.make([URL(string:"https://apple.com")!,
                              URL(string:"https://google.com")!],
                             foreach: { url in print("got \(url)") },
                             finally: { allurls in  print ("gotall \(allurls)") })
    present(vc, animated: true)


````
