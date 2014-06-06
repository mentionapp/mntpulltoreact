Pod::Spec.new do |s|

  s.name         = "MNTPullToReact"
  s.version      = "1.0.2"
  s.summary      = "One gesture, many actions. An evolution of Pull to Refresh."
  s.homepage     = "https://github.com/mentionapp/mntpulltoreact"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author             = { "Guillaume Sempe" => "guillaume@mention.com" }
  s.social_media_url   = "http://twitter.com/tx"
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/mentionapp/mntpulltoreact.git", :tag => "#{s.version}" }
  s.source_files  = "PullToReact/PullToReact/**/*.{h,m}"
  s.public_header_files = "PullToReact/PullToReact/PullToReact.h, PullToReact/PullToReact/UITableView+MNTPullToReact.h, PullToReact/PullToReact/MNTPullToReactView.h"
  s.requires_arc = true

end
