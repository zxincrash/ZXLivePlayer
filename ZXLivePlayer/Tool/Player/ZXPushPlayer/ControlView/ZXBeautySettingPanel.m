//
//  ZXBeautySettingPanel.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXBeautySettingPanel.h"
#import "TextCell.h"
#import "PituMotionAddress.h"
#import "ZXMediaPlayer.h"

#define BeautyViewMargin 8
#define BeautyViewSliderHeight 30
#define BeautyViewCollectionHeight 50
#define BeautyViewTitleWidth 40

@interface ZXBeautySettingPanel() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *functionCollectionView;
@property (nonatomic, strong) UICollectionView *beautyCollectionView;
@property (nonatomic, strong) UICollectionView *beautyTypeCollectionView;
@property (nonatomic, strong) UICollectionView *motionCollectionView;
@property (nonatomic, strong) UICollectionView *koubeiCollectionView;
@property (nonatomic, strong) NSMutableDictionary *beautyValueMap;
@property (nonatomic, strong) UILabel *filterLabel;
@property (nonatomic, strong) UISlider *filterSlider;
@property (nonatomic, strong) UICollectionView *effectCollectionView;
@property (nonatomic, strong) UICollectionView *greenCollectionView;
@property (nonatomic, strong) UICollectionView *resolutionCollectionView;
@property (nonatomic, strong) NSIndexPath *selectFunctionIndexPath;
@property (nonatomic, strong) NSIndexPath *selectEffectIndexPath;
@property (nonatomic, strong) NSIndexPath *selectGreenIndexPath;
@property (nonatomic, strong) NSIndexPath *selectBeautyIndexPath;
@property (nonatomic, strong) NSIndexPath *selectBeautyTypeIndexPath;
@property (nonatomic, strong) NSIndexPath *selectMotionIndexPath;
@property (nonatomic, strong) NSIndexPath *selectKoubeiIndexPath;
@property (nonatomic, strong) UILabel *beautyLabel;
@property (nonatomic, strong) UISlider *beautySlider;
@property (nonatomic, strong) NSMutableArray *functionArray;
@property (nonatomic, strong) NSMutableArray *beautyArray;
@property (nonatomic, strong) NSMutableArray *beautyTypeArray;
@property (nonatomic, strong) NSMutableArray *effectArray;
@property (nonatomic, strong) NSMutableArray *greenArray;
@property (nonatomic, strong) NSMutableArray *motionArray;
@property (nonatomic, strong) NSMutableDictionary *motionAddressDic;
@property (nonatomic, strong) NSMutableArray *koubeiArray;
@property (nonatomic, strong) NSMutableDictionary *koubeiAddressDic;
@property (nonatomic, strong) NSMutableDictionary *cellCacheForWidth;
@property (nonatomic, strong) NSURLSessionDownloadTask *operation;
@property (nonatomic, assign) CGFloat beautyLevel;
@property (nonatomic, assign) CGFloat whiteLevel;
@property (nonatomic, assign) CGFloat ruddyLevel;
@end

@implementation ZXBeautySettingPanel

- (id)init
{
    self = [super init];
    if(self){
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _effectCollectionView){
        return self.effectArray.count;
    }
    else if(collectionView == _functionCollectionView){
        return self.functionArray.count;
    }
    else if(collectionView == _greenCollectionView){
        return self.greenArray.count;
    }
    else if(collectionView == _beautyCollectionView){
        return self.beautyArray.count;
    }
    else if(collectionView == _beautyTypeCollectionView){
        return self.beautyTypeArray.count;
    }
    else if (collectionView == _motionCollectionView) {
        return self.motionArray.count;
    }
    else if (collectionView == _koubeiCollectionView) {
        return self.koubeiArray.count;
    }
    else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _effectCollectionView){
        TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.text = self.effectArray[indexPath.row];
        if(self.selectEffectIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        return cell;
    }
    else if(collectionView == _functionCollectionView){
        TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.text = self.functionArray[indexPath.row];
        if(self.selectFunctionIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        return cell;
    }
    else if(collectionView == _greenCollectionView){
        TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.text = self.greenArray[indexPath.row];
        if(self.selectGreenIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        return cell;
    }
    else if(collectionView == _beautyCollectionView){
        TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.text = self.beautyArray[indexPath.row];
        if(self.selectBeautyIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        return cell;
    }
    else if(collectionView == _beautyTypeCollectionView){
        TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.text = self.beautyTypeArray[indexPath.row];
        if(self.selectBeautyTypeIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        return cell;
    }
    else if(collectionView == _motionCollectionView){
        TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.frame = cell.bounds;
        cell.label.text = [self getMotionName:self.motionArray[indexPath.row]];
        if(self.selectMotionIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        return cell;
    }
    else if(collectionView == _koubeiCollectionView){
        TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.frame = cell.bounds;
        cell.label.text = [self getMotionName:self.koubeiArray[indexPath.row]];
        if(self.selectKoubeiIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        return cell;
    }
    else{
        return [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _effectCollectionView){
        TextCell *cell = (TextCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.row != self.selectEffectIndexPath.row){
            [cell setSelected:YES];
            TextCell *selectCell = (TextCell *)[collectionView cellForItemAtIndexPath:self.selectEffectIndexPath];
            [selectCell setSelected:NO];
            self.selectEffectIndexPath = indexPath;
            [self onSetEffectWithIndex:indexPath.row];
            
        }
    }
    else if(collectionView == _beautyTypeCollectionView){
        TextCell *cell = (TextCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.row != self.selectBeautyTypeIndexPath.row){
            [cell setSelected:YES];
            TextCell *selectCell = (TextCell *)[collectionView cellForItemAtIndexPath:self.selectBeautyTypeIndexPath];
            [selectCell setSelected:NO];
            self.selectBeautyTypeIndexPath = indexPath;
            [self onValueChanged:self.beautySlider];
        }
    }
    else if (collectionView == _motionCollectionView) {
        TextCell *cell = (TextCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.row != self.selectMotionIndexPath.row){
            [cell setSelected:YES];
            TextCell *selectCell = (TextCell *)[collectionView cellForItemAtIndexPath:self.selectBeautyTypeIndexPath];
            [selectCell setSelected:NO];
            self.selectMotionIndexPath = indexPath;
            [self onSetMotionWithIndex:indexPath.row];
        }
    }
    else if (collectionView == _koubeiCollectionView) {
        TextCell *cell = (TextCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //if(indexPath.row != self.selectKoubeiIndexPath.row){
        [cell setSelected:YES];
        TextCell *selectCell = (TextCell *)[collectionView cellForItemAtIndexPath:self.selectBeautyTypeIndexPath];
        [selectCell setSelected:NO];
        self.selectKoubeiIndexPath = indexPath;
        [self onSetKoubeiWithIndex:indexPath.row];
        //}
    }
    else if(collectionView == _beautyCollectionView){
        TextCell *cell = (TextCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.row != self.selectBeautyIndexPath.row){
            [cell setSelected:YES];
            TextCell *selectCell = (TextCell *)[collectionView cellForItemAtIndexPath:self.selectBeautyIndexPath];
            [selectCell setSelected:NO];
            self.selectBeautyIndexPath = indexPath;
            if(self.selectBeautyIndexPath.row == 6){
                //下巴
                self.beautySlider.minimumValue = -10;
                self.beautySlider.maximumValue = 10;
            }
            else{
                self.beautySlider.minimumValue = 0;
                self.beautySlider.maximumValue = 10;
            }
            float value = [[self.beautyValueMap objectForKey:[NSNumber numberWithInteger:self.selectBeautyIndexPath.row]] floatValue];
            self.beautyLabel.text = [NSString stringWithFormat:@"%d",(int)value];
            [self.beautySlider setValue:value];
        }
    }
    else if(collectionView == _greenCollectionView){
        TextCell *cell = (TextCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.row != self.selectGreenIndexPath.row){
            [cell setSelected:YES];
            TextCell *selectCell = (TextCell *)[collectionView cellForItemAtIndexPath:self.selectGreenIndexPath];
            [selectCell setSelected:NO];
            self.selectGreenIndexPath = indexPath;
            
            [self onSetGreenWithIndex:indexPath.row];

        }
    }
    else if(collectionView == _functionCollectionView){
        TextCell *cell = (TextCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.row != self.selectFunctionIndexPath.row){
            [cell setSelected:YES];
            TextCell *selectCell = (TextCell *)[collectionView cellForItemAtIndexPath:self.selectFunctionIndexPath];
            [selectCell setSelected:NO];
            self.selectFunctionIndexPath = indexPath;
            [self changeFunction:indexPath.row];
            //            if([self.delegate respondsToSelector:@selector(reset:)]){
            //                [self.delegate reset:(indexPath.row == 0? YES : NO)];
            //            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [TextCell reuseIdentifier];
    NSString *text = nil;
    if(collectionView == _functionCollectionView){
        text = self.functionArray[indexPath.row];
    }
    else if(collectionView == _effectCollectionView){
        text = self.effectArray[indexPath.row];
    }
    else if(collectionView == _greenCollectionView){
        text = self.greenArray[indexPath.row];
    }
    else if(collectionView == _beautyCollectionView){
        text = self.beautyArray[indexPath.row];
    }
    else if(collectionView == _beautyTypeCollectionView){
        text = self.beautyTypeArray[indexPath.row];
    }
    else if (collectionView == _motionCollectionView) {
        text = [self getMotionName:self.motionArray[indexPath.row]];
    }
    else if (collectionView == _koubeiCollectionView) {
        text = [self getMotionName:self.koubeiArray[indexPath.row]];
    }
    TextCell *cell = [self.cellCacheForWidth objectForKey:identifier];
    if(!cell){
        cell = [[TextCell alloc] init];
        [self.cellCacheForWidth setObject:cell forKey:identifier];
    }
    NSDictionary *attrs = @{NSFontAttributeName : cell.label.font};
    CGSize size=[text sizeWithAttributes:attrs];;
    return CGSizeMake(size.width + 2 * BeautyViewMargin, collectionView.frame.size.height);
}

#pragma mark - layout
- (void)setupView
{
    self.beautySlider.frame = CGRectMake(BeautyViewMargin * 4, BeautyViewMargin, self.frame.size.width - 10 * BeautyViewMargin - BeautyViewSliderHeight, BeautyViewSliderHeight);
    [self addSubview:self.beautySlider];
    
    self.beautyLabel.frame = CGRectMake(self.beautySlider.frame.size.width + self.beautySlider.frame.origin.x + BeautyViewMargin, BeautyViewMargin, BeautyViewSliderHeight, BeautyViewSliderHeight);
    self.beautyLabel.layer.cornerRadius = self.beautyLabel.frame.size.width / 2;
    self.beautyLabel.layer.masksToBounds = YES;
    [self addSubview:self.beautyLabel];
    
    
    self.filterSlider.frame = CGRectMake(BeautyViewMargin * 4, BeautyViewMargin, self.frame.size.width - 10 * BeautyViewMargin - BeautyViewSliderHeight, BeautyViewSliderHeight);
    self.filterSlider.hidden = YES;
    [self addSubview:self.filterSlider];
    
    self.filterLabel.frame = CGRectMake(self.filterSlider.frame.size.width + self.filterSlider.frame.origin.x + BeautyViewMargin, BeautyViewMargin, BeautyViewSliderHeight, BeautyViewSliderHeight);
    self.filterLabel.layer.cornerRadius = self.filterLabel.frame.size.width / 2;
    self.filterLabel.layer.masksToBounds = YES;
    self.filterLabel.hidden = YES;
    [self addSubview:self.filterLabel];
    
    
    self.beautyCollectionView.frame = CGRectMake(0, self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin, self.frame.size.width, BeautyViewSliderHeight * 2 + 2 * BeautyViewMargin);
    [self addSubview:self.beautyCollectionView];
    
    self.beautyTypeCollectionView.frame = CGRectMake(0, self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin, self.frame.size.width, BeautyViewSliderHeight * 2 + 2 * BeautyViewMargin);
    self.beautyTypeCollectionView.hidden = YES;
    [self addSubview:self.beautyTypeCollectionView];
    
    self.motionCollectionView.frame = CGRectMake(0, self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin, self.frame.size.width, BeautyViewSliderHeight * 2 + 2 * BeautyViewMargin);
    self.motionCollectionView.hidden = YES;
    [self addSubview:self.motionCollectionView];
    
    self.koubeiCollectionView.frame = CGRectMake(0, self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin, self.frame.size.width, BeautyViewSliderHeight * 2 + 2 * BeautyViewMargin);
    self.koubeiCollectionView.hidden = YES;
    [self addSubview:self.koubeiCollectionView];
    
    self.effectCollectionView.frame = CGRectMake(0, self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin, self.frame.size.width, BeautyViewSliderHeight * 2 + 2 * BeautyViewMargin);
    self.effectCollectionView.hidden = YES;
    [self addSubview:self.effectCollectionView];
    
    self.greenCollectionView.frame = CGRectMake(0, self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin, self.frame.size.width, BeautyViewSliderHeight * 2 + 2 * BeautyViewMargin);
    self.greenCollectionView.hidden = YES;
    [self addSubview:self.greenCollectionView];
    
    
    self.functionCollectionView.frame = CGRectMake(0, self.beautyCollectionView.frame.size.height + self.beautyCollectionView.frame.origin.y, self.frame.size.width, BeautyViewCollectionHeight);
    [self addSubview:self.functionCollectionView];
    
    
    
}

- (void)changeFunction:(NSInteger)index
{
    self.beautyTypeCollectionView.hidden = index == 0? NO: YES;
    self.beautyLabel.hidden = index == 1? NO: YES;
    self.beautySlider.hidden = index == 1? NO: YES;
    self.beautyCollectionView.hidden = index == 1? NO: YES;
    self.effectCollectionView.hidden = index == 2? NO: YES;
    self.motionCollectionView.hidden = index == 3? NO: YES;
    self.koubeiCollectionView.hidden = index == 4? NO: YES;
    self.filterLabel.hidden = index == 2? NO: YES;
    self.filterSlider.hidden = index == 2? NO: YES;
    self.greenCollectionView.hidden = index == 5? NO: YES;
}


#pragma mark - value changed
- (void)onValueChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    if(slider == self.filterSlider){
        self.filterLabel.text = [NSString stringWithFormat:@"%d",(int)self.filterSlider.value];
        if([self.delegate respondsToSelector:@selector(onSetMixLevel:)]){
            [self.delegate onSetMixLevel:self.filterSlider.value];
        }
    }
    else{
        [self.beautyValueMap setObject:[NSNumber numberWithFloat:self.beautySlider.value] forKey:[NSNumber numberWithInteger:self.selectBeautyIndexPath.row]];
        self.beautyLabel.text = [NSString stringWithFormat:@"%d",(int)self.beautySlider.value];
        
        if(self.selectBeautyIndexPath.row == 0){
            if([self.delegate respondsToSelector:@selector(onSetBeautyStyle:beautyLevel:whitenessLevel:ruddinessLevel:)]){
                _beautyLevel = self.beautySlider.value;
                [self.delegate onSetBeautyStyle:(int)self.selectBeautyTypeIndexPath.row beautyLevel:_beautyLevel whitenessLevel:_whiteLevel ruddinessLevel:_ruddyLevel];
            }
        }
        else if(self.selectBeautyIndexPath.row == 1){
            if([self.delegate respondsToSelector:@selector(onSetBeautyStyle:beautyLevel:whitenessLevel:ruddinessLevel:)]){
                _whiteLevel = self.beautySlider.value;
                [self.delegate onSetBeautyStyle:(int)self.selectBeautyTypeIndexPath.row beautyLevel:_beautyLevel whitenessLevel:_whiteLevel ruddinessLevel:_ruddyLevel];
            }
        }
        else if(self.selectBeautyIndexPath.row == 2){
            if([self.delegate respondsToSelector:@selector(onSetBeautyStyle:beautyLevel:whitenessLevel:ruddinessLevel:)]){
                _ruddyLevel = self.beautySlider.value;
                [self.delegate onSetBeautyStyle:(int)self.selectBeautyTypeIndexPath.row beautyLevel:_beautyLevel whitenessLevel:_whiteLevel ruddinessLevel:_ruddyLevel];
            }
        }
        else if(self.selectBeautyIndexPath.row == 3){
            if([self.delegate respondsToSelector:@selector(onSetEyeScaleLevel:)]){
                [self.delegate onSetEyeScaleLevel:self.beautySlider.value];
            }
        }
        else if(self.selectBeautyIndexPath.row == 4){
            if([self.delegate respondsToSelector:@selector(onSetFaceScaleLevel:)]){
                [self.delegate onSetFaceScaleLevel:self.beautySlider.value];
            }
        }
        //        else if(self.selectBeautyIndexPath.row == 5){
        //            if([self.delegate respondsToSelector:@selector(onSetFaceBeautyLevel:)]){
        //                [self.delegate onSetFaceBeautyLevel:self.beautySlider.value];
        //            }
        //        }
        else if(self.selectBeautyIndexPath.row == 5){
            if([self.delegate respondsToSelector:@selector(onSetFaceVLevel:)]){
                [self.delegate onSetFaceVLevel:self.beautySlider.value];
            }
        }
        else if(self.selectBeautyIndexPath.row == 6){
            if([self.delegate respondsToSelector:@selector(onSetChinLevel:)]){
                [self.delegate onSetChinLevel:self.beautySlider.value];
            }
        }
        else if(self.selectBeautyIndexPath.row == 7){
            if([self.delegate respondsToSelector:@selector(onSetFaceShortLevel:)]){
                [self.delegate onSetFaceShortLevel:self.beautySlider.value];
            }
        }
        else if(self.selectBeautyIndexPath.row == 8){
            if([self.delegate respondsToSelector:@selector(onSetNoseSlimLevel:)]){
                [self.delegate onSetNoseSlimLevel:self.beautySlider.value];
            }
        }
        else{
            
        }
    }
}

- (void)onSetEffectWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(onSetFilter:)]) {
        NSString* lookupFileName = @"";
        
        switch (index) {
            case 0:
                break;
            case 1:
                lookupFileName = @"white.png";
                break;
            case 2:
                lookupFileName = @"langman.png";
                break;
            case 3:
                lookupFileName = @"qingxin.png";
                break;
            case 4:
                lookupFileName = @"weimei.png";
                break;
            case 5:
                lookupFileName = @"fennen.png";
                break;
            case 6:
                lookupFileName = @"huaijiu.png";
                break;
            case 7:
                lookupFileName = @"landiao.png";
                break;
            case 8:
                lookupFileName = @"qingliang.png";
                break;
            case 9:
                lookupFileName = @"rixi.png";
                break;
            default:
                break;
        }
        NSString * path = [[NSBundle mainBundle] pathForResource:@"FilterResource" ofType:@"bundle"];
        if (path != nil && index != FilterType_None) {
            path = [path stringByAppendingPathComponent:lookupFileName];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [self.delegate onSetFilter:image];
            
        } else {
            [self.delegate onSetFilter:nil];
        }
    }
}

- (void)onSetGreenWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(onSetGreenScreenFile:)]) {
        if (index == 0) {
            [self.delegate onSetGreenScreenFile:nil];
        }
        if (index == 1) {
            [self.delegate onSetGreenScreenFile:[[NSBundle mainBundle] URLForResource:@"goodluck" withExtension:@"mp4"]];
            
        }
    }
}

- (void)onSetMotionWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(onSelectMotionTmpl:inDir:)]) {
        NSString *localPackageDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/packages"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:localPackageDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:localPackageDir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if (index == 0){
            [self.delegate onSelectMotionTmpl:nil inDir:localPackageDir];
        }
        else{
            NSString *tmp = [_motionArray objectAtIndex:index];
            NSString *pituPath = [NSString stringWithFormat:@"%@/%@", localPackageDir, tmp];
            if ([[NSFileManager defaultManager] fileExistsAtPath:pituPath]) {
                [self.delegate onSelectMotionTmpl:tmp inDir:localPackageDir];
            }else{
                [self startLoadPitu:localPackageDir pituName:tmp packageURL:[NSURL URLWithString:[_motionAddressDic objectForKey:tmp]]];
            }
        }
    }
}

- (void)onSetKoubeiWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(onSelectMotionTmpl:inDir:)]) {
        NSString *localPackageDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/packages"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:localPackageDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:localPackageDir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if (index == 0){
            [self.delegate onSelectMotionTmpl:nil inDir:localPackageDir];
        }
        else{
            NSString *tmp = [_koubeiArray objectAtIndex:index];
            NSString *pituPath = [NSString stringWithFormat:@"%@/%@", localPackageDir, tmp];
            if ([[NSFileManager defaultManager] fileExistsAtPath:pituPath]) {
                [self.delegate onSelectMotionTmpl:tmp inDir:localPackageDir];
            }else{
                [self startLoadPitu:localPackageDir pituName:tmp packageURL:[NSURL URLWithString:[_koubeiAddressDic objectForKey:tmp]]];
            }
        }
    }
}

- (void)startLoadPitu:(NSString *)pituDir pituName:(NSString *)pituName packageURL:(NSURL *)packageURL{
#ifdef PITU
    if (self.operation) {
        if (self.operation.state != NSURLSessionTaskStateRunning) {
            [self.operation resume];
        }
    }
    NSString *targetPath = [NSString stringWithFormat:@"%@/%@.zip", pituDir, pituName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:targetPath error:nil];
    }
    
    __weak __typeof(self) weakSelf = self;
    NSURLRequest *downloadReq = [NSURLRequest requestWithURL:packageURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self.pituDelegate onLoadPituStart];
    self.operation = [manager downloadTaskWithRequest:downloadReq progress:^(NSProgress * _Nonnull downloadProgress) {
        if (weakSelf.pituDelegate) {
            CGFloat progress = (float)downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount;
            [weakSelf.pituDelegate onLoadPituProgress:progress];
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath_, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:targetPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            [weakSelf.pituDelegate onLoadPituFailed];
            return;
        }
        // 解压
        BOOL unzipSuccess = NO;
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        if ([zipArchive UnzipOpenFile:targetPath]) {
            unzipSuccess = [zipArchive UnzipFileTo:pituDir overWrite:YES];
            [zipArchive UnzipCloseFile];
            
            // 删除zip文件
            [[NSFileManager defaultManager] removeItemAtPath:targetPath error:&error];
        }
        if (unzipSuccess) {
            [weakSelf.pituDelegate onLoadPituFinished];
            [self.delegate onSelectMotionTmpl:pituName inDir:pituDir];
        } else {
            [weakSelf.pituDelegate onLoadPituFailed];
        }
    }];
    [self.operation resume];
#endif
}

#pragma mark - height
+ (NSUInteger)getHeight
{
    return BeautyViewMargin * 4 + 3 * BeautyViewSliderHeight + BeautyViewCollectionHeight;
}

#pragma mark - lazy load
- (NSMutableArray *)effectArray
{
    if(!_effectArray){
        _effectArray = [[NSMutableArray alloc] init];
        [_effectArray addObject:@"清除"];
        [_effectArray addObject:@"美白"];
        [_effectArray addObject:@"浪漫"];
        [_effectArray addObject:@"清新"];
        [_effectArray addObject:@"唯美"];
        [_effectArray addObject:@"粉嫩"];
        [_effectArray addObject:@"怀旧"];
        [_effectArray addObject:@"蓝调"];
        [_effectArray addObject:@"清亮"];
        [_effectArray addObject:@"日系"];
    }
    return _effectArray;
}

- (NSMutableArray *)greenArray
{
    if(!_greenArray){
        _greenArray = [[NSMutableArray alloc] init];
        [_greenArray addObject:@"清除"];
        [_greenArray addObject:@"goodluck"];
    }
    return _greenArray;
}

- (NSMutableArray *)beautyArray
{
    if(!_beautyArray){
        _beautyArray = [[NSMutableArray alloc] init];
        [_beautyArray addObject:@"美颜"];
        [_beautyArray addObject:@"美白"];
        [_beautyArray addObject:@"红润"];
        [_beautyArray addObject:@"大眼"];
        [_beautyArray addObject:@"瘦脸"];
        //        [_beautyArray addObject:@"美型"];
        [_beautyArray addObject:@"v脸"];
        [_beautyArray addObject:@"下巴"];
        [_beautyArray addObject:@"短脸"];
        [_beautyArray addObject:@"瘦鼻"];
    }
    return _beautyArray;
}

- (NSMutableArray *)beautyTypeArray
{
    if(!_beautyTypeArray){
        _beautyTypeArray = [[NSMutableArray alloc] init];
        [_beautyTypeArray addObject:@"光滑"];
        [_beautyTypeArray addObject:@"自然"];
        [_beautyTypeArray addObject:@"p图"];
    }
    return _beautyTypeArray;
}

- (NSMutableArray *)functionArray
{
    if(!_functionArray){
        _functionArray = [[NSMutableArray alloc] init];
        //        [_functionArray addObject:@"原图"];
        [_functionArray addObject:@"风格"];
        [_functionArray addObject:@"美颜"];
        [_functionArray addObject:@"滤镜"];
        [_functionArray addObject:@"动效"];
        [_functionArray addObject:@"抠背"];
        [_functionArray addObject:@"绿幕"];
    }
    return _functionArray;
}

- (NSMutableArray*)motionArray
{
    if (!_motionArray) {
        _motionArray = [[NSMutableArray alloc] init];
        [_motionArray addObject:@"无动效"];
        [_motionArray addObject:@"video_boom"];
        [_motionArray addObject:@"video_nihongshu"];
        [_motionArray addObject:@"video_3DFace_dogglasses2"];
        [_motionArray addObject:@"video_fengkuangdacall"];
        [_motionArray addObject:@"video_Qxingzuo_iOS"];
        [_motionArray addObject:@"video_caidai_iOS"];
        [_motionArray addObject:@"video_liuhaifadai"];
        [_motionArray addObject:@"video_3DFace_alalei0"];
        [_motionArray addObject:@"video_rainbow"];
        [_motionArray addObject:@"video_purplecat"];
        [_motionArray addObject:@"video_huaxianzi"];
        [_motionArray addObject:@"video_baby_agetest"];
        
        _motionAddressDic = [[NSMutableDictionary alloc] init];
        [_motionAddressDic setObject:video_3DFace_alalei0 forKey:@"video_3DFace_alalei0"];
        [_motionAddressDic setObject:video_3DFace_dogglasses2 forKey:@"video_3DFace_dogglasses2"];
        [_motionAddressDic setObject:video_baby_agetest forKey:@"video_baby_agetest"];
        [_motionAddressDic setObject:video_caidai_iOS forKey:@"video_caidai_iOS"];
        [_motionAddressDic setObject:video_huaxianzi forKey:@"video_huaxianzi"];
        [_motionAddressDic setObject:video_liuhaifadai forKey:@"video_liuhaifadai"];
        [_motionAddressDic setObject:video_nihongshu forKey:@"video_nihongshu"];
        [_motionAddressDic setObject:video_rainbow forKey:@"video_rainbow"];
        [_motionAddressDic setObject:video_boom forKey:@"video_boom"];
        [_motionAddressDic setObject:video_fengkuangdacall forKey:@"video_fengkuangdacall"];
        [_motionAddressDic setObject:video_purplecat forKey:@"video_purplecat"];
        [_motionAddressDic setObject:video_Qxingzuo_iOS forKey:@"video_Qxingzuo_iOS"];
    }
    return _motionArray;
}

- (NSMutableArray *)koubeiArray
{
    if (!_koubeiArray) {
        _koubeiArray = [[NSMutableArray alloc] init];
        [_koubeiArray addObject:@"无动效"];
        [_koubeiArray addObject:@"video_xiaofu"];
        
        _koubeiAddressDic = [[NSMutableDictionary alloc] init];
        [_koubeiAddressDic setObject:video_xiaofu forKey:@"video_xiaofu"];
    }
    return _koubeiArray;
}

- (NSString *)getMotionName:(NSString *)motion
{
    if ([motion isEqualToString:@"video_boom"]) {
        return @"Boom";
    }
    else if ([motion isEqualToString:@"video_nihongshu"]){
        return @"霓虹鼠";
    }
    else if ([motion isEqualToString:@"video_3DFace_dogglasses2"]){
        return @"眼镜狗";
    }
    else if ([motion isEqualToString:@"video_fengkuangdacall"]){
        return @"疯狂打call";
    }
    else if ([motion isEqualToString:@"video_Qxingzuo_iOS"]){
        return @"Q星座";
    }
    else if ([motion isEqualToString:@"video_caidai_iOS"]){
        return @"彩色丝带";
    }
    else if ([motion isEqualToString:@"video_liuhaifadai"]){
        return @"刘海发带";
    }
    else if ([motion isEqualToString:@"video_3DFace_alalei0"]){
        return @"阿拉蕾";
    }
    else if ([motion isEqualToString:@"video_rainbow"]){
        return @"彩虹云";
    }
    else if ([motion isEqualToString:@"video_purplecat"]){
        return @"紫色小猫";
    }
    else if ([motion isEqualToString:@"video_huaxianzi"]){
        return @"花仙子";
    }
    else if ([motion isEqualToString:@"video_baby_agetest"]){
        return @"小公举";
    }
    else if ([motion isEqualToString:@"video_xiaofu"]){
        return @"AI抠背";
    }
    return @"无动效";
}

- (NSMutableDictionary *)beautyValueMap
{
    if(!_beautyValueMap){
        _beautyValueMap = [[NSMutableDictionary alloc] init];
    }
    return _beautyValueMap;
}


- (UICollectionView *)beautyCollectionView
{
    if(!_beautyCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _beautyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _beautyCollectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _beautyCollectionView.showsHorizontalScrollIndicator = NO;
        _beautyCollectionView.delegate = self;
        _beautyCollectionView.dataSource = self;
        [_beautyCollectionView registerClass:[TextCell class] forCellWithReuseIdentifier:[TextCell reuseIdentifier]];
    }
    return _beautyCollectionView;
}

- (UICollectionView *)beautyTypeCollectionView
{
    if(!_beautyTypeCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _beautyTypeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _beautyTypeCollectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _beautyTypeCollectionView.showsHorizontalScrollIndicator = NO;
        _beautyTypeCollectionView.delegate = self;
        _beautyTypeCollectionView.dataSource = self;
        [_beautyTypeCollectionView registerClass:[TextCell class] forCellWithReuseIdentifier:[TextCell reuseIdentifier]];
    }
    return _beautyTypeCollectionView;
}

- (UICollectionView *)motionCollectionView
{
    if(!_motionCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _motionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _motionCollectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _motionCollectionView.showsHorizontalScrollIndicator = NO;
        _motionCollectionView.delegate = self;
        _motionCollectionView.dataSource = self;
        [_motionCollectionView registerClass:[TextCell class] forCellWithReuseIdentifier:[TextCell reuseIdentifier]];
    }
    return _motionCollectionView;
}

- (UICollectionView *)koubeiCollectionView
{
    if(!_koubeiCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _koubeiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _koubeiCollectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _koubeiCollectionView.showsHorizontalScrollIndicator = NO;
        _koubeiCollectionView.delegate = self;
        _koubeiCollectionView.dataSource = self;
        [_koubeiCollectionView registerClass:[TextCell class] forCellWithReuseIdentifier:[TextCell reuseIdentifier]];
    }
    return _koubeiCollectionView;
}

- (UICollectionView *)effectCollectionView
{
    if(!_effectCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _effectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _effectCollectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _effectCollectionView.showsHorizontalScrollIndicator = NO;
        _effectCollectionView.delegate = self;
        _effectCollectionView.dataSource = self;
        [_effectCollectionView registerClass:[TextCell class] forCellWithReuseIdentifier:[TextCell reuseIdentifier]];
    }
    return _effectCollectionView;
}

- (UICollectionView *)functionCollectionView
{
    if(!_functionCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        layout.itemSize = CGSizeMake(100, 40);
        _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _functionCollectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _functionCollectionView.showsHorizontalScrollIndicator = NO;
        _functionCollectionView.delegate = self;
        _functionCollectionView.dataSource = self;
        [_functionCollectionView registerClass:[TextCell class] forCellWithReuseIdentifier:[TextCell reuseIdentifier]];
    }
    return _functionCollectionView;
}

- (UICollectionView *)greenCollectionView
{
    if(!_greenCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        layout.itemSize = CGSizeMake(50, 50);
        _greenCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _greenCollectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _greenCollectionView.showsHorizontalScrollIndicator = NO;
        _greenCollectionView.delegate = self;
        _greenCollectionView.dataSource = self;
        [_greenCollectionView registerClass:[TextCell class] forCellWithReuseIdentifier:[TextCell reuseIdentifier]];
    }
    return _greenCollectionView;
}

- (UISlider *)beautySlider
{
    if(!_beautySlider){
        _beautySlider = [[UISlider alloc] init];
        _beautySlider.minimumValue = 0;
        _beautySlider.maximumValue = 10;
        [_beautySlider setMinimumTrackTintColor:UIColorFromRGB((0x0ACCAC))];
        [_beautySlider setMaximumTrackTintColor:[UIColor whiteColor]];
        [_beautySlider addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _beautySlider;
}

- (UILabel *)beautyLabel
{
    if(!_beautyLabel){
        _beautyLabel = [[UILabel alloc] init];
        _beautyLabel.backgroundColor = [UIColor whiteColor];
        _beautyLabel.textAlignment = NSTextAlignmentCenter;
        _beautyLabel.text = @"0";
        [_beautyLabel setTextColor:UIColorFromRGB(0x0ACCAC)];
    }
    return _beautyLabel;
}

- (UISlider *)filterSlider
{
    if(!_filterSlider){
        _filterSlider = [[UISlider alloc] init];
        _filterSlider.minimumValue = 0;
        _filterSlider.maximumValue = 10;
        [_filterSlider setMinimumTrackTintColor:UIColorFromRGB(0x0ACCAC)];
        [_filterSlider setMaximumTrackTintColor:[UIColor whiteColor]];
        [_filterSlider addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _filterSlider;
}

- (UILabel *)filterLabel
{
    if(!_filterLabel){
        _filterLabel = [[UILabel alloc] init];
        _filterLabel.backgroundColor = [UIColor whiteColor];
        _filterLabel.textAlignment = NSTextAlignmentCenter;
        _filterLabel.text = @"0";
        [_filterLabel setTextColor:UIColorFromRGB(0x0ACCAC)];
    }
    return _filterLabel;
}

- (NSIndexPath *)selectEffectIndexPath
{
    if(!_selectEffectIndexPath){
        _selectEffectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectEffectIndexPath;
}


- (NSIndexPath *)selectGreenIndexPath
{
    if(!_selectGreenIndexPath){
        _selectGreenIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectGreenIndexPath;
}

- (NSIndexPath *)selectBeautyIndexPath
{
    if(!_selectBeautyIndexPath){
        _selectBeautyIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectBeautyIndexPath;
}

- (NSIndexPath *)selectBeautyTypeIndexPath
{
    if(!_selectBeautyTypeIndexPath){
        _selectBeautyTypeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectBeautyTypeIndexPath;
}

- (NSIndexPath *)selectFunctionIndexPath
{
    if(!_selectFunctionIndexPath){
        _selectFunctionIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    return _selectFunctionIndexPath;
}

- (NSMutableDictionary *)cellCacheForWidth
{
    if(!_cellCacheForWidth){
        _cellCacheForWidth = [NSMutableDictionary dictionary];
    }
    return _cellCacheForWidth;
}

- (void)resetValues
{
    self.beautySlider.hidden = NO;
    self.beautyLabel.hidden = NO;
    self.filterSlider.hidden = YES;
    self.filterLabel.hidden = YES;
    self.beautyCollectionView.hidden = NO;
    self.beautyTypeCollectionView.hidden = YES;
    self.effectCollectionView.hidden = YES;
    self.motionCollectionView.hidden = YES;
    self.koubeiCollectionView.hidden = YES;
    self.greenCollectionView.hidden = YES;
    self.functionCollectionView.hidden = NO;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.functionCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_functionCollectionView didSelectItemAtIndexPath:indexPath];
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.effectCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_effectCollectionView didSelectItemAtIndexPath:indexPath];
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.beautyTypeCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_beautyTypeCollectionView didSelectItemAtIndexPath:indexPath];
    
    [self.beautyCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_beautyCollectionView didSelectItemAtIndexPath:indexPath];
    
    [self.motionCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_motionCollectionView didSelectItemAtIndexPath:indexPath];
    
    [self.koubeiCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_koubeiCollectionView didSelectItemAtIndexPath:indexPath];
    
    [self.greenCollectionView  selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_greenCollectionView didSelectItemAtIndexPath:indexPath];
    
    [self.beautyValueMap removeAllObjects];
    [self.beautyValueMap setObject:@(6.3) forKey:@(0)]; //美颜默认值
    [self.beautyValueMap setObject:@(2.7) forKey:@(1)]; //美白默认值
    [self.beautyValueMap setObject:@(2.7) forKey:@(2)]; //红润默认值
    
    _whiteLevel = 2.7;
    _beautyLevel = 6.3;
    _ruddyLevel = 2.7;
    self.beautySlider.value = 6.3;
    self.filterSlider.value = 3;
    [self onValueChanged:self.beautySlider];
    [self onValueChanged:self.filterSlider];
}

- (void)trigglerValues{
    [self onValueChanged:self.beautySlider];
    [self onValueChanged:self.filterSlider];
}
@end

