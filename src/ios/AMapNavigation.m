#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>

// #import <AMapNaviKit/AMapNaviKit.h>
// #import <AMapNaviKit/MAMapKit.h>


@interface AMapNavigation : CDVPlugin{
    // Member variables go here.
    NSString* callbackId;
    CGFloat opType;
}

@property (nonatomic, strong)NSString*                  amapApiKey;
// @property (nonatomic, strong)MAMapView*                 mapView;
// @property (nonatomic, strong)AMapNaviManager*           naviManager;
// @property (nonatomic, strong)AMapNaviViewController*    naviViewController;
// @property (nonatomic, strong)AMapNaviPoint*             startPoint;
// @property (nonatomic, strong)AMapNaviPoint*             endPoint;
// @property (nonatomic, strong)AVSpeechSynthesizer*       speechSynthesizer;

- (void)navigation:(CDVInvokedUrlCommand*)command;
// - (void)returnSuccess:(int)status;
// - (void)keepReturnPoint:(AMapNaviPoint*)point;
// - (void)returnError:(NSString*) message;
@end

@implementation AMapNavigation

- (void)navigation:(CDVInvokedUrlCommand*)command
{
    callbackId = command.callbackId;

    CGFloat startLng = [[command.arguments objectAtIndex:0] doubleValue];
    CGFloat startLat = [[command.arguments objectAtIndex:1] doubleValue];
    CGFloat endLng = [[command.arguments objectAtIndex:2] doubleValue];
    CGFloat endLat = [[command.arguments objectAtIndex:3] doubleValue];
    opType = [[command.arguments objectAtIndex:4] doubleValue];
    NSURL *scheme = [NSURL URLWithString:@"iosamap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    if(canOpen){ //是否安装高德地图
        NSURL *myLocationScheme = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=applicationName&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=1&style=2",endLat,endLng]];
        if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) 
        { //iOS10以后,使用新API 
            [[UIApplication sharedApplication] openURL:myLocationScheme options:@{} completionHandler:^(BOOL success) { NSLog(@"scheme调用结束"); }]; 
        } else { //iOS10以前,使用旧API 
            [[UIApplication sharedApplication] openURL:myLocationScheme];
        }
    }else{
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(w/2-40, h/2-20, 80, 40)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.text = @"暂未安装高德地图";
        UIView *view = self.webView.superview;
        [view addSubview:lab];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [lab removeFromSuperview];
        });
    }
}

// - (void)returnSuccess:(int)status{

//     NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:status], @"status", nil];
//     CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];

//     [self.commandDelegate sendPluginResult:result callbackId:callbackId];
// }

// - (void)keepReturnPoint:(AMapNaviPoint*)point{

//     NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:point.longitude], @"lng", [NSNumber numberWithFloat:point.latitude], @"lat", [NSNumber numberWithInt:1], @"status", nil];

//     CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
//     [result setKeepCallbackAsBool:YES];

//     [self.commandDelegate sendPluginResult:result callbackId:callbackId];
// }

// - (void)returnError:(NSString *)message{
//     CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];

//     [self.commandDelegate sendPluginResult:result callbackId:callbackId];
// }

// - (NSString*)amapApiKey{
//     if(!_amapApiKey){
//         CDVViewController* viewController = (CDVViewController*)self.viewController;
//         _amapApiKey = [viewController.settings objectForKey:@"amapapikey"];
//     }
//     return _amapApiKey;
// }

// - (void)initMapView{
//     if(self.mapView == nil){
//         self.mapView = [[MAMapView alloc] initWithFrame:self.webView.bounds];
//     }
//     self.mapView.frame = self.webView.bounds;
//     self.mapView.delegate = self;
// }

// - (void)initManager{
//     if(self.naviManager == nil){
//         _naviManager = [[AMapNaviManager alloc] init];
//         [_naviManager setDelegate:self];
//     }
// }

// - (void)initSpeecher{
//     if(self.speechSynthesizer == nil){
//         self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
//     }
// }

// - (void)initNaviViewController{
//     if(_naviViewController == nil){
//         _naviViewController = [[AMapNaviViewController alloc] initWithMapView:self.mapView delegate:self];
//     }
// }

// - (void)calculateRoute:(AMapNaviPoint*)startPoint endPoint:(AMapNaviPoint*)endPoint{
//     NSArray* startPoints = @[startPoint];
//     NSArray* endPoints = @[endPoint];

//     [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
// }

// - (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController{
    
//     if(opType== 0)
//     {
//         [self.naviManager startGPSNavi];
//     }
//     else
//     {
//         [self.naviManager startEmulatorNavi];
//     }
// }


// - (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
// {
//     [self initSpeecher];
//     [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
// }

// - (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error{
//     [self returnError:[NSString stringWithFormat:@"规划路径错误:%@", error]];
// }

// - (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error{
//     [self returnError:[NSString stringWithFormat:@"error:%@", error]];
// }

// -(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
// updatingLocation:(BOOL)updatingLocation
// {
//     if(updatingLocation)
//     {
//         NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//     }
// }

// #pragma mark - AManNaviViewController Delegate

// - (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController{
//     if(self.speechSynthesizer.isSpeaking){
//         [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
//     }
//     [self.naviManager stopNavi];
//     [self.naviManager dismissNaviViewControllerAnimated:YES];
//     [self returnSuccess: -1];
// }

// - (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController{
//     if (self.naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
//     {
//         self.naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
//     }
//     else
//     {
//         self.naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
//     }
// }

// - (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController{
//     [self.naviManager readNaviInfoManual];
// }

// - (void)naviManagerNeedRecalculateRouteForYaw:(AMapNaviManager *)naviManager{
//     [self speak: @"您已偏航，正在重新规划路径"];
//     [self.naviManager recalculateDriveRouteWithDrivingStrategy:AMapNaviDrivingStrategyDefault];
// }

// - (void)naviManager:(AMapNaviManager *)naviManager didStartNavi:(AMapNaviMode)naviMode{
//     NSLog(@"didStartNavi");
// }

// - (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager{
//     NSLog(@"DidEndEmulatorNavi");
// }

// - (void)naviManagerOnArrivedDestination:(AMapNaviManager *)naviManager{
//     [self.naviManager readNaviInfoManual];
//     [self returnSuccess: 0];
// }

// - (void)naviManager:(AMapNaviManager *)naviManager onArrivedWayPoint:(int)wayPointIndex{
//     [self.naviManager readNaviInfoManual];
// }

// - (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation{
//     [self keepReturnPoint:naviLocation.coordinate];
// }

// - (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager{
//     return 0;
// }

// - (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType{
//     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//         [self speak: soundString];
//     });
// }

// - (void)naviManagerDidUpdateTrafficStatuses:(AMapNaviManager *)naviManager{
//     NSLog(@"DidUpdateTrafficStatuses");
// }

// - (void)speak:(NSString*)text{
//     if(self.speechSynthesizer.isSpeaking){
//         [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
//     }
//     AVSpeechUtterance* utterance = [[AVSpeechUtterance alloc] initWithString:text];
//     if([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending){
//         utterance.rate = 0.5;
//     }else{
//         utterance.rate = 0.5;
//     }
//     utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh_CN"];
//     [self.speechSynthesizer speakUtterance:utterance];
// }

@end
