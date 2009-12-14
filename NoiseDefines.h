/*
 *  NoiseDefines.h
 *  noise
 *
 *  Created by Joshua Bassett on 10/12/09.
 *  Copyright 2009 CLEAR Interactive. All rights reserved.
 *
 */

#define MESSAGE_ENTITY_NAME @"Message"
#define APP_SUPPORT_PLUGIN_DIR @"Application Support/Noise/PlugIns"

enum {
  NOISE_MESSAGE_PRIORITY_LOWEST  = -2,
  NOISE_MESSAGE_PRIORITY_LOW     = -1,
  NOISE_MESSAGE_PRIORITY_NORMAL  =  0,
  NOISE_MESSAGE_PRIORITY_HIGH    =  1,
  NOISE_MESSAGE_PRIORITY_HIGHEST =  2
};


#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@protocol NSApplicationDelegate
@end

@protocol NSXMLParserDelegate
@end
#endif
