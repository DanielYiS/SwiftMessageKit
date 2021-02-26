//
//  DemoViewController.swift
//  SwiftMessageKit_Example
//
//  Created by YuLe on 2021/2/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import SwiftBasicKit
import SwiftMessageKit

class DemoViewController: UIViewController {

    private lazy var sv: UIScrollView = {
        let item = UIScrollView.init(frame: self.view.bounds)

        item.alwaysBounceVertical = true
        
        return item
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        if #available(iOS 11.0, *) {
            self.edgesForExtendedLayout = UIRectEdge.top
            self.viewRespectsSystemMinimumLayoutMargins = false
        } else {
            self.edgesForExtendedLayout = UIRectEdge.all
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.modalPresentationStyle = .fullScreen
        self.extendedLayoutIncludesOpaqueBars = false
        self.view.isUserInteractionEnabled = true
        
        ZKey.shared.configService(api: "http://qa.a.live4fun.xyz", web: "http://qa.a.live4fun.xyz", wss: "ws://qa.m.live4fun.xyz:9282")
        
        self.sv.es.addPullToRefresh(handler: { [unowned self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                self.sv.es.stopPullToRefresh()
            }
        })
        self.view.addSubview(self.sv)
        
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.addTarget(self, action: #selector(self.btnMessageEvent), for: .touchUpInside)
        btn.setTitle("Message", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.border(color: .gray, radius: 1, width: 1)
        btn.frame = CGRect.init(x: 100, y: 200, width: 150, height: 50)
        self.sv.addSubview(btn)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @objc private func btnMessageEvent() {
        let user = ZModelUserBase.init()
        user.nickname = "Daniel"
        user.role = .user
        let itemVC = ZMessageViewController.initWithParams(params: ["user": user])
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
}
