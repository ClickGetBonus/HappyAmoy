//
//  QHRequestConst.h
//  QianHong
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <UIKit/UIKit.h>

/****************** setup ******************/

/**    获取会员标签  */
UIKIT_EXTERN NSString *const Setup_GetGKeywordMember;
/**    获取扩展信息  */
UIKIT_EXTERN NSString *const Setup_UpdateExtend;
/**    获取国家信息  */
UIKIT_EXTERN NSString *const Setup_GetCountry;
/**    根据国家获取省份信息  */
UIKIT_EXTERN NSString *const Setup_GetProvince;
/**    根据国家获取城市信息  */
UIKIT_EXTERN NSString *const Setup_GetCityByCountry;
/**    根据省份获取城市信息  */
UIKIT_EXTERN NSString *const Setup_GetCity;
/**    获取区县信息  */
UIKIT_EXTERN NSString *const Setup_GetRegion;
/**    获取偏好信息  */
UIKIT_EXTERN NSString *const Setup_GetHobby;
/**    获取行业信息  */
UIKIT_EXTERN NSString *const Setup_GetIndustry;
/**    获取职务信息  */
UIKIT_EXTERN NSString *const Setup_GetJob;
/**    获取等级信息  */
UIKIT_EXTERN NSString *const Setup_GetGrade;
/**    获取礼物信息  */
UIKIT_EXTERN NSString *const Setup_GetGif;
/**    获取产品信息  */
UIKIT_EXTERN NSString *const Setup_GetProduct;

/****************** setup ******************/





/****************** member ******************/

/**    会员注册  */
UIKIT_EXTERN NSString *const Member_Register;
/**    会员登陆  */
UIKIT_EXTERN NSString *const Member_Login;
/**    获取扩展信息  */
UIKIT_EXTERN NSString *const Member_GetExtend;
/**    发送验证码  */
UIKIT_EXTERN NSString *const Member_SendVerify;
/**    修改号码  */
UIKIT_EXTERN NSString *const Member_UpdateMobile;
/**    修改密码  */
UIKIT_EXTERN NSString *const Member_UpdatePwd;
/**    重置密码  */
UIKIT_EXTERN NSString *const Member_ResetPwd;
/**    修改核心资料  */
UIKIT_EXTERN NSString *const Member_UpdateProperty;
/**    修改附属资料  */
UIKIT_EXTERN NSString *const Member_UpdateAppertain;
/**    设置偏好标签  */
UIKIT_EXTERN NSString *const Member_SetHobbyKey;
/**    图片上传  */
UIKIT_EXTERN NSString *const Member_UploadImg;
/**    图片排序  */
UIKIT_EXTERN NSString *const Member_SortImg;
/**    获取图片列表  */
UIKIT_EXTERN NSString *const Member_ListImg;
/**    提取图片  */
UIKIT_EXTERN NSString *const Member_GetImg;
/**    图片删除  */
UIKIT_EXTERN NSString *const Member_RemoveImg;
/**    上传GPS信息  */
UIKIT_EXTERN NSString *const Member_UploadLocation;
/**    修改头像  */
UIKIT_EXTERN NSString *const Member_UpdateAvatar;
/**    会员认证  */
UIKIT_EXTERN NSString *const Member_UploadAuthen;
/**    获取签到信息  */
UIKIT_EXTERN NSString *const Member_GetSign;
/**    会员签到  */
UIKIT_EXTERN NSString *const Member_UpdateSign;
/**    获取对象会员信息  */
UIKIT_EXTERN NSString *const Member_GetAim;
/**    获取鲜花清单  */
UIKIT_EXTERN NSString *const Member_BillFlower;
/**    获取魅力清单  */
UIKIT_EXTERN NSString *const Member_BillCharm;
/**    设置朋友圈显示时限  */
UIKIT_EXTERN NSString *const Member_SetMomentsLimit;

/****************** member ******************/





/****************** forum ******************/

/**    获取话题  */
UIKIT_EXTERN NSString *const Forum_GetSubject;
/**    查看动态  */
UIKIT_EXTERN NSString *const Forum_ListForum;
/**    搜索动态  */
UIKIT_EXTERN NSString *const Forum_SearchForum;
/**    新增动态  */
UIKIT_EXTERN NSString *const Forum_AddForum;
/**    删除动态  */
UIKIT_EXTERN NSString *const Forum_RemoveForum;
/**    变更锁定标识  */
UIKIT_EXTERN NSString *const Forum_LockForum;
/**    回复动态  */
UIKIT_EXTERN NSString *const Forum_ReplyForum;
/**    查看回复列表  */
UIKIT_EXTERN NSString *const Forum_ListForumReply;
/**    删除动态回复  */
UIKIT_EXTERN NSString *const Forum_RemoveForumReply;
/**    加赞动态  */
UIKIT_EXTERN NSString *const Forum_AddPraise;
/**    减赞动态  */
UIKIT_EXTERN NSString *const Forum_DedPraise;
/**    获取点赞头像  */
UIKIT_EXTERN NSString *const Forum_GetPraiseAvatar;
/**    获取分享信息  */
UIKIT_EXTERN NSString *const Forum_GetShareInfo;
/**    增加分享数  */
UIKIT_EXTERN NSString *const Forum_AddShare;
/**    加赞回复  */
UIKIT_EXTERN NSString *const Forum_AddReplyPraise;
/**    减赞回复  */
UIKIT_EXTERN NSString *const Forum_DedReplyPraise;
/**    查看话题动态  */
UIKIT_EXTERN NSString *const Forum_ListForumBySubject;
/**    搜索话题动态  */
UIKIT_EXTERN NSString *const Forum_SearchForumBySubject;

/****************** forum ******************/





/****************** qiniu ******************/

/**    获取音频空间上传令牌  */
UIKIT_EXTERN NSString *const QiNiu_AudioUpToken;
/**    获取文件空间上传令牌  */
UIKIT_EXTERN NSString *const QiNiu_FileUpToken;
/**    获取图像空间上传令牌  */
UIKIT_EXTERN NSString *const QiNiu_ImageUpToken;
/**    获取缩略图空间上传令牌  */
UIKIT_EXTERN NSString *const QiNiu_ThumbUpToken;
/**    获取视频空间上传令牌  */
UIKIT_EXTERN NSString *const QiNiu_VideoUpToken;

/****************** qiniu ******************/
