
Pod::Spec.new do |s|
    s.name         = 'WLCollectionView'
    s.version      = '1.0.2'
    s.summary      = '一个模型驱动的CollectionView封装，减少复用代码'
    s.homepage     = 'https://github.com/DaLiangWang/WLCollectionView'
    s.license      = 'MIT'
    s.authors      = {'wangliang' => 'wlhjx1993@gmail.com'}
    s.platform     = :ios, '10.0'
    s.source       = {:git => 'https://github.com/DaLiangWang/WLCollectionView.git', :tag => s.version}
    s.source_files = "WLCollectionView/Class/**/*.{h,m}"
    s.requires_arc = true

end