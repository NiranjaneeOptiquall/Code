//
//  SOPViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "SOPViewController.h"
#import "SOPDetailViewController.h"
#import "ERPHeaderView.h"

@interface SOPViewController ()<UITextFieldDelegate>
{
    NSString *searchTextString;
    NSMutableArray *searchArray;
    BOOL isFilter;
    CGPoint contentOffset;
    bool isScroll;
    NSString * scrollFlag;
    NSInteger childSelectCount;
    
}


@end

@implementation SOPViewController

/*- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_dictSOPCategory) {
        [_btnSOPList setHidden:YES];
        [_lblTitle setText:@"Standard Operating Procedures"];
        [_tblSOPCategory setHidden:YES];
        [self getSOPCategories];
    }
    else {
        [_lblTitle setHidden:YES];
        CGRect frame = _tblSOPCategory.frame;
        frame.size.height = _mutArrCategoryHierarchy.count * _tblSOPCategory.rowHeight;
        _tblSOPCategory.frame = frame;
        
        if (CGRectGetMaxY(frame) > _tblSOPList.frame.origin.y) {
            frame = _tblSOPList.frame;
            frame.origin.y = CGRectGetMaxY(_tblSOPCategory.frame) + 5;
            frame.size.height = self.view.frame.size.height - frame.origin.y;
            _tblSOPList.frame = frame;
        }
        
        frame = _txtDescription.frame;
        frame.origin.y = CGRectGetMinY(_tblSOPList.frame) ;
        [_txtDescription setFrame:frame];
        
        frame = _viewWeb.frame;
        frame.origin.y = CGRectGetMinY(_tblSOPList.frame) ;
        [_viewWeb setFrame:frame];
        
        NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"Sequence.intValue" ascending:YES];
        NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
        
        NSMutableArray *aMutArrSOPList = [NSMutableArray arrayWithArray:[[_dictSOPCategory objectForKey:@"Children"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Published == 1"];

        mutArrSOPList = [NSMutableArray arrayWithArray:[aMutArrSOPList filteredArrayUsingPredicate:predicate]];
        
        //If Type has a value of 1 (Link) then the 'Link' property should be set
        //If Type has a value of 2 (Text) then the 'Description' property should be set
        
        [_viewWeb setHidden:YES];
        [_txtDescription setHidden:YES];
        
        if ([[_dictSOPCategory objectForKey:@"Type"] integerValue] == 2) {
          
            [_txtDescription setHidden:NO];
            NSString *aStrDescription = [NSString stringWithFormat:@"%@",[_dictSOPCategory objectForKey:@"Description"]];
            
            [_txtDescription setText:aStrDescription];
            NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:20] forKey: NSFontAttributeName];

            float height = 0;
            
            if ([[_dictSOPCategory objectForKey:@"Children"] count] > 0) {
                height = [aStrDescription boundingRectWithSize:CGSizeMake(_txtDescription.frame.size.width, 625) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height +20;
            }else{
                height = [aStrDescription boundingRectWithSize:CGSizeMake(_txtDescription.frame.size.width, self.view.frame.size.height - _txtDescription.frame.origin.y - 15) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height +20;
            }
            
            CGRect frameLblDescription  = _txtDescription.frame;
            if (_txtDescription.frame.origin.y + height >= 745) {
                height = 745-_txtDescription.frame.origin.y;
            }
            
            frameLblDescription.size.height = height;
            _txtDescription.frame = frameLblDescription;
            [_txtDescription setFont:[UIFont systemFontOfSize:20]];
            [_txtDescription setTextAlignment:NSTextAlignmentLeft];
            
            
            frame = _tblSOPList.frame;
            frame.origin.y = 765; //CGRectGetMaxY(_txtDescription.frame) + 15;
            frame.size.height = self.view.frame.size.height - frame.origin.y;
            _tblSOPList.frame = frame;
            
        }else if ([[_dictSOPCategory objectForKey:@"Type"] integerValue] == 1){
            [_viewWeb setHidden:NO];
            
            frame = _viewWeb.frame;
            frame.size.height = self.view.frame.size.height - _tblSOPList.frame.origin.y;
            [_viewWeb setFrame:frame];
            
            NSString *aStrLink = [NSString stringWithFormat:@"%@",[_dictSOPCategory objectForKey:@"Link"]];
             [_viewWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aStrLink]]];
        }
    }
}
*/

/* 
changes by chetan kasundra
Put the webview in place  of textview for type 2( for html Description set in webview)
*/




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_txtSearchTag resignFirstResponder];
}
- (void)viewDidLoad{
    [super viewDidLoad];

    scrollFlag=@"NO";
    [_lblSearchNote setHidden:YES];

    _txtSearchTag.delegate=self;
    [self.txtSearchTag addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     if (!_dictSOPCategory){
        allSearchData=[[NSMutableArray alloc]init];

        [_btnSOPList setHidden:YES];
        [_lblTitle setText:@"Standard Operating Procedures"];
        [_tblSOPCategory setHidden:YES];
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"NOTE"];

        [self getSOPCategories];
        
        CGRect frame = _mainScrlView.frame;
        frame.origin.y = CGRectGetMinY(_txtSearchTag.frame) + CGRectGetHeight(_txtSearchTag.frame)+20 ;
        CGFloat newYPosition= CGRectGetMinY(_txtSearchTag.frame) +CGRectGetHeight(_txtSearchTag.frame)+20;
        CGFloat height=newYPosition - _mainScrlView.frame.origin.y;
        frame.size.height=frame.size.height - height;
        [_mainScrlView setFrame:frame];

        frame = _tblSOPList.frame;
        frame.origin.y = 0;
       // frame.size.height = self.view.frame.size.height - frame.origin.y;
        _tblSOPList.frame = frame;
    }
    else{
        [_lblTitle setHidden:YES];
        CGRect frame = _tblSOPCategory.frame;
        frame.size.height = _mutArrCategoryHierarchy.count * _tblSOPCategory.rowHeight;
        _tblSOPCategory.frame = frame;
        
        frame = _txtSearchTag.frame;
        frame.origin.y = CGRectGetMinY(_tblSOPCategory.frame) + CGRectGetHeight(_tblSOPCategory.frame) +40;
        [_txtSearchTag setFrame:frame];
        
        frame = _btnSearchTag.frame;
        frame.origin.y = CGRectGetMinY(_tblSOPCategory.frame) + CGRectGetHeight(_tblSOPCategory.frame) + 40;
        [_btnSearchTag setFrame:frame];

        frame = _lblSearchNote.frame;
        frame.origin.y = CGRectGetMinY(_tblSOPCategory.frame) + CGRectGetHeight(_tblSOPCategory.frame) +55;
        [_lblSearchNote setFrame:frame];

        
            frame = _mainScrlView.frame;
            frame.origin.y = CGRectGetMinY(_txtSearchTag.frame) + CGRectGetHeight(_txtSearchTag.frame) +20;
            CGFloat newYPosition= CGRectGetMinY(_txtSearchTag.frame) +CGRectGetHeight(_txtSearchTag.frame)+20;
            CGFloat height=newYPosition - _mainScrlView.frame.origin.y;
            frame.size.height=frame.size.height - height;
            [_mainScrlView setFrame:frame];
            
        
        frame = _viewWebDescription.frame;
        frame.origin.y = 0 ;
        [_viewWebDescription setFrame:frame];
        
        frame = _viewWeb.frame;
        frame.origin.y = CGRectGetMinY(_tblSOPList.frame) +_mainScrlView.frame.origin.y ;
        [_viewWeb setFrame:frame];
        
        NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"Sequence.intValue" ascending:YES];
        NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
        
        NSMutableArray *aMutArrSOPList = [NSMutableArray arrayWithArray:[[_dictSOPCategory objectForKey:@"Children"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Published == 1"];
        
        mutArrSOPList = [NSMutableArray arrayWithArray:[aMutArrSOPList filteredArrayUsingPredicate:predicate]];
        
        //If Type has a value of 1 (Link) then the 'Link' property should be set
        //If Type has a value of 2 (Text) then the 'Description' property should be set
        
        [_viewWeb setHidden:YES];
        [_viewWebDescription setHidden:YES];
        
        if ([[_dictSOPCategory objectForKey:@"Type"] integerValue] == 2)
        {
        
            [_viewWebDescription setHidden:NO];
            _viewWebDescription.delegate=self;
            NSString *aStrDescription = [NSString stringWithFormat:@"%@",[_dictSOPCategory objectForKey:@"Description"]];
            [_viewWebDescription loadHTMLString:aStrDescription baseURL:nil];

     
            
        }else if ([[_dictSOPCategory objectForKey:@"Type"] integerValue] == 1)
        {
            [_viewWeb setHidden:NO];

            frame = _viewWeb.frame;
            frame.size.height = self.view.frame.size.height - _tblSOPList.frame.origin.y;
            [_viewWeb setFrame:frame];
            
            NSString *aStrLink = [NSString stringWithFormat:@"%@",[_dictSOPCategory objectForKey:@"Link"]];
            [_viewWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aStrLink]]];
            CGFloat height= _viewWeb.scrollView.contentSize.height;
            if (height > 870) {
                frame = _viewWeb.frame;
                frame.size.height = 870;
                [_viewWeb setFrame:frame];
            }

        }
    }
     //  [_txtSearchTag setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
 if (mutArrSOPList.count == 0) {
        [_btnSearchTag setHidden:YES];
       [_txtSearchTag setHidden:YES];
 }

    if ([[_dictSOPCategory objectForKey:@"Type"] integerValue] == 2)
    {
        [_btnSearchTag setHidden:YES];
   [_txtSearchTag setHidden:YES];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"NOTE"] isEqualToString:@""]) {
            [_lblSearchNote setHidden:YES];
        }
        else{
            [_lblSearchNote setHidden:NO];

             _lblSearchNote.text=[NSString stringWithFormat:@"Showing search result for '%@'",[[NSUserDefaults standardUserDefaults]valueForKey:@"NOTE"]];
        }
    }
    else if ([[_dictSOPCategory objectForKey:@"Type"] integerValue] == 1)
    {
        [_btnSearchTag setHidden:YES];
   [_txtSearchTag setHidden:YES];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"NOTE"] isEqualToString:@""]) {
            [_lblSearchNote setHidden:YES];
        }
        else{
            [_lblSearchNote setHidden:NO];
            
            _lblSearchNote.text=[NSString stringWithFormat:@"Showing search result for '%@'",[[NSUserDefaults standardUserDefaults]valueForKey:@"NOTE"]];
        }
    }
//    else{
//        
//        [_btnSearchTag setHidden:NO];
//        [_lblSearchNote setHidden:YES];
//
//        if(!_btnSearchTag.isSelected)
//        {
//           
//               _txtSearchTag.hidden=YES;
//        }
//        else{
//         _txtSearchTag.hidden=NO;
//        
//        }
//
//    }
    
    
    
}
-(IBAction)btnSearchTagClicked:(id)sender {
    
    
//    if(!_btnSearchTag.isSelected)
//    {
//      _txtSearchTag.hidden=NO;
//        [_btnSearchTag setSelected:YES];
//    }
//    else{
//        _txtSearchTag.hidden=YES;
//        [_btnSearchTag setSelected:NO];
//    }
    
}


-(void)textFieldDidChange:(UITextField *)textField
{
     searchTextString=textField.text;
    [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:@"NOTE"];
    [self updateSearchArray:searchTextString];
}
-(void)updateSearchArray:(NSString *)searchText
{
    if(searchText.length==0)
    {
        isFilter=NO;
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"noteHidden"];

    }
    else{
        
        isFilter=YES;
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"noteHidden"];

        searchArray=[[NSMutableArray alloc]init];
        for(int q=0;q<allSearchData.count;q++){
            
            
            
            NSString *stringTitle=[[allSearchData valueForKey:@"Title"] objectAtIndex:q];

            if ([stringTitle isKindOfClass:[NSNull class]]) {
                stringTitle=@"";
            }
                NSRange stringRangeTitle=[stringTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            NSString *stringTag=[[allSearchData valueForKey:@"Tag"] objectAtIndex:q];
            if ([stringTag isKindOfClass:[NSNull class]]) {
                stringTag=@"";
            }
            NSArray *tagItems = [stringTag componentsSeparatedByString:@","];
            NSRange stringRangeTag = NSMakeRange(0,  stringTag.length);
             stringRangeTag=[[tagItems objectAtIndex:0] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            for (int i = 0; i<tagItems.count; i++) {
                if (stringRangeTag.location !=NSNotFound) {
                    break;
                }
                else{
                    stringRangeTag=[[tagItems objectAtIndex:i] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                }
            }
            
            if(stringRangeTitle.location !=NSNotFound || stringRangeTag.location !=NSNotFound){
                
                [searchArray addObject:[allSearchData objectAtIndex:q]];
            }
        }
        
    }
    if (searchArray.count == 0) {
        _lblNoRecords.frame=CGRectMake(_lblNoRecords.frame.origin.x, _tblSOPList.frame.origin.y + 20, _lblNoRecords.frame.size.width, _lblNoRecords.frame.size.height);
        [_lblNoRecords setHidden:NO];
    }
    else{
        [_lblNoRecords setHidden:YES];
        
    }

    [self.tblSOPList reloadData];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_txtSearchTag resignFirstResponder];
  //  isScroll = NO;
    [self.mainScrlView setContentOffset:contentOffset animated:YES];
    [textField endEditing:true];
  //  return  true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark UIWebViewDelgate

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    if ([webView isEqual:_viewWebDescription])
//    {
//        //CGFloat height=[[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
        
//        CGFloat height= webView.scrollView.contentSize.height;
        
//        CGRect frameWebView=_viewWebDescription.frame;
        
//        if (_viewWebDescription.frame.origin.y + height >= 490)
//        {
//            height= 490 - _viewWebDescription.frame.origin.y;
//        }
        
//        frameWebView.size.height=height;
//        _viewWebDescription.frame= frameWebView;
//    }
//    CGRect frame = _tblSOPList.frame;
//    frame.origin.y = _viewWebDescription.frame.origin.y+ _viewWebDescription.frame.size.height + 10; //CGRectGetMaxY(_txtDescription.frame) + 15;
//       frame.size.height = self.view.frame.size.height - frame.origin.y;
//    if (frame.size.height > CGRectGetHeight(_mainScrlView.frame) - 500) {
//        frame.size.height = CGRectGetHeight(_mainScrlView.frame) - 500 -20 ;
//    }
//    _tblSOPList.frame = frame;

//}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //CGFloat height=[[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    if(isFilter){
        
        if (searchArray.count < 4) {
            
            //58
            [self webviewHeight:58*(int)[searchArray count] view:webView];
            
        }
        else{
            [self webviewHeight:58*4 view:webView];
            
        }
    }
    else{
        
        if (mutArrSOPList.count < 4) {
            [self webviewHeight:58*(int)[mutArrSOPList count] view:webView];
        }
        else{
            [self webviewHeight:58*4 view:webView];
            
        }
    }
    
    
}

-(void)webviewHeight:(int)heightView view:(UIWebView *)webView
{
    
    if ([webView isEqual:_viewWebDescription])
    {
        
        CGFloat height= webView.scrollView.contentSize.height - heightView;
        
        CGRect frameWebView=_viewWebDescription.frame;
        if (heightView !=0) {
            if (heightView < 232) {
                
                height=_mainScrlView.frame.size.height - heightView-30;
            }
            else if (_viewWebDescription.frame.origin.y + height >= 600)
            {
                height= 600 - _viewWebDescription.frame.origin.y;
            }
            
        }
        else if (_viewWebDescription.frame.origin.y + height >= 830){
            height= 830 - _viewWebDescription.frame.origin.y;
        }
        else{
            height = _mainScrlView.frame.size.height;
            
        }
        frameWebView.size.height=height;
        _viewWebDescription.frame= frameWebView;
    }
    CGRect frame = _tblSOPList.frame;
    frame.origin.y = _viewWebDescription.frame.origin.y+ _viewWebDescription.frame.size.height + 20; //CGRectGetMaxY(_txtDescription.frame) + 15;
    frame.size.height = heightView;
    if (frame.size.height > CGRectGetHeight(_mainScrlView.frame) - 620) {
        frame.size.height = CGRectGetHeight(_mainScrlView.frame) - 620 -20 ;
    }
    _tblSOPList.frame = frame;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SOPDetail"]) {
        SOPDetailViewController *aDetail = (SOPDetailViewController*)segue.destinationViewController;
        aDetail.dictSopCategry = sender;
        aDetail.mutArrCategoryHierarchy = _mutArrCategoryHierarchy;
        [aDetail.mutArrCategoryHierarchy addObject:[sender objectForKey:@"Title"]];
    }
}


#pragma mark - IBActions & Selectors

- (void)btnHeaderTapped:(UIButton*)btn {
    BOOL isExpanded = [[[mutArrSOPList objectAtIndex:btn.tag] objectForKey:@"isExpanded"] boolValue];
    isExpanded = !isExpanded;
    [[mutArrSOPList objectAtIndex:btn.tag] setObject:[NSNumber numberWithBool:isExpanded] forKey:@"isExpanded"];
//    [_tblSOPList reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [mutArrSOPList count] - 1)] withRowAnimation:UITableViewRowAnimationFade];
    [_tblSOPList reloadData];
}


- (IBAction)unwindBackToSOPListScreen:(UIStoryboardSegue*)segue {
  [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"childSelectCount"];
}

- (IBAction)btnBackTapped:(id)sender {
  
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"childSelectCount"] == 0) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isBackToMainView"];
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"NOTE"];

    }
    else{
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isBackToMainView"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [_mutArrCategoryHierarchy removeLastObject];
}

- (IBAction)btnSOPListTapped:(id)sender {
    [_mutArrCategoryHierarchy removeAllObjects];
    NSArray *vcs = [self.navigationController viewControllers];
    for (int i = 0; i < [vcs count]; i++) {
        if ([vcs[i] isKindOfClass:[SOPViewController class]]) {
            [self.navigationController popToViewController:vcs[i] animated:YES];
            break;
        }
    }
}

#pragma mark - Methods

- (void)getSOPCategories {
    

   // allSopArrList=[[NSMutableArray alloc]init];


    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",SOP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SOP_CATEGORY] complition:^(NSDictionary *response) {
        _dictSOPCategory = response;
        NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"Sequence.intValue" ascending:YES];
        NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
        
        NSMutableArray *aMutArrSOPList = [NSMutableArray arrayWithArray:[[response objectForKey:@"SopCategories"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Published == 1"];
        
        mutArrSOPList = [NSMutableArray arrayWithArray:[aMutArrSOPList filteredArrayUsingPredicate:predicate]];
        
      //  allSopArrList =[self allDAtaMethode:mutArrSOPList];
     //   for (NSMutableDictionary * tempDic in mutArrSOPList) {
            
            [self allDAtaMethode:mutArrSOPList];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"childSelectCount"] ;
        //  }
        if ([mutArrSOPList count] == 0) {
            [_lblNoRecords setHidden:NO];
            [_btnSearchTag setHidden:YES];
            [_txtSearchTag setHidden:YES];

        }
        else{
            [_btnSearchTag setHidden:NO];
           [_txtSearchTag setHidden:NO];
        }
        [_tblSOPList reloadData];
    } failure:^(NSError *error, NSDictionary *response) {
        [_lblNoRecords setHidden:NO];
        
//        NSString *strDocumentPath = [NSString stringWithFormat:@"%@",gblAppDelegate.applicationDocumentsDirectory.path];
//        NSString *strSopFilePath = [strDocumentPath stringByAppendingPathComponent:@"SopCategory.txt"];
//        
//        NSString *strData = [[NSString alloc] initWithContentsOfFile:strSopFilePath encoding:NSUTF8StringEncoding error:nil];
//
//        _dictSOPCategory = [NSJSONSerialization JSONObjectWithData:[strData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//        NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"Sequence.intValue" ascending:YES];
//        NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
//        
//        NSMutableArray *aMutArrSOPList = [NSMutableArray arrayWithArray:[[_dictSOPCategory objectForKey:@"SopCategories"] sortedArrayUsingDescriptors:@[sortBySequence,sortByTitle]]];
//        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Published == 1"];
//        
//        mutArrSOPList = [NSMutableArray arrayWithArray:[aMutArrSOPList filteredArrayUsingPredicate:predicate]];
//        
//        if ([mutArrSOPList count] == 0) {
//            [_lblNoRecords setHidden:NO];
//        }
//        [_tblSOPList reloadData];

    }];
   
}

-(void) allDAtaMethode : (NSMutableArray *)arr {
    
    for (NSMutableDictionary * tempDic in arr) {
        [allSearchData addObject:tempDic];
        if ([[tempDic valueForKey:@"Children"] count] ==0) {
            
            [allSopArrList addObject:tempDic];
            
                }
        else{
            [self allDAtaMethode:[tempDic valueForKey:@"Children"]];
        }
    }
    NSData * data=[NSKeyedArchiver archivedDataWithRootObject:allSearchData];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"allSearchData"];
 
}
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[mutArrSOPList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_tblSOPCategory]) {
        return [_mutArrCategoryHierarchy count];
    }
    else{
        if(isFilter){
            return [searchArray count];
        }
     
        return [mutArrSOPList count];
    }

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([tableView isEqual:_tblSOPCategory]) {
        [aCell setBackgroundColor:[UIColor clearColor]];
        UILabel *lbl = (UILabel*)[aCell.contentView viewWithTag:2];
        [lbl setText:[[_mutArrCategoryHierarchy objectAtIndex:indexPath.row] objectForKey:@"Title"]];
        UILabel *lblDisplaySequence = (UILabel*)[aCell.contentView viewWithTag:4];
        [lblDisplaySequence setText:[[_mutArrCategoryHierarchy objectAtIndex:indexPath.row] objectForKey:@"DisplaySequence"]];
        CGRect frame = lbl.frame;
        frame.origin.x = indexPath.row * 50 + 5;
        frame.size.width = 532 - frame.origin.x;
        lbl.frame = frame;
    }
    else {
        if (indexPath.row == 0 || indexPath.row % 2 == 0) {
            [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        }
        else {
            [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
        }
        
        if (isFilter) {
            
            NSDictionary *aDict = [searchArray objectAtIndex:indexPath.row];
            UIImageView *aImgView = (UIImageView *)[aCell.contentView viewWithTag:1];
            UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
            UILabel *lblDisplaySequence = (UILabel*)[aCell.contentView viewWithTag:6];
            
            NSString *aStrTitle = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"Title"]];
            [aLbl setText:aStrTitle];
            [lblDisplaySequence setText:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"DisplaySequence"]]];
            
            //LinkType = 0 Text ,LinkType = 1 Link, LinkType = 2 Photo, LinkType = 3 Video, LinkType = 4 PDF.
            
            if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 0) {
                [aImgView setImage:[UIImage imageNamed:@"list_icon.png"]];
            }else if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 1){
                [aImgView setImage:[UIImage imageNamed:@"erp_link_icon.png"]];
            }else if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 2){
                [aImgView setImage:[UIImage imageNamed:@"erp_photo_icon.png"]];
            }else if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 3){
                [aImgView setImage:[UIImage imageNamed:@"erp_video_icon.png"]];
            }else if ([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 4){
                [aImgView setImage:[UIImage imageNamed:@"erp_pdf_icon.png"]];
            }
            
            if (![aDict objectForKey:@"Children"]  || [[aDict objectForKey:@"Children"] isKindOfClass:[NSNull class]]) {
                [aCell setAccessoryType:UITableViewCellAccessoryNone];
            }
            else {
                [aCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            UIView *aView = [aCell.contentView viewWithTag:4];
            CGRect frame = aView.frame;
            frame.origin.y = aCell.frame.size.height - 3;
            [aView setFrame:frame];
            
        }
        
        else{
            NSDictionary *aDict = [mutArrSOPList objectAtIndex:indexPath.row];
            UIImageView *aImgView = (UIImageView *)[aCell.contentView viewWithTag:1];
            UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
            UILabel *lblDisplaySequence = (UILabel*)[aCell.contentView viewWithTag:6];
            
            NSString *aStrTitle = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"Title"]];
            [aLbl setText:aStrTitle];
            [lblDisplaySequence setText:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"DisplaySequence"]]];
            
            //LinkType = 0 Text ,LinkType = 1 Link, LinkType = 2 Photo, LinkType = 3 Video, LinkType = 4 PDF.
            
            if ([[[mutArrSOPList objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 0) {
                [aImgView setImage:[UIImage imageNamed:@"list_icon.png"]];
            }else if ([[[mutArrSOPList objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 1){
                [aImgView setImage:[UIImage imageNamed:@"erp_link_icon.png"]];
            }else if ([[[mutArrSOPList objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 2){
                [aImgView setImage:[UIImage imageNamed:@"erp_photo_icon.png"]];
            }else if ([[[mutArrSOPList objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 3){
                [aImgView setImage:[UIImage imageNamed:@"erp_video_icon.png"]];
            }else if ([[[mutArrSOPList objectAtIndex:indexPath.row] objectForKey:@"LinkType"] integerValue] == 4){
                [aImgView setImage:[UIImage imageNamed:@"erp_pdf_icon.png"]];
            }
            
            if (![aDict objectForKey:@"Children"]  || [[aDict objectForKey:@"Children"] isKindOfClass:[NSNull class]]) {
                [aCell setAccessoryType:UITableViewCellAccessoryNone];
            }
            else {
                [aCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            UIView *aView = [aCell.contentView viewWithTag:4];
            CGRect frame = aView.frame;
            frame.origin.y = aCell.frame.size.height - 3;
            [aView setFrame:frame];
        }
        
    }
    return aCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    childSelectCount=[[NSUserDefaults standardUserDefaults]integerForKey:@"childSelectCount"];
    [[NSUserDefaults standardUserDefaults]setInteger:childSelectCount + 1 forKey:@"childSelectCount"];
   // [_btnSearchTag setHidden:YES];

     [_lblNoRecords setHidden:YES];
    if (isFilter) {
       // isFilter = NO;
        NSDictionary *aDict = [searchArray objectAtIndex:indexPath.row];
        if (!_mutArrCategoryHierarchy) {
            _mutArrCategoryHierarchy = [NSMutableArray array];
        }
        
        
        SOPViewController *sopView = [self.storyboard instantiateViewControllerWithIdentifier:@"SOPViewController"];
        sopView.dictSOPCategory = aDict;
        sopView.mutArrCategoryHierarchy = _mutArrCategoryHierarchy;
        [sopView.mutArrCategoryHierarchy addObject:[NSDictionary dictionaryWithObjectsAndKeys:[aDict objectForKey:@"Title"],@"Title",[aDict objectForKey:@"DisplaySequence"],@"DisplaySequence", nil]];
        [self.navigationController pushViewController:sopView animated:YES];
        
    }
    else{
        NSDictionary *aDict = [mutArrSOPList objectAtIndex:indexPath.row];
        if (!_mutArrCategoryHierarchy) {
            _mutArrCategoryHierarchy = [NSMutableArray array];
        }
        
        
        SOPViewController *sopView = [self.storyboard instantiateViewControllerWithIdentifier:@"SOPViewController"];
        sopView.dictSOPCategory = aDict;
        sopView.mutArrCategoryHierarchy = _mutArrCategoryHierarchy;
        [sopView.mutArrCategoryHierarchy addObject:[NSDictionary dictionaryWithObjectsAndKeys:[aDict objectForKey:@"Title"],@"Title",[aDict objectForKey:@"DisplaySequence"],@"DisplaySequence", nil]];
        [self.navigationController pushViewController:sopView animated:YES];
        
        
        
    }
    
}
@end
