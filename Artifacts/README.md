# 构建与验收产物

- `empty-home.png`：空冰箱首次启动状态
- `recommended-home.png`：Debug 演示库存下的本地推荐状态
- `WhatToEatToday-Development.ipa`：Development 签名包，只能安装到当前团队已登记的设备
- `WhatToEatToday-AppStore.ipa`：App Store Connect/TestFlight 上传候选包，不能直接侧载
- `SHA256SUMS`：两个 IPA 的完整性校验值

IPA 被 `.gitignore` 排除，不会误提交到源码仓库；本地交付目录中仍会保留。
