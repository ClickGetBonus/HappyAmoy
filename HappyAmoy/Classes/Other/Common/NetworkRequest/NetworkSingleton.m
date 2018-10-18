//
//  NetworkSingleton.m
//  WY_DYZB
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NetworkSingleton.h"
#import "LoginViewController.h"

@interface NetworkSingleton ()

@end

/**    分配一个静态地址，这样就可以将请求全部放在同一个地址 */
static NSMutableArray *requestTaskArray;


@implementation NetworkSingleton

#pragma mark - 懒加载请求数组
- (NSMutableArray *)requestTaskArray{
    if (!requestTaskArray) {
        requestTaskArray = [[NSMutableArray alloc] init];
    }
    return requestTaskArray;
}

+ (NetworkSingleton *)sharedManager{
    static NetworkSingleton *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    /**
     *函数void dispatch_once( dispatch_once_t *predicate, dispatch_block_t block);其中第一个参数predicate，该参数是检查后面第二个参数所代表的代码块是否被调用的谓词，第二个参数则是在整个应用程序中只会被调用一次的代码块.dispach_once函数中的代码块只会被执行一次，而且还是线程安全的
     */
    dispatch_once(&predicate, ^{
        sharedNetworkSingleton = [[NetworkSingleton alloc] init];
    });
    
    return sharedNetworkSingleton;
}

- (AFHTTPSessionManager *)baseHttpRequest{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager.requestSerializer setTimeoutInterval:TIMEOUT];         // 设置请求超时时间
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setTimeoutInterval:TIMEOUT]; // 设置请求超时时间
    // 解决post数据中文乱码的问题
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    WYLog(@"token = %@",[LoginUserDefault userDefault].userItem.token);
    // 添加token
    [manager.requestSerializer setValue:[LoginUserDefault userDefault].userItem.token forHTTPHeaderField:@"token"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //是否允许CA不信任的证书通过
    securityPolicy.allowInvalidCertificates = YES;
    //是否验证主机名
    securityPolicy.validatesDomainName = NO;
    
    manager.securityPolicy = securityPolicy;
    
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    manager.requestSerializer.stringEncoding = enc;
    
    return manager;
}

#pragma mark - Get请求
- (void)getRequestWithUrl:(NSString *)url parameters:(id)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    [self getRequestWithUrl:url parameters:parameters successBlock:successBlock failureBlock:failureBlock shouldDismissHud:YES];
}

#pragma mark - Get请求
- (void)getRequestWithUrl:(NSString *)url parameters:(id)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock shouldDismissHud:(BOOL)shouldDismissHud  {
    
    url = [[NSString stringWithFormat:@"%@%@",baseUrl,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];     // IOS-9之前会报警告
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSData *data =(NSData *) responseObject;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        WYLog(@"response = %@",dict);
        
        if (dict == nil) {
            [WYHud showMessage:@"网络错误!"];
            return ;
        }
        if ([dict[@"code"] integerValue] == 701) { // 当前账户已在其他手机登陆，您已被迫下线，请重新登陆
            if ([LoginUserDefault userDefault].isLoginVc) {
                return;
            }
            [LoginUserDefault userDefault].userItem = [[UserItem alloc] init];
            [LoginUserDefault userDefault].isTouristsMode = YES;
            [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
            [LoginUserDefault userDefault].isLoginVc = YES;
            [WYProgress showErrorWithStatus:dict[@"msg"]];
            LoginViewController *loginVc = [[LoginViewController alloc] init];
            UIViewController *currentVc = [WYUtils currentViewController];
            WYLog(@"当前显示的控制器%@",currentVc);
            //判断当前的界面是否是登录界面，不是则push显示
            if (![[NSString stringWithUTF8String:object_getClassName(currentVc)] isEqual:[NSString stringWithUTF8String:object_getClassName(loginVc)]]) {
                [[WYUtils currentViewController].navigationController pushViewController:loginVc animated:YES];
            }
            return;
        }
        if (shouldDismissHud) {
            // 隐藏加载菊花
            [WYProgress dismiss];
        }
        if (successBlock) {
            // 成功回调
            successBlock(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (shouldDismissHud) {
            // 隐藏加载菊花
            [WYProgress dismiss];
        }
        [WYHud showMessage:@"网络错误!"];
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (failureBlock) {
            // 失败回调
            failureBlock(errorStr);
        }
    }];
}

#pragma mark - MallGet请求
- (void)getMallRequestWithUrl:(NSString *)url parameters:(id)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    url = [[NSString stringWithFormat:@"%@%@",baseHaomiMallUrl,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];     // IOS-9之前会报警告
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSData *data =(NSData *) responseObject;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        WYLog(@"response = %@",dict);
        
        if (dict == nil) {
            [WYHud showMessage:@"网络错误!"];
            return ;
        }
        if ([dict[@"code"] integerValue] == 701) { // 当前账户已在其他手机登陆，您已被迫下线，请重新登陆
            if ([LoginUserDefault userDefault].isLoginVc) {
                return;
            }
            [LoginUserDefault userDefault].userItem = [[UserItem alloc] init];
            [LoginUserDefault userDefault].isTouristsMode = YES;
            [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
            [LoginUserDefault userDefault].isLoginVc = YES;
            [WYProgress showErrorWithStatus:dict[@"msg"]];
            LoginViewController *loginVc = [[LoginViewController alloc] init];
            UIViewController *currentVc = [WYUtils currentViewController];
            WYLog(@"当前显示的控制器%@",currentVc);
            //判断当前的界面是否是登录界面，不是则push显示
            if (![[NSString stringWithUTF8String:object_getClassName(currentVc)] isEqual:[NSString stringWithUTF8String:object_getClassName(loginVc)]]) {
                [[WYUtils currentViewController].navigationController pushViewController:loginVc animated:YES];
            }
            return;
        }
        if (YES) {
            // 隐藏加载菊花
            [WYProgress dismiss];
        }
        if (successBlock) {
            // 成功回调
            successBlock(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (YES) {
            // 隐藏加载菊花
            [WYProgress dismiss];
        }
        [WYHud showMessage:@"网络错误!"];
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (failureBlock) {
            // 失败回调
            failureBlock(errorStr);
        }
    }];
}

/**     haomaicoGet请求     */
- (void)getCoRequestWithUrl:(NSString *)url parameters:(id)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    url = [[NSString stringWithFormat:@"%@%@",baseHaomaiecoUrl,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];     // IOS-9之前会报警告
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSData *data =(NSData *) responseObject;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        WYLog(@"response = %@",dict);
        
        if (dict == nil) {
            [WYHud showMessage:@"网络错误!"];
            return ;
        }
        if ([dict[@"code"] integerValue] == 701) { // 当前账户已在其他手机登陆，您已被迫下线，请重新登陆
            if ([LoginUserDefault userDefault].isLoginVc) {
                return;
            }
            [LoginUserDefault userDefault].userItem = [[UserItem alloc] init];
            [LoginUserDefault userDefault].isTouristsMode = YES;
            [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
            [LoginUserDefault userDefault].isLoginVc = YES;
            [WYProgress showErrorWithStatus:dict[@"msg"]];
            LoginViewController *loginVc = [[LoginViewController alloc] init];
            UIViewController *currentVc = [WYUtils currentViewController];
            WYLog(@"当前显示的控制器%@",currentVc);
            //判断当前的界面是否是登录界面，不是则push显示
            if (![[NSString stringWithUTF8String:object_getClassName(currentVc)] isEqual:[NSString stringWithUTF8String:object_getClassName(loginVc)]]) {
                [[WYUtils currentViewController].navigationController pushViewController:loginVc animated:YES];
            }
            return;
        }
        if (YES) {
            // 隐藏加载菊花
            [WYProgress dismiss];
        }
        if (successBlock) {
            // 成功回调
            successBlock(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (YES) {
            // 隐藏加载菊花
            [WYProgress dismiss];
        }
        [WYHud showMessage:@"网络错误!"];
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (failureBlock) {
            // 失败回调
            failureBlock(errorStr);
        }
    }];
}
#pragma mark - Post请求
- (void)postRequestWithUrl:(NSString *)url parameters:(id)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
    [self postRequestWithUrl:url parameters:parameters successBlock:successBlock failureBlock:failureBlock shouldDismissHud:YES];
}

#pragma mark - Post请求
- (void)postRequestWithUrl:(NSString *)url parameters:(id)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock shouldDismissHud:(BOOL)shouldDismissHud {
    
    url = [[NSString stringWithFormat:@"%@%@",baseUrl,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];     // IOS-9之前会报警告
    
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSData *data =(NSData *) responseObject;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        WYLog(@"response = %@",dict);
        
        if (dict == nil) {
            [WYHud showMessage:@"网络错误!"];
            return ;
        }
        if ([dict[@"code"] integerValue] == 701) { // 当前账户已在其他手机登陆，您已被迫下线，请重新登陆
            if ([LoginUserDefault userDefault].isLoginVc) {
                return;
            }
            [LoginUserDefault userDefault].userItem = [[UserItem alloc] init];
            [LoginUserDefault userDefault].isTouristsMode = YES;
            [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
            [LoginUserDefault userDefault].isLoginVc = YES;
            [WYProgress showErrorWithStatus:dict[@"msg"]];
            LoginViewController *loginVc = [[LoginViewController alloc] init];
            UIViewController *currentVc = [WYUtils currentViewController];
            WYLog(@"当前显示的控制器%@",currentVc);
            //判断当前的界面是否是登录界面，不是则push显示
            if (![[NSString stringWithUTF8String:object_getClassName(currentVc)] isEqual:[NSString stringWithUTF8String:object_getClassName(loginVc)]]) {
                [[WYUtils currentViewController].navigationController pushViewController:loginVc animated:YES];
            }
            return;
        }
        
        if (shouldDismissHud) {
            // 隐藏加载菊花
            [WYProgress dismiss];
        }
        if (successBlock) {
            // 成功回调
            successBlock(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (shouldDismissHud) {
            // 隐藏加载菊花
            [WYProgress dismiss];
        }
        [WYHud showMessage:@"网络错误!"];
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (failureBlock) {
            // 失败回调
            failureBlock(errorStr);
        }
    }];
}



-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/**     Post请求，json格式的参数     */
- (void)postJsonRequestWithUrl:(NSString *)url parameters:(id)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
    url = [[NSString stringWithFormat:@"%@%@",baseUrl,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];     // IOS-9之前会报警告
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    WYLog(@"jsonString = %@",jsonString);
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    req.timeoutInterval = TIMEOUT;
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            WYLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                successBlock(responseObject);
            }
        } else {
            NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            // 失败回调
            failureBlock(errorStr);
            WYLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];    
}

#pragma mark - 上传图片
- (void)uploadImageWithUrl:(NSString *)url parameters:(id)parameters image:(UIImage *)image successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
    url = [[NSString stringWithFormat:@"%@%@",uploadFileUrl,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];     // IOS-9之前会报警告

    AFHTTPSessionManager *manager = [self baseHttpRequest];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        // 任意的二进制数据MIMEType application/octet-stream
        [formData appendPartWithFileData:imageData name:@"upfile" fileName:fileName mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSData *data =(NSData *) responseObject;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        WYLog(@"response = %@",dict);
        
        if (dict == nil) {
            [WYHud showMessage:@"网络错误!"];
            return ;
        }
        // 成功回调
        successBlock(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WYHud showMessage:@"网络错误!"];
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        // 失败回调
        failureBlock(errorStr);
    }];

}

#pragma mark - 提供方法情清空请求数组
- (void)removeTask{
    [self.requestTaskArray removeAllObjects];
}

#pragma mark - 取消全部请求
- (void)cancelAllRequest{
    NSLog(@"请求任务task个数：%zd",self.requestTaskArray.count);
    // 遍历数组取消请求
    [self.requestTaskArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task cancel];
    }];
    // 取消全部请求后清空数组
    [self.requestTaskArray removeAllObjects];
}

#pragma mark - 判断是否还有没有上传的附件
- (BOOL)judgeHaveNoUploadAttachments{
    
    if (self.requestTaskArray.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 将编码格式转换为NSString
-(NSString *)gb2312toutf8:(NSData *) data{
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    return retStr;
}

#pragma mark - 获取当前时间戳
- (NSString *)GetNowTimes
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeInterval];
    
    return timeString;
}

#pragma mark - 字典转字符串
- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
