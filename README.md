# URLSurfPicker

0.0.2

A UIKit based Swift Package to permit user to surf the web visually 
       and select a url of interest
````swift


let vc =   URLSurfPicker([URL(string:"https://apple.com")!,
                          URL(string:"https://google.com")!],
                         finally: { url in
            print("u slected \(url)!")
})

````
