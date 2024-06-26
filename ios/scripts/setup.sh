#!/bin/bash

# This ensures that relative paths are correct no matter where the script is executed
cd "$(dirname "$0")"

echo "⚙️  Checking file header"
if [ ! -f ../Trackee.xcworkspace/xcuserdata/`whoami`.xcuserdatad/IDETemplateMacros.plist ]; then
  echo "❌ File header is not set - setting now"
  echo -n "Enter your full name: "
  read fullname
  mkdir -p ../Trackee.xcworkspace/xcuserdata/`whoami`.xcuserdatad
  cp IDETemplateMacros.plist ../Trackee.xcworkspace/xcuserdata/`whoami`.xcuserdatad/
  sed -i "" -e "s/___FULLNAME___/$fullname/g" ../Trackee.xcworkspace/xcuserdata/`whoami`.xcuserdatad/IDETemplateMacros.plist
else
  echo "✅ File header is properly set"
fi

if [ ! -d ../DomainLayer/KMPSharedDomain.xcframework ]; then
  echo "⚙️  Building KMP for the first time"
  ./build-kmp.sh
fi

echo "⚙️  Checking whether Twine is installed"
if command -v twine &> /dev/null; then
  echo "✅ Twine is installed"
else
  echo "❌ Twine is not installed"
  echo "Check https://github.com/MateeDevs/wiki/blob/master/tooling/ruby.md for more info"
fi
