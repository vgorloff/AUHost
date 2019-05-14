Step #1. Reveal Extensions registered in System and identify yours one:

   ```bash
   pluginkit -m

   # Same as above but more verbose
   pluginkit -mv

   # Same as above but only Audio Unit UIs
   pluginkit -mvp com.apple.AudioUnit-UI

   # Same as above but only Audio Units
   pluginkit -mvp com.apple.AudioUnit
   ```

Step #2. Reveal Audio Units registered in System and identify yours one:

   ```bash
   # All Audio Units
   auval -a

   # Only Audio Unit Effects
   auval -s aufx

   # Only certain Audio Unit
   auval -v aufx attr wlUA
   ```

Step #3. Validate Audio Unit:

   ```bash
   auval -v aufx attr wlUA
   ```

To explicitely unregister/redister Extension in System:

   ```bash
   pluginkit -vr /tmp/Attenuator.dst/Applications/Attenuator.app/Contents/PlugIns/AttenuatorAU.appex
   pluginkit -va /tmp/Attenuator.dst/Applications/Attenuator.app/Contents/PlugIns/AttenuatorAU.appex
   ```

Apple API:

- /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/AudioToolbox.framework/Versions/A/Headers/AUAudioUnitImplementation.h
