//
//  RefreshFooter.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import MJRefresh

public final class RefreshFooter: MJRefreshBackStateFooter {

    public override func prepare() {
        super.prepare()

        setTitle("上拉加载", for: .idle)
        setTitle("放开加载", for: .pulling)
        setTitle("加载中...", for: .refreshing)
        setTitle("没有更多了", for: .noMoreData)
    }

}
