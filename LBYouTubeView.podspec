Pod::Spec.new do |s|
  s.name         = "LBYouTubeView"
  s.version      = "2.0.3"
  s.license      = { :type => 'MIT', :text => 'Copyright (c) 2012 Laurin Brandner <larcus94@gmail.com>\n\n    Permission is hereby granted, free of charge, to any person obtaining a copy\n    of this software and associated documentation files (the \"Software\"), to deal\n    in the Software without restriction, including without limitation the rights\n    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n    copies of the Software, and to permit persons to whom the Software is furnished\n    to do so, subject to the following conditions:\n\n    The above copyright notice and this permission notice shall be included in all\n    copies or substantial portions of the Software.\n\n    THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\n    THE SOFTWARE.' }
  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.summary      = "A UIView subclass that displays YouTube videos using a MPMoviePlayerController."
  s.homepage     = "https://github.com/cabosoft/LBYouTubeView"
  s.author       = 'Laurin Brandner'
  s.source       = { :git => "https://github.com/cabosoft/LBYouTubeView.git", :tag => 'podspec-2.0.3' }
  s.ios.source_files = "LBYouTubeView/*.{h,m,mm}", "LBMoviePlayerView/*.{h,m,mm}"
  s.ios.resources    = "LBYouTubeView/*.lproj", "LBMoviePlayerView/*.lproj"
  s.ios.preserve_paths = "LBYouTubeView", "LBMoviePlayerView"
  s.ios.requires_arc = true
  s.ios.framework  = 'MediaPlayer'
end
