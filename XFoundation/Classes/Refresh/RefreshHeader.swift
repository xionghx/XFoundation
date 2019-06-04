//
//  RefreshHeader.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import MJRefresh

public final class RefreshHeader: MJRefreshNormalHeader {

    public override func prepare() {
        super.prepare()

        isAutomaticallyChangeAlpha = true
        lastUpdatedTimeLabel?.isHidden = true

        setTitle("下拉刷新", for: .idle)
        setTitle("放开刷新", for: .pulling)
        setTitle("刷新中...", for: .refreshing)
    }

}
