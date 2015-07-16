//
//  CVNPPointPresentTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/2/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//
#import "Config.h"
#import "CVNPSqliteManager.h"

#import "CVNPPointPresentTableViewController.h"

#import "CVNPCategoryModel.h"
#import "CVNPCategoryTableViewController.h"

#import "CVNPPointPresentImageItem.h"

@interface CVNPPointPresentTableViewController () <CVNPCategoryTableViewControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *imageSection;
@property (strong, readwrite, nonatomic) RETableViewSection *gisInfoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *userInfoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *buttonSection;
@property (strong, readwrite, nonatomic) RETableViewSection *retainSection;

@property (strong, readwrite, nonatomic) CVNPPointPresentImageItem *imageItem;

@property (strong, readwrite, nonatomic) RETextItem *longitudeItem;
@property (strong, readwrite, nonatomic) RETextItem *latitudeItem;
@property (strong, readwrite, nonatomic) RETextItem *createTimeItem;
@property (strong, readwrite, nonatomic) REBoolItem *isUploadedBoolItem;

@property (strong, readwrite, nonatomic) RETextItem *titleItem;
@property (strong, readwrite, nonatomic) RELongTextItem *descriptionItem;
@property (strong, readwrite, nonatomic) REPickerItem *categoryPickerItem;
@property (strong, readwrite, nonatomic) RETableViewItem *categoryDetailItem;

@property (strong, nonatomic) CVNPSqliteManager *DAO;
@property (strong, nonatomic) CVNPCategoryModel *selectedCategory;
@property (strong, nonatomic) CVNPCategoryModel *pickerCategory;
@property (strong, nonatomic) CVNPCategoryModel *existCategory;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *modifyBarButtonItem;

@property (strong, readwrite, nonatomic) NSNumber *userPhotoID;
@property (strong, readwrite, nonatomic) NSString *userPhotoFileName;
@property (strong, readwrite, nonatomic) UIImage *userPhoto;

@end

@implementation CVNPPointPresentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Point Infomation";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    
    self.manager[@"CVNPPointPresentImageItem"] = @"CVNPPointPresentImageCell";
    
    self.DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    self.imageSection = [self addImageControls];
    self.userInfoSection = [self addUsernfoControls];
    self.gisInfoSection = [self addGISControls];
    self.buttonSection = [self addButtonControls];
    
    self.selectedCategory = [[CVNPCategoryModel alloc] init];
    [self.selectedCategory setCat_ID:@"0"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - RETableViewForm

- (RETableViewSection *)addImageControls
{
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Picture"];
    [self.manager addSection:section];
    if (self.currentPoint.Photo_ID.intValue != -1) {
        self.userPhotoFileName = [self.DAO QueryFileNameByPhotoID:self.currentPoint.Photo_ID];
        if (!self.currentPoint.isCenter) {
            self.imageItem = [CVNPPointPresentImageItem itemWithImagePath:[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"CVNPSavedIMG"]stringByAppendingPathComponent:self.userPhotoFileName]];
            [section addItem:self.imageItem];
        }
    }
    else {
    }
    return section;
}

- (RETableViewSection *)addUsernfoControls
{
    __typeof (&*self) __weak weakSelf = self;
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"User Input Informations"];
    [self.manager addSection:section];
    
    self.titleItem = [RETextItem itemWithTitle:@"Title" value:self.currentPoint.Title placeholder:@"Title"];
    
    self.descriptionItem = [RELongTextItem itemWithValue:self.currentPoint.Description placeholder:@"Description"];
    self.descriptionItem.cellHeight = 100;
    
    self.pickerCategory = [[CVNPCategoryModel alloc] init];
    [self.pickerCategory setCat_ID:@"0"];
    
    NSArray *categoriesObjectInPicker = [NSArray arrayWithArray:[_DAO QueryChildCategoriesByCate:self.pickerCategory]];
    NSMutableArray * cateName = [[NSMutableArray alloc] init];
    for (CVNPCategoryModel *cate in categoriesObjectInPicker) {
        [cateName addObject:[cate Cat_Name]];
    }

    self.categoryPickerItem = [REPickerItem itemWithTitle:@"Category Picker" value:@[[cateName objectAtIndex:0]] placeholder:nil options:@[cateName]];
    self.categoryPickerItem.onChange = ^(REPickerItem *item) {
        for (CVNPCategoryModel *cate in categoriesObjectInPicker) {
            if ([item.value[0] isEqualToString:[cate Cat_Name]]) {
                weakSelf.pickerCategory = cate;
            }
        }
    };
    self.pickerCategory = categoriesObjectInPicker[0];
    self.categoryPickerItem.inlinePicker = YES;
    
    self.categoryDetailItem = [RETableViewItem itemWithTitle:@"Category Detail" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        CVNPCategoryTableViewController *controller = [[CVNPCategoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        controller.delegate = weakSelf;
        controller.level = 0;
        controller.parentCategory = weakSelf.pickerCategory;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    if (![self.currentPoint.Category isEqualToString:@""] && self.currentPoint.Category != nil) {
        self.existCategory = [self.DAO QueryCategoryInfoById:self.currentPoint.Category];
        if ([self.currentPoint.Category isEqualToString:@"0"]) {
            self.categoryDetailItem.detailLabelText = @"Not Selected";
        } else {
            self.categoryDetailItem.detailLabelText = self.existCategory.Cat_Name;
        }
        self.categoryDetailItem.style = UITableViewCellStyleValue1;
    }
    else {
        self.categoryDetailItem.detailLabelText = @"Not Selected";
        self.categoryDetailItem.style = UITableViewCellStyleValue1;
    }
    
    [section addItem:self.titleItem];
    [section addItem:self.descriptionItem];
    [section addItem:self.categoryPickerItem];
    [section addItem:self.categoryDetailItem];

    return section;
}

- (RETableViewSection *)addGISControls
{
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"GIS Informations"];
    [self.manager addSection:section];
    
    self.longitudeItem =  [RETextItem itemWithTitle:@"Longitutd" value:self.currentPoint.Longitude];
    self.latitudeItem =  [RETextItem itemWithTitle:@"Latitude" value:self.currentPoint.Latitude];
    self.createTimeItem = [RETextItem itemWithTitle:@"Created Time" value:self.currentPoint.CreateDate];
    self.isUploadedBoolItem = [REBoolItem itemWithTitle:@"Uploaded" value:self.currentPoint.isUpdated];
    
    self.longitudeItem.enabled = NO;
    self.latitudeItem.enabled = NO;
    self.createTimeItem.enabled = NO;
    self.isUploadedBoolItem.enabled = NO;
    
    [section addItem:self.longitudeItem];
    [section addItem:self.latitudeItem];
    [section addItem:self.createTimeItem];
    [section addItem:self.isUploadedBoolItem];
    return section;
}

- (RETableViewSection *)addButtonControls
{
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"User Operation"];
    [self.manager addSection:section];
    
    RETableViewItem *cameraButtonItem = [RETableViewItem itemWithTitle:@"Photo" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Camera", @"Library",nil];
        [actionSheet setTag:2];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        
        [actionSheet showInView:self.view];
    }];
    cameraButtonItem.textAlignment = NSTextAlignmentCenter;
    
    RETableViewItem *uploadButtonItem = [RETableViewItem itemWithTitle:@"Upload" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        item.title = @"Pressed!";
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    }];
    uploadButtonItem.textAlignment = NSTextAlignmentCenter;
    
    RETableViewItem *deletelButtonItem = [RETableViewItem itemWithTitle:@"Delete" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete this point"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Delete"
                                                        otherButtonTitles:nil];
        [actionSheet setTag:0];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        
        [actionSheet showInView:self.view];
    }];
    deletelButtonItem.textAlignment = NSTextAlignmentCenter;
    
    [section addItem:cameraButtonItem];
    [section addItem:uploadButtonItem];
    [section addItem:deletelButtonItem];
    
    return section;
}

#pragma mark - UI delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        
        if (buttonIndex == 0) {
            [_DAO DeleteLocalById:[self.currentPoint.Local_ID intValue]];
            if (self.navigationItem.leftBarButtonItem == self.navigationItem.backBarButtonItem) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            self.currentPoint.Title = self.titleItem.value;
            self.currentPoint.Description = self.descriptionItem.value;
            self.currentPoint.Category = self.selectedCategory.Cat_ID;
            
            [_DAO UpdateLocalById:[self.currentPoint.Local_ID intValue] newPoint:self.currentPoint];
            if (self.navigationItem.leftBarButtonItem == self.navigationItem.backBarButtonItem) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    if (actionSheet.tag == 2) {
        switch (buttonIndex) {
            case 0:
                [self photoFromCamera];
                break;
            case 1:
                [self photoFromAlbum];
                break;
            default:
                break;  
        }
    }
}

//Take photos from Album
- (void)photoFromAlbum{
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:^{
    }];
    
}

//Take photos from Camera
- (void)photoFromCamera{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//Set Camer Type for ImagePicker
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This device is not support camera" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

//After Add Photo from PickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *prename = @"CVNPSavedIMG";
    NSString *myUniqueName = [NSString stringWithFormat:@"%@-%u", prename, (NSUInteger)([[NSDate date] timeIntervalSince1970]*10.0)];
    self.userPhotoFileName = [myUniqueName stringByAppendingString:@".png"];
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        //Save Photos to Album
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self saveImage:image withName:self.userPhotoFileName];
    [self.DAO InsertPhotoRecordswithFileName:self.userPhotoFileName andUser_ID:[[Config getOwnID] isEqualToString:@""] ? @"-1" : [Config getOwnID]];
    self.userPhotoID = [self.DAO QueryIdByPhotoFileName:self.userPhotoFileName];
    NSLog(@"%@",self.userPhotoFileName);
    self.imageItem = [CVNPPointPresentImageItem itemWithImagePath:[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"CVNPSavedIMG"]stringByAppendingPathComponent:self.userPhotoFileName]];
    [self.imageSection addItem:self.imageItem];
    [self.imageSection reloadSectionWithAnimation:UITableViewRowAnimationNone];
}

//Save IMG into sandbox
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    // Get SandBox PATH in Documents/CVNPSavedIMG
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *doc = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"CVNPSavedIMG"];
    
    if (![fileManager fileExistsAtPath:doc]) {
        [fileManager createDirectoryAtPath:doc withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *fullPath = [doc stringByAppendingPathComponent:imageName];
    
    // Save Img data to file system
    [imageData writeToFile:fullPath atomically:NO];
    
    self.userPhoto = [UIImage imageWithContentsOfFile:fullPath];
    
}

//Cancel Operation
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Button Action

- (void)updateBarButtonItem
{
    self.navigationItem.leftBarButtonItem = self.cancelBarButtonItem;
    if (self.currentPoint.isCenter) {
        self.navigationItem.rightBarButtonItem = self.addBarButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = self.modifyBarButtonItem;
    }
}

- (void)getSelectCategory:(CVNPCategoryModel *)choosen
{
    self.selectedCategory = choosen;
    self.categoryDetailItem.detailLabelText = choosen.Cat_Name;
    self.categoryDetailItem.style = UITableViewCellStyleValue1;
    [self.categoryDetailItem reloadRowWithAnimation:UITableViewRowAnimationNone];
}

- (IBAction)addBarButtonItemClickAction:(id)sender {
    [self.currentPoint setTitle:self.titleItem.value];
    [self.currentPoint setDescription:self.descriptionItem.value];
    [self.currentPoint setCategory:self.selectedCategory.Cat_ID];
    
    [self.currentPoint setPhoto_ID:self.userPhotoID];
    [self.DAO InsertLocal:self.currentPoint];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelBarButtonItemClickAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)modifyBarButtonItemClickAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Modify this point"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Modify"
                                                    otherButtonTitles:nil];
    [actionSheet setTag:1];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [actionSheet showInView:self.view];
}

@end
