//
//  WelcomeViewController.swift
//  FirstStage
//
//  Created by Scott Freshour on 12/1/18.
//  Copyright © 2018 Musikyoshi. All rights reserved.
//

import Foundation

class WelcomeViewController: UIViewController, UIScrollViewDelegate {
    
    // Ultimately want to calc this dynamically, at runtime . . .
    let kScrollContentHt = CGFloat(1340.0)
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var WelcomeTitleLabel: UILabel!
    
    @IBOutlet weak var howToUsePTLabel: UILabel!
    @IBOutlet weak var howToUseDetailsLabel: UILabel!
    
    @IBOutlet weak var tryOutPTForFreeLabel: UILabel!
    @IBOutlet weak var tryOutPTForFreeDetailsLabel: UILabel!
    
    @IBOutlet weak var accessUpperLevelsLabel: UILabel!
    @IBOutlet weak var accessUpperLevelsDetailLabel: UILabel!
    @IBOutlet weak var subsDetailLabel: UILabel!
    
    // OK, Privacy Policy, and Terms of Use buttons are in this view
    // @IBOutlet weak var bottomButtonsEnclosingView: UIView!
    
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    @IBAction func privacyPolicyBtnPressed(_ sender: Any) {
        if let privPolicyURL = URL(string: kMKPrivacyPolicyURL) {
            UIApplication.shared.open(privPolicyURL, options:[:])
        }
    }
    
    @IBAction func termsOfUseBtnPressed(_ sender: Any) {
        if let termsURL = URL(string: kMKTermsOfUseURL) {
            UIApplication.shared.open(termsURL, options:[:])
        }
    }
    
//    @IBAction func okayBtnPressed(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        if DeviceType.IS_IPHONE_5orSE {
            WelcomeTitleLabel.font = UIFont(name: "Futura-Bold", size: 27.0)
        }
        
        // var howToUseDetText = "\u{2022} Select “Levels” to see the\n   available Practice Levels\n"
        // howToUseDetText += "\u{2022} Select a Level to see the Days\n   within that Level\n"
        // howToUseDetText += "\u{2022} Select a Day to display the exercises\n   within that Day, then:\n"
        // howToUseDetText += "   > Select 'Go' to automatically step through a guided practice session, or\n"
        // howToUseDetText += "   > Select 'Choose' to pick individual exercises\n\n"
        // howToUseDetText += "Tip: It's best to use earbuds or headphones so you can hear the metronome."

        var howToUseDetText = "\u{2022} Use Headphones! We have a built-in metronome which REALLY helps your accuracy, and your score!  You can only hear the metronome with headphones.\n\n"
        
        howToUseDetText += "\u{2022} Select the round “Gear” button to see the Settings.\n\n"
        
        howToUseDetText += "\u{2022} In Settings, select the instrument, then select the tempo.  You can change the tempo anytime, speed it up as you improve.\n\n"
        
//        howToUseDetText += "\u{2022} In Settings, select the help mode: if you want video feedback (fastest way to improve, videos will popup and suggest a fix based on your performance), select 'Video.' Choose 'Text' if you want to get text help only.  If you want just the star rating, select 'None.'\n\n"
        
        howToUseDetText += "\u{2022} Select the Help mode, in Settings:\n> Choose 'Video' if you want video feedback (fastest way to improve, videos will popup and suggest a fix based on your performance)\n> Choose 'Text' if you want to get text help only\n> Choose 'None' if you want just the star rating\n\n"
        
        howToUseDetText += "\u{2022} Choose 'Play', then select Level. From there, pick a Day. We usually start on Day 1.\n\n"
        
        howToUseDetText += "\u{2022} You can decide if you would like to have the exercises move to the next exercise automatically or if you want to jump around and choose exercises yourself.\n> If you want the app to lead you through the practice session (recommended, especially for beginners) just press 'Start.'\n> If you want to select exercises yourself, just scroll to the exercise you want and tap it.\n\n"
        
        howToUseDetText += "\u{2022} If you complete an exercise and you don’t get the star rating you would like, we will remember your score so you can come back later that day or another day and try to improve it.\n\n"
        
        howToUseDetailsLabel.text = howToUseDetText
        
        // 123456789012345678901234567890123456789012345 67890
        // All-Level Access
        // PlayTunes for Trumpet, English Help Videos
        
       ////////////////////////////////////////////////////////////////////////////////////////////////////
        accessUpperLevelsLabel.text = "To Access All Of PlayTunes' Upper Levels"
        
//        var tryOutDetText = "You can access Levels 1 & 2 for free, forever. That’s almost 200 exercises!\n\n"
//        tryOutDetText += "For this free try-out, you don't need to do anything else; you are good to go!"
        
        var tryOutDetText = "We have lots of free areas of the app to try out for both beginners and those with some experience. Levels 1 and 2 are completely free. Day 1 of these levels is free also: Levels 3, 4, 7, 10, 15, 20, 25, 30.  We even give you parts of our Long Tones Level and Lip Slurs Level.  Go ahead and explore Day 1 of all the Pink levels - you can unlock Gray levels when you purchase a subscription.\n\n"
        
        tryOutDetText += "That’s hundreds of free exercises to help you get better!\n\n"
        
        tryOutDetText += "For access to 150 days of practice, and hundreds of unique exercises, you will need to purchase a PlayTunes All-Level Access Subscription through iTunes.\n\n"
        
//        tryOutDetText += "PlayTunes offers a 1-month ($2.99/month) and 6-month ($12.99 for 6 months) Auto-Renewing Subscriptions.\n\n"
        
        tryOutPTForFreeDetailsLabel.text = tryOutDetText

        var subDetailText = "" //In order to get access to the 500 exercises in the upper levels, you will need to purchase a PlayTunes All-Level Access Subscription through iTunes.\n\n"
        //subDetailText += "PlayTunes offers 1-month ($9.99 per month) and 6-month ($49.99 for 6 months) Auto-Renewing Subscriptions.\n\n"
        
        subDetailText += "PlayTunes offers 1-month ($2.99/month) and 6-month ($9.99 for 6 months) Auto-Renewing Subscriptions.\n\n"
        
        subDetailText += "Select 'Purchase Options' to choose and purchase an available Subscription."

        accessUpperLevelsDetailLabel.text = subDetailText
        
        
        var arSubMsgStr = "Please read below about the nature of Auto-Renewing Subscriptions purchased through iTunes:\n"
//        var arSubMsgStr = "Auto-Renewing Subscriptons purchased through iTunes have the following features:\n"
        arSubMsgStr += "\u{2022} Payment will be charged to iTunes Account at confirmation of purchase\n"
        arSubMsgStr += "\u{2022} Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period\n"
        arSubMsgStr += "\u{2022} Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal\n"
        arSubMsgStr += "\u{2022} Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase\n"
        arSubMsgStr += "\u{2022} Current subscription may not be cancelled during the active subscription period\n"
        arSubMsgStr += "\u{2022} Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable"
 
        
        subsDetailLabel.text = arSubMsgStr + "\n"
        
        scrollView.showsVerticalScrollIndicator = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Setup so scrollbar flashes evrery 3 secs so user realizes it's a scrollview
        timer = Timer.scheduledTimer(
                    timeInterval: 3.0,
                    target: self,
                    selector: #selector(WelcomeViewController.flashScrollBar),
                    userInfo: nil,
                    repeats: true)
        scrollView.flashScrollIndicators()
    }
    
    @objc func flashScrollBar() {
        scrollView.flashScrollIndicators()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // OK, they know it's a scrollview. Stop flashing the scrollbar
        timer.invalidate()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        // Had some issues trying to set ScrollView dims unless doing it here
//        let bottomOfScrollView = bottomButtonsEnclosingView.frame.origin.y - 10
//        let topOfScrollView = scrollView.frame.origin.y
//        let scrollViewHt = bottomOfScrollView - topOfScrollView
//        scrollView.frame.size.height = scrollViewHt
//        
//        var scrollViewContentSize = scrollView.frame.size
//        scrollViewContentSize.height = kScrollContentHt
//        scrollView.contentSize = scrollViewContentSize
//    }
}
