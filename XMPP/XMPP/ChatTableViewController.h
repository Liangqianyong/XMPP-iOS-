//
//  ChatTableViewController.h
//  XMPP
//
//  Created by 梁前勇 on 2017/3/20.
//  Copyright © 2017年 梁前勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPManager.h"
@interface ChatTableViewController : UITableViewController
@property(nonatomic,strong)XMPPJID * friendJID;
@end
