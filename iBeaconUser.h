//
//  iBeaconUser.h
//  beaconDemo
//
//  Created by li lin on 12/30/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface iBeaconUser : NSObject<CLLocationManagerDelegate>
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *passwd;
@property (nonatomic, strong) NSString *baseURL;
@property (atomic) BOOL loggedIn;
@property (nonatomic, strong) UILocalNotification *tappedPushLocalNotification;
@property (nonatomic, strong) NSMutableArray *beaconInfoArray;
@property (nonatomic, strong) NSArray *triggerInfoArray;
@property (nonatomic, strong) NSArray *triggerActionArray;
@property (nonatomic, strong) NSArray *beaconArray;
@property (nonatomic, strong) NSArray *cruiseActionArray;
@property (nonatomic, strong) NSMutableArray *beaconsNearMe;
@property (nonatomic, strong) NSMutableArray *namesOfBeacon;//content is an dictionary, key is major, minor, name
@property (nonatomic, strong) NSMutableArray *reminderOfBeacon; //content is an dictionary, key is major, minor, reminder


+ (iBeaconUser *)sharedInstance;
-(void)startMonitor;
-(void)startMonitorWithFoundNewBeacon:(void(^)(CLBeacon *beacon))FoundNew;
-(void)startMonitorWithFoundNewBeacon:(void(^)(CLBeacon *beacon))FoundNew withKnowBeacon:(void(^)(CLBeacon *beacon))FoundKnown;
-(void)startRangingWithFoundBeacon:(void(^)(CLBeacon *beacon))FoundNew;
-(void)startUpdateHeading:(void(^)(CLHeading *heading))FoundHeading;;
-(void)stopUpdateHeading;
-(void)stopMonitor;
-(NSArray *)findBeaconNearMe;//return list of CLBeacon
-(NSDictionary *)findBeaconInfoBy:(NSString *) majorminorid;

-(CLBeacon *) findOutNearestBeaconIndex;
-(BOOL) isBeacon:(CLBeacon *)this SameWith:(CLBeacon *)that;


-(NSString *)findNameByBeacon:(CLBeacon *)beaconOne;
-(void) setNameForBeacon:(CLBeacon *)beaconOne with:(NSString *)newName;
-(void)saveAllData;

-(NSMutableArray *)findRemindersWith:(CLBeacon *)beaconOne;
-(void)removeReminderWith:(CLBeacon *)beaconOne with:(NSString *)reminder;
-(void)AddRemindersWith:(CLBeacon *)beaconOne with:(NSString *)reminder;
-(void)AddRemindersWith:(CLBeacon *)beaconOne with:(NSString *)reminder friends:(NSString *)friends;
@end
