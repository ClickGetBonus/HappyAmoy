//
//  QHRequestConst.m
//  QianHong
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <UIKit/UIKit.h>

/****************** setup ******************/

/**    获取会员标签  */
NSString *const Setup_GetGKeywordMember = @"setup/getKeywordMember";
/**    获取扩展信息  */
NSString *const Setup_UpdateExtend = @"setup/updateExtend";
/**    获取国家信息  */
NSString *const Setup_GetCountry = @"setup/getCountry";
/**    根据国家获取省份信息  */
NSString *const Setup_GetProvince = @"setup/getProvince";
/**    根据国家获取城市信息  */
NSString *const Setup_GetCityByCountry = @"setup/getCityByCountry";
/**    根据省份获取城市信息  */
NSString *const Setup_GetCity = @"setup/getCity";
/**    获取区县信息  */
NSString *const Setup_GetRegion = @"setup/getRegion";
/**    获取偏好信息  */
NSString *const Setup_GetHobby = @"setup/getHobby";
/**    获取行业信息  */
NSString *const Setup_GetIndustry = @"setup/getIndustry";
/**    获取职务信息  */
NSString *const Setup_GetJob = @"setup/getJob";
/**    获取等级信息  */
NSString *const Setup_GetGrade = @"setup/getGrade";
/**    获取礼物信息  */
NSString *const Setup_GetGif = @"setup/getGift";
/**    获取产品信息  */
NSString *const Setup_GetProduct = @"setup/getProduct";

/****************** setup ******************/





/****************** member ******************/

/**    会员注册  */
NSString *const Member_Register = @"member/register";
/**    会员登陆  */
NSString *const Member_Login = @"member/login";
/**    获取扩展信息  */
NSString *const Member_GetExtend = @"member/getExtend";
/**    发送验证码  */
NSString *const Member_SendVerify = @"member/sendVerify";
/**    修改号码  */
NSString *const Member_UpdateMobile = @"member/updateMobile";
/**    修改密码  */
NSString *const Member_UpdatePwd = @"member/updatePwd";
/**    重置密码  */
NSString *const Member_ResetPwd = @"member/resetPwd";
/**    修改核心资料  */
NSString *const Member_UpdateProperty = @"member/updateProperty";
/**    修改附属资料  */
NSString *const Member_UpdateAppertain = @"member/updateAppertain";
/**    设置偏好标签  */
NSString *const Member_SetHobbyKey = @"member/setHobbyKey";
/**    图片上传  */
NSString *const Member_UploadImg = @"member/uploadImg";
/**    图片排序  */
NSString *const Member_SortImg = @"member/sortImg";
/**    获取图片列表  */
NSString *const Member_ListImg = @"member/listImg";
/**    提取图片  */
NSString *const Member_GetImg = @"member/getImg";
/**    图片删除  */
NSString *const Member_RemoveImg = @"member/removeImg";
/**    上传GPS信息  */
NSString *const Member_UploadLocation = @"member/uploadLocation";
/**    修改头像  */
NSString *const Member_UpdateAvatar = @"member/updateAvatar";
/**    会员认证  */
NSString *const Member_UploadAuthen = @"member/uploadAuthen";
/**    获取签到信息  */
NSString *const Member_GetSign = @"member/getSign";
/**    会员签到  */
NSString *const Member_UpdateSign = @"member/updateSign";
/**    获取对象会员信息  */
NSString *const Member_GetAim = @"member/getAim";
/**    获取鲜花清单  */
NSString *const Member_BillFlower = @"member/billFlower";
/**    获取魅力清单  */
NSString *const Member_BillCharm = @"member/billCharm";
/**    设置朋友圈显示时限  */
NSString *const Member_SetMomentsLimit = @"member/setMomentsLimit";

/****************** member ******************/





/****************** forum ******************/

/**    获取话题  */
NSString *const Forum_GetSubject = @"forum/getSubject";
/**    查看动态  */
NSString *const Forum_ListForum = @"forum/listForum";
/**    搜索动态  */
NSString *const Forum_SearchForum = @"forum/searchForum";
/**    新增动态  */
NSString *const Forum_AddForum = @"forum/addForum";
/**    删除动态  */
NSString *const Forum_RemoveForum = @"forum/removeForum";
/**    变更锁定标识  */
NSString *const Forum_LockForum = @"forum/lockForum";
/**    回复动态  */
NSString *const Forum_ReplyForum = @"forum/replyForum";
/**    查看回复列表  */
NSString *const Forum_ListForumReply = @"forum/listForumReply";
/**    删除动态回复  */
NSString *const Forum_RemoveForumReply = @"forum/removeForumReply";
/**    加赞动态  */
NSString *const Forum_AddPraise = @"forum/addPraise";
/**    减赞动态  */
NSString *const Forum_DedPraise = @"forum/dedPraise";
/**    获取点赞头像  */
NSString *const Forum_GetPraiseAvatar = @"forum/getPraiseAvatar";
/**    获取分享信息  */
NSString *const Forum_GetShareInfo = @"forum/getShareInfo";
/**    增加分享数  */
NSString *const Forum_AddShare = @"forum/addShare";
/**    加赞回复  */
NSString *const Forum_AddReplyPraise = @"forum/addReplyPraise";
/**    减赞回复  */
NSString *const Forum_DedReplyPraise = @"forum/dedReplyPraise";
/**    查看话题动态  */
NSString *const Forum_ListForumBySubject = @"forum/listForumBySubject";
/**    搜索话题动态  */
NSString *const Forum_SearchForumBySubject = @"forum/searchForumBySubject";

/****************** forum ******************/





/****************** qiniu ******************/

/**    获取音频空间上传令牌  */
NSString *const QiNiu_AudioUpToken = @"qiniu/getAudioUpToken";
/**    获取文件空间上传令牌  */
NSString *const QiNiu_FileUpToken = @"qiniu/getFileUpToken";
/**    获取图像空间上传令牌  */
NSString *const QiNiu_ImageUpToken = @"qiniu/getImageUpToken";
/**    获取缩略图空间上传令牌  */
NSString *const QiNiu_ThumbUpToken = @"qiniu/getThumbUpToken";
/**    获取视频空间上传令牌  */
NSString *const QiNiu_VideoUpToken = @"qiniu/getVideoUpToken";

/****************** qiniu ******************/

