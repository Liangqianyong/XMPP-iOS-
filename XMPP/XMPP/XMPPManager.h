//
//  XMPPManager.h
//  XMPP
//
//  Created by 梁前勇 on 2017/3/17.
//  Copyright © 2017年 梁前勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
@interface XMPPManager : NSObject<XMPPStreamDelegate,XMPPRosterDelegate>

//通信通道对象
@property(nonatomic,strong)XMPPStream * xmppStream;

//好友花名册管理对象
@property(nonatomic,strong)XMPPRoster * xmppRoster;

//信息归档对象
@property(nonatomic,strong)XMPPMessageArchiving * xmppMessageArchiving;
//创建数据管理器
@property(nonatomic,strong)NSManagedObjectContext * context;
+(XMPPManager*)shareManager;

//登录方法
-(void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord;

//注册方法
-(void)registerWithUserName:(NSString *)userName passWord:(NSString *)passWord;
@end
