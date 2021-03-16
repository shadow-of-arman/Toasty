Pod::Spec.new do |spec|

  spec.name         = "Toasty"
  spec.version      = "1.0.0"
  spec.summary      = "An easy to use, native looking AND customizable toast notification framework created for UIKit."

  spec.description  = <<-DESC
  Since apple doesn't give us access to use the native toast notification system, I created Toasty as a template toast notification system that resembles the native iOS/iPadOS environment that can also be customized to fit any need.
  You can even set a custom view behind the notification so people can expand the notification and interact with your custom view in clever ways as shown in the expandibility example gif!
                   DESC

  spec.homepage     = "https://github.com/shadow-of-arman/Toasty"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Arman Zoghi" => "shadowofarman@hotmail.com" }
  spec.social_media_url   = "https://twitter.com/shadow_of_arman"

  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "10.15"
  spec.swift_version         = "5"

  spec.source        = { :git => "https://github.com/shadow-of-arman/Toasty.git", :tag => "v#{spec.version}" }
  spec.source_files  = "Classes", "Toasty/**/*.{h,m,swift}"
  spec.resources     = "Toasty/**/*.xcassets"

end
