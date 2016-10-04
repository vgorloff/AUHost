//
//  rdar28599032.h
//  WaveLabs
//
//  Created by Vlad Gorlov on 03/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <os/log.h>

void log_private(os_log_t, os_log_type_t, NSString *);
void log_public(os_log_t, os_log_type_t, NSString *);
