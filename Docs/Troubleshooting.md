To reveal Plug-Ins segistered in System:

   ```bash
   pluginkit -m
   
   # Same as above but more verbose
   pluginkit -mv
   
   # Same as above but only Audio Unit UIs
   pluginkit -m -p com.apple.AudioUnit-UI
   
   # Same as above but only Audio Units
   pluginkit -m -p com.apple.AudioUnit
   ```

To reveal Audio Units registered in System:

   ```bash
   # All Audio Units
   auval -a
   
   # Only Audio Unit Effects
   auval -s aufx
   ```

Apple API:

- /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/AudioToolbox.framework/Versions/A/Headers/AUAudioUnitImplementation.h