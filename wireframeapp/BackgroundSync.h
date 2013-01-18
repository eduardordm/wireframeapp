//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "CHDropboxSync.h"

@class KtBrowserController;

@interface BackgroundSync : NSObject <DBRestClientDelegate> {
    DBRestClient *restClient;
}

+ (BackgroundSync*) getInstance;

- (DBRestClient *)restClient;

- (void)syncComplete;

- (void) upload:(NSString*)filename;

- (void) sync;

@property(retain) CHDropboxSync* syncer;
@property(retain) KtBrowserController* browserController;

@end
