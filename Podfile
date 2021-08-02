# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!

def shared_pods
  # Networking
  pod 'Alamofire'
  pod 'Moya/RxSwift'

  # Image
  pod 'Nuke'

  # Reactive Programming
  pod 'RxSwift'
  pod 'RxCocoa'
  pod "RxGesture"

  # Utils
  pod 'SwiftLint'

end

target 'Recipe' do
  shared_pods

  target 'RecipeTests' do
    inherit! :search_paths
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'Nimble'
    pod 'Quick'
  end

  target 'RecipeUITests' do
    # Pods for testing
  end
end

