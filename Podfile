workspace 'Samples.xcworkspace'
use_frameworks!

project 'Samples.ObjC/Samples.ObjC.xcodeproj'
project 'Samples.Swift/Samples.Swift.xcodeproj' 

abstract_target 'Samples' do
  target 'Samples.ObjC' do
    project 'Samples.ObjC/Samples.ObjC.xcodeproj'
    pod 'PayPalCheckout', '0.40.0'
  end

  target 'Samples.Swift' do
    project 'Samples.Swift/Samples.Swift.xcodeproj' 
    pod 'PayPalCheckout', '0.40.0'
  end
end