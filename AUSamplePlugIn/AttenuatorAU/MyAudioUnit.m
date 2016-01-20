//
//  MyAudioUnit.m
//  AttenuatorAU
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

#import "MyAudioUnit.h"

#import <AVFoundation/AVFoundation.h>

@interface MyAudioUnit ()

@property (nonatomic, readwrite) AUParameterTree *parameterTree;

@end


@implementation MyAudioUnit
@synthesize parameterTree = _parameterTree;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription options:(AudioComponentInstantiationOptions)options error:(NSError **)outError {
    self = [super initWithComponentDescription:componentDescription options:options error:outError];
    
    if (self == nil) {
        return nil;
    }
    
    // Create parameter objects.
    AUParameter *param1 = [AUParameterTree createParameterWithIdentifier:@"param1" name:@"Parameter 1" address:myParam1 min:0 max:100 unit:kAudioUnitParameterUnit_Percent unitName:nil flags:0 valueStrings:nil dependentParameters:nil];
    
    // Initialize the parameter values.
    param1.value = 0.5;
    
    // Create the parameter tree.
    _parameterTree = [AUParameterTree createTreeWithChildren:@[ param1 ]];
    
    // Create the input and output busses.
    // Create the input and output bus arrays.
    
    // A function to provide string representations of parameter values.
    _parameterTree.implementorStringFromValueCallback = ^(AUParameter *param, const AUValue *__nullable valuePtr) {
        AUValue value = valuePtr == nil ? param.value : *valuePtr;
        
        switch (param.address) {
            case myParam1:
                return [NSString stringWithFormat:@"%.f", value];
            default:
                return @"?";
        }
    };
    
    self.maximumFramesToRender = 512;
    
    return self;
}

#pragma mark - AUAudioUnit Overrides

- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError {
    if (![super allocateRenderResourcesAndReturnError:outError]) {
        return NO;
    }
    
    // Validate that the bus formats are compatible.
    // Allocate your resources.
    
    return YES;
}

- (void)deallocateRenderResources {
    [super deallocateRenderResources];
    
    // Deallocate your resources.
}

- (AUInternalRenderBlock)internalRenderBlock {
    // Capture in locals to avoid ObjC member lookups. If "self" is captured in render, we're doing it wrong. See sample code.
    
    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags *actionFlags, const AudioTimeStamp *timestamp,
										AVAudioFrameCount frameCount, NSInteger outputBusNumber, AudioBufferList *outputData,
										const AURenderEvent *realtimeEventListHead, AURenderPullInputBlock pullInputBlock) {
        // Do event handling and signal processing here.
        
        return noErr;
    };
}

@end

