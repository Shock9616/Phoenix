#!/bin/bash

SCHEME="Phoenix"
DESTINATION="platform=macOS,name=My Mac"
SDK="macosx15.0"
xcodebuild test -project "Phoenix/Phoenix.xcodeproj" -scheme $SCHEME -sdk macosx15.0 -destination "$DESTINATION" -only-testing:PhoenixTests CODE_SIGNING_ALLOWED="NO"
