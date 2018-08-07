//
//  DetailViewController.swift
//  MyPhotoViewer
//
//  Created by Jim on 2018/6/14.
//  Copyright © 2018年 Jim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController , UIScrollViewDelegate {

    @IBOutlet weak var timeIntervalSilder: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var targetIndex = -1    //預設值 或異常狀態
    var dataManager : DataManager!
    var timer : Timer?      //nstimer  在obj-c
    
    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @IBAction func timeIntervalChanged(_ sender: UISlider) {//又創造一個 來取代原來的
        //改參數就重新new一個設參數
        //Stop a timer
        timer?.invalidate() //停止
        timer = nil
        
        //start
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeIntervalSilder.value), target: self, selector: #selector(perforSlideShowJob), userInfo: nil, repeats: true)
    }
    
    @objc
    func perforSlideShowJob()  {//看起來像是 自己刻出一個動畫效果  ？？
        
        //Prepare animartion
        let transition = CATransition()  //控制旋轉 縮放的物件
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        imageView.layer.add(transition, forKey: nil)    //UIkit 底層c: layer
        
        self.targetIndex += 1
        if self.targetIndex >=  self.dataManager.count {//到正邊界 = 第一張
            self.targetIndex = 0
        }
        configureView()
        
        print("\(Date()):perforSlideShowJob exeuted at \(self.description)")
    }
    
    @IBAction func playStopBtnPressed(_ sender: Any) {//切換圖示而已
        
        if timeIntervalSilder.isHidden {    //播放時
            timeIntervalSilder.isHidden = false
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(playStopBtnPressed(_:)))
            //在右邊建立一個新按鈕 圖示改為 停止 執行的功能與原來的相同
            
            //創造一個新的按鈕取代 舊的按鈕
            
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeIntervalSilder.value), target: self, selector: #selector(perforSlideShowJob), userInfo: nil, repeats: true)
            //上面是創造 timer
        } else {                                //停止時
            timeIntervalSilder.isHidden = true
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playStopBtnPressed(_:)))
            
            //Stop a timer
            timer?.invalidate() //important     //必須 timer 設nil不會有效
            timer = nil     //沒用會造成記憶體鎖住
        }
    }
    
    func configureView() {          //取讀圖片 並且可以放大 一個刻度一倍
        // Update the user interface for the detail item.
        
        guard let imageView = imageView ,
            let image = dataManager.image(at: targetIndex) else {
            return
        }
        
        imageView.image = image
        //Prepare zoom in/out support
        scrollView.contentSize = image.size
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    deinit{
        print("DetailVC deinit")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop timer if it exist
        if timer != nil {
            playStopBtnPressed(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.autoAdSc             //讓side 邊界 可以自動調整。（超過上面ㄒnav...item時也能稍微顯示）
        
        scrollView.delegate = self
        
        dataManager = DataManager.shared
        print("")
        
        configureView()
        
        //Add gesture recognizers.
        let toleft = UISwipeGestureRecognizer(target: self, action: #selector(toLeft))
        toleft.direction = .left
        imageView.addGestureRecognizer(toleft)
        
        let toright = UISwipeGestureRecognizer(target: self, action: #selector(toRight))
        toright.direction = .right
        imageView.addGestureRecognizer(toright)
        
        imageView.isUserInteractionEnabled = true   //Important  與使用者互相作用
        
        //Hide slider when launch.
        timeIntervalSilder.isHidden = true          //默認隱藏
    }

    
    
    @objc
    func toRight()  {
        UIView.transition(with: imageView, duration: 0.7, options: [.transitionFlipFromLeft, .curveEaseIn], animations: {//動畫中做的事
            
            self.targetIndex -= 1
            if self.targetIndex < 0 {//到負邊界 = 切到最後一張
                self.targetIndex = self.dataManager.count - 1
            }
            self.configureView()//換圖片
            
        }) {(finish) in  //動畫完成時 可以做的事
            //...
        }
    }
    
    @objc
    func toLeft()  {
        UIView.transition(with: imageView, duration: 0.7, options: [.transitionFlipFromRight, .curveEaseIn], animations: {
            
            self.targetIndex += 1
            if self.targetIndex >=  self.dataManager.count {//到正邊界 = 第一張
                self.targetIndex = 0
            }
            self.configureView()

        }) {(finish) in  //動畫完成時 可以做的事
            //...
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

