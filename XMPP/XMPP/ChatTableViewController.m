//
//  ChatTableViewController.m
//  XMPP
//
//  Created by 梁前勇 on 2017/3/20.
//  Copyright © 2017年 梁前勇. All rights reserved.
//

#import "ChatTableViewController.h"
#import "MyCell.h"
#import "FriendCell.h"
@interface ChatTableViewController ()<XMPPStreamDelegate,UIAlertViewDelegate>
//数据源
@property(nonatomic,strong)NSMutableArray  * messageArr;

@end

@implementation ChatTableViewController
- (IBAction)sendAction:(id)sender {
    
    UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"发送消息" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alertView show];
    
}
//提醒框代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        UITextField * textfiled=[alertView textFieldAtIndex:0];
        XMPPMessage * message=[XMPPMessage messageWithType:@"chat" to:self.friendJID];
        [message addBody:textfiled.text];
        [[XMPPManager shareManager].xmppStream sendElement:message];
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageArr=[NSMutableArray array];
    //设置代理
   [ [XMPPManager shareManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //检索信息
    [self relodMessage];
}
-(void)relodMessage
{
    NSManagedObjectContext * context =[XMPPManager shareManager].context;
    
    //创建查询·类
    NSFetchRequest * fetchRequset =[[NSFetchRequest alloc]init];
    
    //创建实体描述
    NSEntityDescription * entityDescription=[NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    [fetchRequset setEntity:entityDescription];
    
    //通过谓词来检索瞒住条件的聊天信息(检索出来我和对方的聊天信息)
    NSPredicate * predicate=[NSPredicate predicateWithFormat:@"bareJidStr == %@ and streamBareJidStr == %@",self.friendJID.bare,[XMPPManager shareManager].xmppStream.myJID.bare];
    
   //创建排序类
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    [fetchRequset setPredicate:predicate];
    [fetchRequset setSortDescriptors:@[sortDescriptor]];
    
    //从临时数据库中查找聊天信息
    NSArray * fetchArray = [context executeFetchRequest:fetchRequset error:nil];
    if (fetchArray.count !=0) {
        if (self.messageArr.count !=0) {
            [self.messageArr removeAllObjects];
        }
        [self.messageArr addObjectsFromArray:fetchArray];

        [self.tableView reloadData];
    }
    //动画效果
    NSIndexPath * indexPath =[NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //取出消息
    XMPPMessageArchiving_Message_CoreDataObject * message=self.messageArr[indexPath.row];
    //判断消息类型
    if (message.isOutgoing) {
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell2" forIndexPath:indexPath];
        cell.Lable.text=message.body;
        return cell;
    }else
    {
        FriendCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ChatCell1" forIndexPath:indexPath];
        cell.lable.text=message.body;
        return cell;

    }
    
    }

//消息发送成功
-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSLog(@"消息发送成功");
    [self relodMessage];
}
//接受消息的代理
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%ld",self.messageArr.count);
    [self relodMessage];
    [self relodMessage];

    
}
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    
}







/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
