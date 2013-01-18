//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "BackgroundSync.h"
#import "Documents.h"

@implementation BackgroundSync

static BackgroundSync *instance;

@synthesize syncer;

@synthesize browserController;

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

+ (BackgroundSync*) getInstance
{
    @synchronized(self)
    {
        if (instance == NULL)
            instance = [[self alloc] init];
    }
    
    return(instance);
}

- (void) sync
{
    self.syncer = $new(CHDropboxSync);
    self.syncer.delegate = self; 

    if ([[DBSession sharedSession] isLinked]) {
        [self.syncer doSync];  
    }
}

- (void)syncComplete {
    self.syncer = nil;
}

- (void) upload:(NSString*)filename
{
    NSString *destDir = @"/";
     NSString *path =[[Documents documentsPath] 
     stringByAppendingPathComponent:filename]; 
    
    [[self restClient] uploadFile:filename toPath:destDir
                    withParentRev:nil fromPath:path];
}


#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {

}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {

}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
  
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {

}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {

}


@end
