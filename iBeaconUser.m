//
//  iBeaconUser.m
//  beaconDemo
//
//  Created by li lin on 12/30/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import "iBeaconUser.h"
@interface iBeaconUser()
@property (nonatomic, strong) NSMutableArray *beaconRegionArray;//content is CLBeacionRegion
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CLLocationManager *locatinManager;

@property (nonatomic, strong) NSMutableArray *recent40Beacon;
@property (nonatomic, strong) NSMutableArray *pushedBeacon;
@property (nonatomic, strong) void (^foundNewBeacon)(CLBeacon *);
@property (nonatomic, strong) void (^foundBeacon)(CLBeacon *);
@property (nonatomic, strong) void (^foundHeading)(CLHeading *);
@property (atomic) BOOL enterRegionEnventTriggered;
@property (atomic) BOOL enableInRegionPush;
@property (nonatomic, strong) NSString *nextLeaveString;
@property (atomic) BOOL leaveRegionEnventTriggered;
@property (atomic) BOOL loading;
@end


@implementation iBeaconUser
+ (iBeaconUser *)sharedInstance
{
    static iBeaconUser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[iBeaconUser alloc] init];
        // Do any other initialisation stuff here
        sharedInstance.loggedIn = NO;
        sharedInstance.loading = NO;
        [sharedInstance startMonitor];
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    });
    return sharedInstance;
}

-(CLLocationManager *) locatinManager{
    if (_locatinManager) {
        return _locatinManager;
    }
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locatinManager = manager;
    return _locatinManager;
}

-(NSMutableArray *) beaconInfoArray
{
    if (!_beaconInfoArray) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        _beaconInfoArray  = array;
    }
    
    return _beaconInfoArray;
}

-(NSMutableArray *)namesOfBeacon
{
    if(!_namesOfBeacon){
        NSArray *myArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"beaconName"];
        if (!myArray) {
            NSArray *emptyArray = [[NSArray alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:emptyArray forKey:@"beaconName"];
            myArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"beaconName"];
        }
        _namesOfBeacon = [NSMutableArray arrayWithArray:myArray];
    }
    return _namesOfBeacon;
}


-(void)saveAllData
{
    [[NSUserDefaults standardUserDefaults] setObject:self.namesOfBeacon forKey:@"beaconName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.reminderOfBeacon forKey:@"remindeOfBeacon"];
}

-(NSMutableArray *)reminderOfBeacon
{
    if (!_reminderOfBeacon) {
        NSArray *myArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"remindeOfBeacon"];
        if (!myArray) {
            NSArray *emptyArray = [[NSArray alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:emptyArray forKey:@"remindeOfBeacon"];
            myArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"remindeOfBeacon"];
        }
        _reminderOfBeacon = [NSMutableArray arrayWithArray:myArray];
    }
    return _reminderOfBeacon;
}

-(void)AddRemindersWith:(CLBeacon *)beaconOne with:(NSString *)reminder
{
    NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:beaconOne.major, @"major", beaconOne.minor, @"minor", reminder, @"reminder", nil];
    if ([self.reminderOfBeacon count] >= 10) {
        [self.reminderOfBeacon removeObjectAtIndex:0];
    }
    [self.reminderOfBeacon addObject:newDict];
}

-(void)AddRemindersWith:(CLBeacon *)beaconOne with:(NSString *)reminder friends:(NSString *)friends
{
    NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:beaconOne.major, @"major", beaconOne.minor, @"minor", reminder, @"reminder",friends, @"friends", nil];
    if ([self.reminderOfBeacon count] >= 10) {
        [self.reminderOfBeacon removeObjectAtIndex:0];
    }
    [self.reminderOfBeacon addObject:newDict];
}



-(void)removeReminderWith:(CLBeacon *)beaconOne with:(NSString *)reminder
{
    NSInteger i;
    for (i = 0; i < [self.reminderOfBeacon count]; i++) {
        NSDictionary *each = [self.reminderOfBeacon objectAtIndex:i];
        NSNumber *major = [each objectForKey:@"major"];
        NSNumber *minor = [each objectForKey:@"minor"];
        if ([major isEqualToNumber:beaconOne.major] && [minor isEqualToNumber:beaconOne.minor]) {
            NSString *reminderString = [each objectForKey:@"reminder"];
            if ([reminderString isEqualToString:reminder]) {
                [self.reminderOfBeacon removeObjectAtIndex:i];
                return;
            }
        }
    }
}

-(NSMutableArray *)findRemindersWith:(CLBeacon *)beaconOne
{
    NSInteger i;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (i = 0; i < [self.reminderOfBeacon count]; i++) {
        NSDictionary *each = [self.reminderOfBeacon objectAtIndex:i];
        NSNumber *major = [each objectForKey:@"major"];
        NSNumber *minor = [each objectForKey:@"minor"];
        if ([major isEqualToNumber:beaconOne.major] && [minor isEqualToNumber:beaconOne.minor]) {
//            NSString *reminderString = [each objectForKey:@"reminder"];
            [result addObject:each];
        }
    }
    return result;
}

-(void) setNameForBeacon:(CLBeacon *)beaconOne with:(NSString *)newName
{
    NSInteger i;
    NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:beaconOne.major, @"major", beaconOne.minor, @"minor", newName, @"name", nil];
    for (i = 0; i < [self.namesOfBeacon count]; i++) {
        NSDictionary *each = [self.namesOfBeacon objectAtIndex:i];
        NSNumber *major = [each objectForKey:@"major"];
        NSNumber *minor = [each objectForKey:@"minor"];
        if ([major isEqualToNumber:beaconOne.major] && [minor isEqualToNumber:beaconOne.minor]) {
            [self.namesOfBeacon replaceObjectAtIndex:i withObject:newDict];
            return;
        }
    }
    [self.namesOfBeacon addObject:newDict];
}

-(NSString *)findNameByBeacon:(CLBeacon *)beaconOne
{
    NSInteger i;
    for (i = 0; i < [self.namesOfBeacon count]; i++) {
        NSDictionary *each = [self.namesOfBeacon objectAtIndex:i];
        NSNumber *major = [each objectForKey:@"major"];
        NSNumber *minor = [each objectForKey:@"minor"];
        NSString *name = [each objectForKey:@"name"];
        if ([major isEqualToNumber:beaconOne.major] && [minor isEqualToNumber:beaconOne.minor]) {
            return name;
        }
    }
    return nil;
}

-(NSMutableArray *)recent40Beacon
{
    if (!_recent40Beacon) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        _recent40Beacon = array;
    }
    if ([_recent40Beacon count] > 40) {
        [_recent40Beacon removeObjectAtIndex:0];
    }
    return _recent40Beacon;
}


-(NSMutableArray *)pushedBeacon
{
    if (!_pushedBeacon) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        _pushedBeacon = array;
    }
    return _pushedBeacon;
}

- (CLBeaconRegion *)createBeaconRegionWith:(NSString *)kUUID identifier:(NSString *)kIdentifier
{
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    CLBeaconRegion *beaconRegion;
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
//    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID major:0x0000 minor:13586 identifier:kIdentifier];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    beaconRegion.notifyOnEntry = NO;
    beaconRegion.notifyOnExit = NO;
    
    return beaconRegion;
}
//create beacon region from user's beacon info array.
-(void)createBeaconRegionOfUser
{
    NSString *kUUID = @"00000000-0000-0000-0000-000000000000";
    NSString *kIdentifier = @"moziIdentifier";
    CLBeaconRegion *beaconRegion = [self createBeaconRegionWith:kUUID identifier:kIdentifier];
    self.beaconRegion = beaconRegion;
}

-(void)startMonitor
{
    [self createBeaconRegionOfUser];
    [self.locatinManager startMonitoringForRegion:self.beaconRegion];
    [self.locatinManager startRangingBeaconsInRegion:self.beaconRegion];

//    [self.locatinManager startUpdatingHeading];
}

-(void)startMonitorWithFoundNewBeacon:(void(^)(CLBeacon *beacon))FoundNew
{
    [self createBeaconRegionOfUser];
    self.foundNewBeacon = FoundNew;
    [self.locatinManager startMonitoringForRegion:self.beaconRegion];
    [self.locatinManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)startMonitorWithFoundNewBeacon:(void(^)(CLBeacon *beacon))FoundNew withKnowBeacon:(void(^)(CLBeacon *beacon))FoundKnown
{
    [self createBeaconRegionOfUser];
    self.foundNewBeacon = FoundNew;
    self.foundBeacon = FoundKnown;
    [self.locatinManager startMonitoringForRegion:self.beaconRegion];
    [self.locatinManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)startRangingWithFoundBeacon:(void(^)(CLBeacon *beacon))FoundNew
{
    [self createBeaconRegionOfUser];
    self.foundBeacon = FoundNew;
    [self.locatinManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)startUpdateHeading:(void (^)(CLHeading *))FoundHeading
{
    self.foundHeading = FoundHeading;
    [self.locatinManager  startUpdatingHeading];
}

-(void)stopUpdateHeading
{
    [self.locatinManager stopUpdatingHeading];
    self.foundHeading = nil;
}

-(void)stopMonitor
{
    [self.locatinManager stopMonitoringForRegion:self.beaconRegion];
    [self.locatinManager stopRangingBeaconsInRegion:self.beaconRegion];
}


-(void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"did start monitor");
}

-(BOOL) pushBatteryLow
{
    float batteryLevel = [UIDevice currentDevice].batteryLevel;
    if (batteryLevel < 0.7 && batteryLevel > 0) {
        NSString *lowBattery = @"电池电量不足请充电";
        [self pushLocal:lowBattery];
        return YES;
    }else{
        return NO;
    }
}

-(void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"did enter region");
    NSLog(@"region with %@", region);
}

-(void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"did exit region");
    NSLog(@"region with %@", region);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (howRecent < 120) {
        NSLog(@"latitude %+.6f, longtitude %+6.f", location.coordinate.latitude, location.coordinate.longitude);
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"heading is %@", newHeading);
    if (self.foundHeading) {
        self.foundHeading(newHeading);
    }
}


-(void) pushLocal:(NSString *)content withMajorMinorID:(NSString *)majorminorid{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if(localNotif){
        localNotif.alertBody = content;
        localNotif.alertAction = @"Read Message";
        localNotif.applicationIconBadgeNumber = 1;
        localNotif.soundName = @"alarmsound.caf";
        NSDictionary *userInfo = @{@"type":@"localPush", @"pushID":majorminorid, @"content":content};
        localNotif.userInfo = userInfo;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }
    
}

-(void) pushLocal:(NSString *)content{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if(localNotif){
//        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        localNotif.alertBody = content;
        localNotif.alertAction = @"Read Message";
        localNotif.applicationIconBadgeNumber = 1;
//        localNotif.soundName = @"alarmsound.caf";
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }
    
}

-(BOOL) needFireNotificationWithMajorID:(NSNumber *) majorid minorID:(NSNumber *) minorID{
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
        return NO;
    }
    else{
        return YES;
    }
}






-(NSDictionary *)findBeaconInfoBy:(NSString *) majorminorid
{
    for (NSDictionary *beaconInfo  in self.beaconInfoArray) {
        if ([beaconInfo[@"tagid"] isEqualToString:majorminorid]) {
            return beaconInfo;
        }
    }
    return nil;
}

-(void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    for (CLBeacon *thisBeacon in beacons) {
        [self.recent40Beacon addObject:thisBeacon];
        if ([self isKnownBeacon:thisBeacon] == NO) {
            [self.beaconsNearMe addObject:thisBeacon];
            if (self.foundNewBeacon) {
                self.foundNewBeacon(thisBeacon);
            }
        }else{
            //loop knownBeacon and replace it with new rssi
            for(NSInteger i = 0; i < [self.beaconsNearMe count]; i++){
                CLBeacon *knownBeacon = [self.beaconsNearMe objectAtIndex:i];
                if([self isBeacon:thisBeacon SameWith:knownBeacon]){
                    if(thisBeacon.rssi != 0x00){
                        [self.beaconsNearMe replaceObjectAtIndex:i withObject:thisBeacon];
                        if (self.foundBeacon) {
                            self.foundBeacon(thisBeacon);
                        }
                    }
                    break;
                }
            }
        }
#if 1
        if (self.enableInRegionPush) {
            if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
                NSMutableArray *foundBeacon = [self UniqueBeaconInRecent40Beacon];
                for (CLBeacon *eachBeacon in foundBeacon) {
                    NSLog(@"each beacon in unique array for pushed with %@", eachBeacon);
                    if ([self isBeacon:eachBeacon inArray:self.pushedBeacon] == NO) {
                        NSLog(@"never pushed");
                        NSString *beaconName = [self findNameByBeacon:eachBeacon];
                        if (beaconName) {
                            NSString *append = [@" in" stringByAppendingString:beaconName];
                            NSArray *todoList = [self findRemindersWith:eachBeacon];
                            for (NSDictionary *eachReminderDict in todoList) {
                                NSString *eachReminder = [eachReminderDict objectForKey:@"reminder"];
                                NSString *friends = [eachReminderDict objectForKey:@"friends"];
                                eachReminder = [eachReminder stringByAppendingString:@" @"];
                                eachReminder = [eachReminder stringByAppendingString:friends];
                                [self pushLocal:[eachReminder stringByAppendingString:append]];
                            }
                        }
                        [self.pushedBeacon addObject:eachBeacon];
                    }
                    NSLog(@"never pushed");
                }
            }
        }
#endif
#if 0
        if (self.loading == NO) {
            self.loading = YES;
            if ([self needFireNotificationWithMajorID:thisBeacon.major minorID:thisBeacon.minor]) {
//                [self fireNotificationWithMajor:thisBeacon.major minorID:thisBeacon.minor];
                [self fireNotificationWithCLBeacon:thisBeacon];
            }
#if 0
            CLProximity beaconLocation = thisBeacon.proximity;
            if (beaconLocation == CLProximityFar) {
                NSLog(@"proxi now");
            }
            if (beaconLocation == CLProximityImmediate){
                NSLog(@"proxi imm");
            }
            if (beaconLocation == CLProximityNear) {
                NSLog(@"proxi near");
            }
            if (beaconLocation == CLProximityUnknown) {
                NSLog(@"proxi unknown");
            }
            #endif
        }
#endif

    }
}

-(BOOL) isBeacon:(CLBeacon *) one inArray:(NSArray *)group
{
    NSInteger count = [group count];
    NSInteger i;
    BOOL result = NO;
    NSLog(@"one beacon is %@", one);
    for (i = 0; i < count; i++) {
        CLBeacon *foundBeacon = [group objectAtIndex:i];
        NSLog(@"group beacon is %@", foundBeacon);
        if ([foundBeacon.major isEqualToNumber:one.major] && [foundBeacon.minor isEqualToNumber:one.minor]) {
            break;
        }
    }
    if (i == count) {
        result = NO;
        NSLog(@"one is not in group");
    }else{
        result = YES;
        NSLog(@"Bingo one is in group");
    }
    
    return result;
    
}

-(NSMutableArray *)UniqueBeaconInRecent40Beacon
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (CLBeacon *eachBeacon in self.recent40Beacon) {
        if ([self isBeacon:eachBeacon inArray:result] == NO) {
            [result addObject:eachBeacon];
        }
    }
    
    return result;
}

-(void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    NSLog(@"didDetermineState found region with region %@, with state %d", region, state);
    if ([[UIApplication sharedApplication] applicationState] ==UIApplicationStateBackground) {
        NSLog(@"app back ground");
    }
    if ([[UIApplication sharedApplication] applicationState] ==UIApplicationStateActive) {
        NSLog(@"app active");
    }

    if (state == CLRegionStateOutside) {
        NSLog(@"region state outside");

//        [self.locatinManager stopRangingBeaconsInRegion:self.beaconRegion];
        if (self.enterRegionEnventTriggered == YES){
            [self pushLocal:@"Exit"];
        }
        self.enableInRegionPush = NO;
        self.enterRegionEnventTriggered = NO;
        self.recent40Beacon = nil;
    }
    if (state == CLRegionStateInside) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
//        [self pushLocal:@"ZARA新品上架"];
        self.pushedBeacon = nil;
        self.enableInRegionPush = YES;
        NSLog(@"region state Inside");
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
            double delayInSeconds = 5.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.enableInRegionPush = NO;
                self.recent40Beacon = nil;
            });
        }
//        [self.locatinManager startRangingBeaconsInRegion:self.beaconRegion];
    }
    if (state == CLRegionStateUnknown) {
        NSLog(@"region state unknown");
    }
}


-(void) getAllBeaconInfo
{
    ;
}


-(NSMutableArray *) beaconsNearMe
{
    if (!_beaconsNearMe) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        _beaconsNearMe = array;
    }
    return _beaconsNearMe;
}

-(NSArray *) findBeaconNearMe
{
    if ([self.beaconsNearMe count]) {
        return self.beaconsNearMe;
    }
    else{
        return nil;
    }
}

-(BOOL) isBeacon:(CLBeacon *)this SameWith:(CLBeacon *)that
{
    if ([this.proximityUUID isEqual:that.proximityUUID]) {
        if ([this.major isEqualToNumber:that.major]) {
            if ([this.minor isEqualToNumber:that.minor]) {
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL) isKnownBeacon:(CLBeacon *)beacon{
    if ([beacon.major isEqual:[NSNull null]] || [beacon.minor isEqual:[NSNull null]]) {
        return YES;
    }
    for (CLBeacon *element in self.beaconsNearMe) {
        if([self isBeacon:element SameWith:beacon]){
            return YES;
        };
    }
    return NO;
}


-(CLBeacon *) findOutNearestBeaconIndex
{
    iBeaconUser *user =[iBeaconUser sharedInstance];
    CLBeacon *most = nil;
    
    for(NSInteger i = 0; i < [user.beaconsNearMe count]; i++){
        CLBeacon *eachOne = [user.beaconsNearMe objectAtIndex:i];
        if(most){
            if(most.rssi < eachOne.rssi){
                most = eachOne;
            }
        }else{
            most = eachOne;
        }
    }
    return most;
}
@end
