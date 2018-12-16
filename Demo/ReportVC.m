//
//  ReportVC.m
//  Demo
//
//  Created by 橙晓侯 on 2018/12/15.
//  Copyright © 2018 橙晓侯. All rights reserved.
//
#define HexColor(h)     [UIColor colorWithRed:(((h & 0xFF0000) >> 16))/255.0 green:(((h &0xFF00) >>8))/255.0 blue:((h &0xFF))/255.0 alpha:1.0]
#define BLUE HexColor(0x76D6FF)
#define RED HexColor(0xF9518C)
#define YELLOW HexColor(0xE69C37)
#define Main_Color HexColor(0xffc3a3)
#define BG_Grey_Color [HexColor(0x3c3a3a) colorWithAlphaComponent:0.9]

#define Width           [UIScreen mainScreen].bounds.size.width
#define Height          [UIScreen mainScreen].bounds.size.height
/// 多语言
#define kMultiLangString(str) NSLocalizedString(str, nil)

#import "ReportVC.h"
#import <Masonry.h>
@interface ReportVC () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIStackView *pageControl;

@end

@implementation ReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
//    UIButton *b = [UIButton new];
//    b.tag = 1;
//    [self onCenterBtn:b];
}

#pragma mark 配置UI
- (void)setupUI
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    // 背景
    UIImageView *backImageView = [UIImageView new];
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backImageView setImage:[UIImage imageNamed:@"bg"]];
    
    UIView *blackAlphaView = [UIView new];
    [blackAlphaView setBackgroundColor:[UIColor blackColor]];
    blackAlphaView.alpha = 0.7;
    
    [self.view addSubview:backImageView];
    [self.view addSubview:blackAlphaView];
    
    [blackAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.center.equalTo(self.view);
    }];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.center.equalTo(self.view);
    }];
    
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIScrollView *scrollView = [UIScrollView new];
    _scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(2 * Width, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_topLayoutGuide).offset(20);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-20);
        make.left.right.equalTo(self.view);
        
    }];
    
    //=========== 标题 ===========
    UILabel *titleLB = [UILabel new];
    [self.view addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(5);
        make.centerX.offset(0);
    }];
    titleLB.textColor = [UIColor whiteColor];
    titleLB.text = kMultiLangString(@"护肤建议");
    titleLB.font = [UIFont systemFontOfSize:23];
    
    // 返回
    UIButton *backBtn = [UIButton new];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLB);
        make.left.offset(15);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];

    //=========== 3 ===========
    UIView *leftView = [UIView new];
    UIView *centerView = [UIView new];
    UIScrollView *rightView = [UIScrollView new];
    
    for (UIView *view in @[leftView, centerView, rightView])
    {
        view.layer.cornerRadius = 20;
        view.clipsToBounds = YES;
        [view setBackgroundColor:[HexColor(0x222324) colorWithAlphaComponent:0.8]];
        [scrollView addSubview:view];
    }
    
    //=========== 左 ===========
    float gap = 75;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(scrollView);
        make.size.equalTo(scrollView).sizeOffset(CGSizeMake(-(gap * 2), -100));
        
    }];
    [self setupLeftView:leftView];
    
    //=========== 中 ===========
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(gap/2);
        make.centerY.equalTo(leftView);
        make.height.equalTo(leftView);
        make.width.offset(gap);
    }];
    [self setupCenterView:centerView];
    
    //=========== 右 ===========
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_right).offset(gap/2);
        make.centerY.equalTo(leftView);
        make.size.equalTo(leftView);
    }];
    [self setupRightView:rightView];
    
    
    //=========== pageControl ===========
    [self setupPageControl];
}

#pragma mark 左
- (void)setupLeftView:(UIView *)leftView
{
    //=========== 脸 =========== 
    UIImageView *faceView = [UIImageView new];
    faceView.contentMode = UIViewContentModeScaleAspectFill;
    [leftView addSubview:faceView];
    
    faceView.image = [UIImage imageNamed:@"face"];
    [faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.equalTo(leftView).multipliedBy(0.5);
        make.height.equalTo(leftView).multipliedBy(0.33);
    }];
    
    //=========== 信息栏 ===========
    UIStackView *infoStack = [UIStackView new];
    [leftView addSubview:infoStack];
    
    [infoStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(faceView);
        make.centerX.multipliedBy(1.5);
        make.width.equalTo(faceView).multipliedBy(0.8);
    }];
    
    infoStack.axis = UILayoutConstraintAxisVertical;
    infoStack.spacing = 20;
    // 栏目
//    NSArray *infoList = @[];
    for (int i = 0; i < 5; i++) {
        UIView *view = [UIView new];
        [infoStack addArrangedSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(44);
        }];
        
        view.backgroundColor = HexColor(0x393636);
        view.layer.cornerRadius = 22;
        view.clipsToBounds = YES;
        
        // 左label
        UILabel *keyLB = [UILabel new];
        [view addSubview:keyLB];
        [keyLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(view);
            make.width.greaterThanOrEqualTo(@50);
        }];
        
        keyLB.font = [UIFont systemFontOfSize:15];
        keyLB.text = kMultiLangString(@"肤龄");
        keyLB.textColor = [UIColor whiteColor];
        
        // 中label
        UILabel *valueLB = [UILabel new];
        [view addSubview:valueLB];
        [valueLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(keyLB.mas_right).offset(20);
            make.centerY.equalTo(keyLB);
        }];
        
        valueLB.font = [UIFont boldSystemFontOfSize:20];
        valueLB.text = @"20岁";
        valueLB.textColor = Main_Color;
        
        // 右按钮
        UIButton *button = [UIButton new];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.equalTo(view);
            make.height.offset(20);
        }];
        
        button.backgroundColor = Main_Color;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@" 去检测 > " forState:UIControlStateNormal];
        button.clipsToBounds = 1;
        button.layer.cornerRadius = 5;
    }
    
    //=========== 总分栏 ===========
    UIView *scoreView = [UIView new];
    // 分数
    [leftView addSubview:scoreView];
    [scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(faceView.mas_bottom);
        make.left.right.offset(0);
        make.height.equalTo(leftView).multipliedBy(0.1);
    }];
    
    UILabel *rightScoreLB = [UILabel new];
    [scoreView addSubview:rightScoreLB];
    [rightScoreLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(faceView).offset(20);
        make.centerY.equalTo(scoreView);
    }];
    rightScoreLB.textColor = Main_Color;
    rightScoreLB.font = [UIFont boldSystemFontOfSize:70];
    rightScoreLB.text = @"98";

    UILabel *leftScoreLB = [UILabel new];
    [scoreView addSubview:leftScoreLB];
    [leftScoreLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightScoreLB.mas_left).offset(-5);
        make.bottom.equalTo(rightScoreLB.mas_baseline);
    }];
    leftScoreLB.textColor = [UIColor whiteColor];
    leftScoreLB.font = [UIFont systemFontOfSize:15];
    leftScoreLB.text = kMultiLangString(@"总分");
    
    // 扫一扫
    UIImageView *QRCodeView = [UIImageView new];
    [scoreView addSubview:QRCodeView];
    [QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(infoStack.mas_right);
        make.centerY.equalTo(scoreView);
        make.height.width.equalTo(scoreView.mas_height).multipliedBy(0.9);
    }];
    QRCodeView.image = [UIImage imageNamed:@"QRCode"];
    
    UILabel *scanLB1 = [UILabel new];
    [scoreView addSubview:scanLB1];
    [scanLB1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(QRCodeView.mas_left).offset(-12);
        make.centerY.equalTo(QRCodeView).multipliedBy(0.75);
    }];
    scanLB1.text = kMultiLangString(@"扫一扫");
    scanLB1.font = [UIFont boldSystemFontOfSize:20];
    scanLB1.textColor = Main_Color;
    
    UILabel *scanLB2 = [UILabel new];
    [scoreView addSubview:scanLB2];
    [scanLB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(scanLB1.mas_right);
        make.top.equalTo(scanLB1.mas_bottom).offset(8);
    }];
    scanLB2.text = kMultiLangString(@"获取报告");
    scanLB2.font = [UIFont boldSystemFontOfSize:15];
    scanLB2.textColor = Main_Color;
    
    //=========== 检测数值 ===========
    // 头部
    UIView *headerView = [UIView new];
    [leftView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scoreView.mas_bottom).offset(20);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(50);
    }];
    headerView.backgroundColor = Main_Color;

    [headerView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headerView.bounds;
    maskLayer.path = maskPath.CGPath;
    headerView.layer.mask = maskLayer;
    
    UILabel *headerLB = [UILabel new];
    [headerView addSubview:headerLB];
    [headerLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(headerView);
    }];
    headerLB.text = kMultiLangString(@"检测数值");
    
    // 4项数值stack
    UIStackView *resultStack = [UIStackView new];
    [leftView addSubview:resultStack];
    [resultStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.width.equalTo(headerView);
        make.centerX.equalTo(headerView);
        make.height.equalTo(leftView).multipliedBy(0.45);
    }];
    
    resultStack.spacing = 10;
    resultStack.axis = MASAxisTypeVertical;
    resultStack.distribution = UIStackViewDistributionFillEqually;
    
    // 背景虚线
    UIView *borderView = [UIView new];
    [leftView addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(resultStack);
        make.size.equalTo(resultStack);
    }];
    [borderView layoutIfNeeded];
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor grayColor].CGColor;
    border.fillColor = [UIColor clearColor].CGColor;
    border.path = [UIBezierPath bezierPathWithRect:borderView.bounds].CGPath;
    border.frame = borderView.bounds;
    border.lineWidth = 0.5f;
    border.lineDashPattern = @[@4, @2];
    [borderView.layer addSublayer:border];
    

    // 数值栏cell
    for (int i = 0; i < 4; i++) {
        UIView *cell = [UIView new];
        [resultStack addArrangedSubview:cell];
        
        UIImageView *icon = [UIImageView new];
        [cell addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(40);
            make.centerY.equalTo(cell);
            make.width.equalTo(icon.mas_height);
            make.width.equalTo(cell.mas_height).multipliedBy(0.5);
        }];
        icon.image = [UIImage imageNamed:@"icon"];
        
        // 文字
        UILabel *titleLB = [UILabel new];
        [cell addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(icon).multipliedBy(0.8);
            make.left.equalTo(icon.mas_right).offset(15);
        }];
        titleLB.text = kMultiLangString(@"毛孔");
        titleLB.textColor = [UIColor whiteColor];
        
        UILabel *valueLB = [UILabel new];
        [cell addSubview:valueLB];
        [valueLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLB.mas_bottom);
            make.left.equalTo(titleLB);
        }];
        valueLB.text = @"18";
        valueLB.textColor = Main_Color;
        valueLB.font = [UIFont systemFontOfSize:25];
        
        UILabel *optionLB = [UILabel new];
        [cell addSubview:optionLB];
        [optionLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(valueLB.mas_right);
            make.bottom.equalTo(valueLB.mas_bottom).offset(-2);
        }];
        optionLB.text = kMultiLangString(@"个");// 注意在英文中使用空字符串@“”
        optionLB.textColor = Main_Color;
//        optionLB.hidden 不需要的时候隐藏
        
        // 进度条
        float percent = 0.5;// 数据输入
        UIView *bar0 = [UIView new];// 背景灰色
        [cell addSubview:bar0];
        [bar0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(valueLB);
            make.left.equalTo(valueLB.mas_right).offset(30);
            make.width.equalTo(cell).multipliedBy(0.5);
            make.height.offset(20);
        }];
        bar0.layer.cornerRadius = 10;
        bar0.clipsToBounds = 1;
        bar0.backgroundColor = HexColor(0x353535);
        
        UIView *bar1 = [UIView new];// 前排亮色
        [cell addSubview:bar1];
        [bar1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.height.equalTo(bar0);
            make.width.equalTo(bar0).multipliedBy(percent);
        }];
        bar1.layer.cornerRadius = bar0.layer.cornerRadius;
        bar1.clipsToBounds = 1;
        bar1.backgroundColor = Main_Color;
        
        // 百分比
        UILabel *percentLB = [UILabel new];
        [cell addSubview:percentLB];
        [percentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bar1.mas_top).offset(-10);
            make.left.equalTo(bar1.mas_right);
        }];
        percentLB.textColor = bar1.backgroundColor;
        percentLB.text = [NSString stringWithFormat:@"%0.f%%",percent * 100];
        
        // 结论
        UILabel *resultLB = [UILabel new];
        [cell addSubview:resultLB];
        [resultLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bar0);
            make.left.equalTo(bar0.mas_right).offset(30);
            make.right.offset(-30);
        }];
        resultLB.textAlignment = NSTextAlignmentRight;
        resultLB.numberOfLines = 0;
        resultLB.text = @"后台数据";
        resultLB.textColor = bar1.backgroundColor;
        resultLB.font = [UIFont systemFontOfSize:20];
    }
}

#pragma mark 中
- (void)setupCenterView:(UIView *)centerView
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [centerView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(centerView);
        make.width.equalTo(centerView).multipliedBy(0.5);
    }];
    // kMultiLangString(@"护肤建议")
    [leftBtn setTitle:@"护\n\n肤\n\n建\n\n议\n\n▶" forState:UIControlStateNormal];
    leftBtn.titleLabel.numberOfLines = 0;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftBtn setTitleColor:Main_Color forState:UIControlStateNormal];
    leftBtn.tag = 1;
    [leftBtn addTarget:self action:@selector(onCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [centerView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(centerView);
        make.width.equalTo(centerView).multipliedBy(0.5);
    }];
    // kMultiLangString(@"检测报告")
    [rightBtn setTitle:@"检\n\n测\n\n报\n\n告\n\n◀" forState:UIControlStateNormal];
    rightBtn.titleLabel.numberOfLines = 0;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitleColor:Main_Color forState:UIControlStateNormal];
    rightBtn.tag = 0;
    [rightBtn addTarget:self action:@selector(onCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 右
- (void)setupRightView:(UIScrollView *)scrollView
{
    UILabel *titileLB = [UILabel new];
    [scrollView addSubview:titileLB];
    [titileLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(scrollView);
        make.right.left.equalTo(scrollView);
        make.top.offset(20);
    }];
    titileLB.numberOfLines = 0;
    titileLB.textAlignment = NSTextAlignmentCenter;
    titileLB.font = [UIFont systemFontOfSize:30];
    titileLB.text = @"标题";
    titileLB.textColor = Main_Color;
    
    UIView *topView = titileLB;
    float gap = 20;
    // 三段View
    for (int i =0; i < 3; i++) {
        //=========== 公共部分 ===========
        UIView *view = [UIView new];
        [scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).offset(gap);
            make.left.offset(gap);
            make.right.offset(-gap);
//            make.height.offset(300);
            if (i == 2)
                make.bottom.offset(-gap);
        }];
        topView = view;
        
        UIImageView *subHeaderIcon = [UIImageView new];
        [view addSubview:subHeaderIcon];
        [subHeaderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(0);
            make.size.sizeOffset(CGSizeMake(5, 20));
        }];
        subHeaderIcon.image = [UIImage imageNamed:@"subHeader"];
        subHeaderIcon.contentMode = UIViewContentModeScaleAspectFill;
        
        // 子标题
        UILabel *subLB = [UILabel new];
        [scrollView addSubview:subLB];
        [subLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(subHeaderIcon);
            make.left.equalTo(subHeaderIcon).offset(10);
        }];
        
        subLB.textColor = Main_Color;
        subLB.font = [UIFont boldSystemFontOfSize:18];
        
        //=========== 第1段 ===========
        if (i == 0)
        {
            subLB.text = kMultiLangString(@"产生问题的原因");
            
            UILabel *contentLB = [UILabel new];
            [view addSubview:contentLB];
            [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(subHeaderIcon.mas_bottom).offset(15);
                make.left.equalTo(subHeaderIcon);
                make.width.equalTo(view).multipliedBy(0.7);
                make.bottom.lessThanOrEqualTo(view.mas_bottom).offset(-10);
            }];
            contentLB.numberOfLines = 0;
            contentLB.textColor = [UIColor whiteColor];
            contentLB.text = @"高亮文字1：字字字字字字字字字字\n高亮文字2：字字字字字字字字字字\n高亮文字3：字字字字字字字字字字字字字字字\n高亮文字4：字字字字字字字字字字字字字字字字字字";
            
            // 高亮使用示例
            NSArray *temp = @[@"高亮文字1：", @"高亮文字2：", @"高亮文字3：", @"高亮文字4："];
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:contentLB.text];
            for (NSString *highlightStr in temp) {
                //属性字符串
                NSRange spaceRange = [contentLB.text rangeOfString:highlightStr];
                //调整文字颜色
                [aString addAttribute:NSForegroundColorAttributeName value:Main_Color range:spaceRange];
            }
            // 行距
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            [paragraph setLineSpacing:8];
            [aString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [aString length])];
            contentLB.attributedText = aString;
            
            // 分割线
            UIView *line = [UIView new];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(subHeaderIcon.mas_centerY);
                make.left.equalTo(contentLB.mas_right).offset(8);
                make.width.offset(0.5);
            }];
            line.backgroundColor = [UIColor lightGrayColor];
            
            UIImageView *docIcon = [UIImageView new];
            [view addSubview:docIcon];
            [docIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line.mas_top);
                make.left.equalTo(line.mas_right).offset(35);
                make.right.equalTo(view.mas_right).offset(-15);
                make.height.equalTo(docIcon.mas_width);
            }];
            
            docIcon.contentMode = UIViewContentModeScaleAspectFill;
            docIcon.image = [UIImage imageNamed:@"doc"];
            
            UILabel *docLB = [UILabel new];
            [view addSubview:docLB];
            [docLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(docIcon);
                make.top.equalTo(docIcon.mas_bottom).offset(10);
                make.height.offset(15);
            }];
            docLB.textColor = [UIColor whiteColor];
            docLB.text = kMultiLangString(@"专业皮肤科医生解答");
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(docLB.mas_bottom);
                make.bottom.lessThanOrEqualTo(view.mas_bottom).offset(-20);// 保底的高度
            }];
        }
        //=========== 第2段 ===========
        else if (i == 1)
        {
            subLB.text = kMultiLangString(@"治疗推荐");
            
            UIButton *customBtn = [UIButton new];
            [view addSubview:customBtn];
            [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
                make.centerY.equalTo(subHeaderIcon);
            }];
            [customBtn setTitleColor:Main_Color forState:UIControlStateNormal];
            customBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [customBtn setTitle:kMultiLangString(@"护肤品定制 ▶") forState:UIControlStateNormal];

            UIView *underLine = [UIView new];
            [view addSubview:underLine];
            [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(customBtn.mas_bottom).offset(-5);
                make.width.equalTo(customBtn);
                make.centerX.equalTo(customBtn);
                make.height.offset(0.5);
            }];
            underLine.backgroundColor = Main_Color;
            
            UIStackView *stackV = [UIStackView new];
            [view addSubview:stackV];
            [stackV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(subHeaderIcon.mas_bottom).offset(10);
                make.left.right.bottom.equalTo(view);
            }];
            stackV.spacing = 10;
            stackV.axis = MASAxisTypeVertical;
            stackV.distribution = UIStackViewDistributionFillEqually;
            
            int totalCount = 6;// 总数量
            int currentIndex = 0;
            int lineCount = ceilf(totalCount/3.0);
            for (int i = 0; i < lineCount; i++) {
                UIStackView *stackH = [UIStackView new];
                [stackV addArrangedSubview:stackH];
                [stackH mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(120);
                }];
                stackH.spacing = 10;
                stackH.axis = MASAxisTypeHorizontal;
                stackH.distribution = UIStackViewDistributionFillEqually;
                
                //=========== 治疗推荐 ===========
                for (int i = 0; i < 3; i++) {
                    UIView *cell = [UIView new];
                    [stackH addArrangedSubview:cell];
                    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.height.offset(100);
                    }];
                    
                    if (currentIndex >= totalCount)
                        cell.backgroundColor = [UIColor clearColor];// 多余的使其不可见
                    else
                        [self setupCell:cell];
                    // 计数君
                    currentIndex++;
                }
            }
        }
        //=========== 第3段 ===========
        else if (i == 2)
        {
            subLB.text = kMultiLangString(@"治疗方案建议");
            UIView *backView = [UIView new];
            [view addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(subHeaderIcon.mas_bottom).offset(15);
                make.left.equalTo(subHeaderIcon);
                make.right.equalTo(view);
                make.bottom.lessThanOrEqualTo(view.mas_bottom).offset(-10);
            }];
            backView.backgroundColor = BG_Grey_Color;
            backView.layer.cornerRadius = 15;
            backView.clipsToBounds = 1;
            
            UILabel *contentLB = [UILabel new];
            [backView addSubview:contentLB];
            [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.inset(10);
            }];
            contentLB.numberOfLines = 0;
            contentLB.textColor = [UIColor whiteColor];
            
            contentLB.text = @"高亮文字1：字字字字字字字字字字\n高亮文字2：字字字字字字字字字字\n高亮文字3：字字字字字字字字字字字字字字字\n高亮文字4：字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字";
            
            // 高亮使用示例
            NSArray *temp = @[@"高亮文字1：", @"高亮文字2：", @"高亮文字3：", @"高亮文字4："];
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:contentLB.text];
            for (NSString *highlightStr in temp) {
                //属性字符串
                NSRange spaceRange = [contentLB.text rangeOfString:highlightStr];
                //调整文字颜色
                [aString addAttribute:NSForegroundColorAttributeName value:Main_Color range:spaceRange];
            }
            // 行距
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            [paragraph setLineSpacing:8];
            [aString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [aString length])];
            
            contentLB.attributedText = aString;
        }
    }
}

#pragma mark 页数
- (void)setupPageControl
{
    CGFloat size = 10;
    
    UIStackView *stack = [UIStackView new];
    _pageControl = stack;
    [self.view addSubview:stack];
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(-15);
        make.centerX.offset(0);
        make.height.offset(size);
    }];
    stack.spacing = 10;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    
    [_scrollView layoutIfNeeded];
    int count = _scrollView.contentSize.width / _scrollView.frame.size.width;
    for (int i = 0; i < count; i++) {
        UIView *dot = [UIView new];
        dot.tag = i;
        [stack addArrangedSubview:dot];
        [dot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(dot.mas_height);
        }];
        dot.backgroundColor = Main_Color;
        dot.layer.cornerRadius = size/2;
        dot.clipsToBounds = 1;
    }
    [self updatePage:0];
}

#pragma mark 更新 页数
- (void)updatePage:(NSInteger)index
{
    for (UIView *dot in _pageControl.subviews) {
        if (dot.tag == index) {
            dot.backgroundColor = Main_Color;
        }
        else
        {
            dot.backgroundColor = [UIColor lightGrayColor];
        }
    }
}

#pragma mark 点击 中间切换
- (void)onCenterBtn:(UIButton *)btn
{
    NSInteger i = btn.tag;
    CGFloat pageWidth = _scrollView.contentSize.width/2;
    [_scrollView setContentOffset:CGPointMake(pageWidth * i, 0) animated:1];
}

#pragma mark 治疗推荐cell
- (void)setupCell:(UIView *)cell
{
    // cell样式
    cell.backgroundColor = BG_Grey_Color;
    cell.layer.cornerRadius = 15;
    cell.clipsToBounds = 1;
    
    UIImageView *imageView = [UIImageView new];
    [cell addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.offset(10);
        make.height.equalTo(cell).multipliedBy(0.7);
        make.width.equalTo(imageView.mas_height).multipliedBy(0.7);
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
#warning 注意啦：todo arrayData
    imageView.image = [UIImage imageNamed:@"超微活氧仪"];
    
    UILabel *nameLB = [UILabel new];
    [cell addSubview:nameLB];
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).offset(12);
        make.right.offset(-12);
    }];
    nameLB.text = @"超威蓝猫";
    nameLB.textColor = [UIColor whiteColor];
    
    UIImageView *icon = [UIImageView new];
    [cell addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLB.mas_bottom).offset(12);
        make.left.equalTo(nameLB);
        make.size.sizeOffset(CGSizeMake(15, 15));
    }];
    icon.image = [UIImage imageNamed:@"形状33"];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *subLB = [UILabel new];
    [cell addSubview:subLB];
    [subLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icon);
        make.left.equalTo(icon.mas_right).offset(3);
    }];
    subLB.textColor = Main_Color;
    subLB.text = @"晒斑";
    subLB.font = [UIFont systemFontOfSize:12];
    
    UIButton *buyBtn = [UIButton new];
    [cell addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_bottom);
        make.right.offset(-15);
        make.size.sizeOffset(CGSizeMake(60, 20));
    }];
    [buyBtn setTitle:kMultiLangString(@"去购买") forState:UIControlStateNormal];
    [buyBtn setTitleColor:HexColor(0xf68f4b) forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    buyBtn.layer.borderColor = HexColor(0xf68f4b).CGColor;
    buyBtn.layer.borderWidth = 1;
    buyBtn.clipsToBounds = 1;
    buyBtn.layer.cornerRadius = 10;
}

#pragma mark 返回
- (void)onBack
{
    [self.navigationController popViewControllerAnimated:1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSLog(@"%ld", index);
    [self updatePage:index];
}
@end
