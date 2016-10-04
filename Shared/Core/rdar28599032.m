//
//  rdar28599032.m
//  WaveLabs
//
//  Created by Vlad Gorlov on 03/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

#import "rdar28599032.h"

void log_private(os_log_t log, os_log_type_t type, NSString * message) {
   os_log_with_type(log, type, "%s", [message cStringUsingEncoding:NSUTF8StringEncoding]);
}

void log_public(os_log_t log, os_log_type_t type, NSString * message) {
   os_log_with_type(log, type, "%{public}s", [message cStringUsingEncoding:NSUTF8StringEncoding]);
}
