platform :ios, '10.0'
workspace 'PayPalCheckout-Samples-iOS'
use_frameworks!

def common_dependencies
  #Start Framework Dependencies
  pod 'Braintree/PayPalDataCollector', '~>4.27'
  #End Framework Dependencies
end

target 'PayPalCheckout-Samples-iOS-Swift' do
  project 'PayPalCheckout-Samples-iOS-Swift/PayPalCheckout-Samples-iOS-Swift'
  common_dependencies
end

target 'PayPalCheckout-Samples-iOS-Objc' do
  project 'PayPalCheckout-Samples-iOS-Objc/PayPalCheckout-Samples-iOS-Objc'
  common_dependencies
end

