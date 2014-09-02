//
//  NewBallCollapsebleTableView.m
//  
//
//  Created by Ian Fox on 8/19/14.
//
//

#import "CollapsebleTableView.h"

@interface CollapsebleTableView()
{
    int defaultHeight;
    bool sectionsInitiallyCollapsed;
}
@end
@implementation CollapsebleTableView
@synthesize sectionIsCollapsedMap, realDataSource, realDelegate, sectionToIdentifier, identifierToSection;

#pragma mark Initialization
-(void) postInit
{
    //map a BOOL to unique identifier for each Header object
    if (!sectionIsCollapsedMap) sectionIsCollapsedMap = [[NSMutableDictionary alloc] init];
    if (!sectionToIdentifier) sectionToIdentifier = [[NSMutableDictionary alloc] init];
    if (!identifierToSection) identifierToSection = [[NSMutableDictionary alloc] init];
    sectionsInitiallyCollapsed = NO;
    defaultHeight = 40;
}
- (id) init
{
    if ((self = [super init]))
        [self postInit];
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
        [self postInit];
    return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ((self = [super initWithFrame:frame style:style]))
        [self postInit];
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    return self = [super initWithFrame:frame];
}



#pragma mark Properties

- (void) setDelegate:(id <UITableViewDelegate>) newDelegate
{
    [super setDelegate: self];
    realDelegate = newDelegate;
}

- (void) setDataSource:(id <UITableViewDataSource>) newDataSource
{
    [super setDataSource:self];
    realDataSource = newDataSource;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [realDelegate tableView: tableView heightForRowAtIndexPath:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [realDelegate tableView:tableView heightForHeaderInSection:section];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    if ([realDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
    {
        headerView = [realDelegate tableView:tableView viewForHeaderInSection:section];
    } else {
        CGSize deviceSize = [[UIScreen mainScreen] bounds].size;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceSize.width, defaultHeight)];
        view.backgroundColor  = [UIColor blackColor];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        title.text = [NSString stringWithFormat:@"%i", section];
        title.textColor = [UIColor whiteColor];
        [view addSubview:title];
        headerView = view;
    }

    [self checkSetUp: section];
    return headerView;
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.realDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.realDataSource numberOfSectionsInTableView: tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    [self checkSetUp: section];

    NSNumber *val = [sectionIsCollapsedMap objectForKey:
                     [sectionToIdentifier objectForKey: [NSNumber numberWithInt:section]]];
    
    int rowsValue = [val boolValue] ? [self.realDataSource tableView:tableView numberOfRowsInSection:section] : 0;
    return rowsValue;
   // return rowsValue;
}

-(void) checkSetUp: (NSInteger) section
{
    NSNumber *sectionNumId = [[NSNumber alloc] initWithInteger:section];
    NSString *sectionId = [sectionToIdentifier objectForKey:sectionNumId];
    //add section to hashtable if it isn't mapped yet
    //(if the identifier returns nil then there exists no identifier, I thought of consolidating to one dictionary
    // however the dictionary would only consist of bool where false is nil
    if (sectionId)
    {
        //toggle section
        //headerViewController.isCollapsed = [isCollapsed boolValue];
    } else {
        //initialize the map to be collapsed
        sectionId = [NSString stringWithFormat:@"section %i", section];
        [identifierToSection setObject:sectionNumId forKey:sectionId];
        [sectionToIdentifier setObject:sectionId forKey:sectionNumId];
        [sectionIsCollapsedMap setObject:[NSNumber numberWithBool:[realDataSource isInitiallyCollapsed:sectionNumId]]
                            forKey:sectionId];
    }
}

-(void) expandHeader: (int) sectionNum
{
    

    NSString *identifier = [NSString stringWithFormat:@"section %i", sectionNum];
    if (![[sectionIsCollapsedMap objectForKey:identifier] boolValue]) {
        [self collapseAllRows];
        [sectionIsCollapsedMap setObject:[NSNumber numberWithBool:YES] forKey:identifier];
        [self reloadSections:[NSIndexSet indexSetWithIndex:sectionNum] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self reloadData];
    }
}

-(void) collapseAllRows
{
    for (id key in[sectionIsCollapsedMap allKeys]) {
        if ([[sectionIsCollapsedMap objectForKey:key] boolValue]) {
            [sectionIsCollapsedMap setObject:[NSNumber numberWithBool:NO] forKey:key];
            [self reloadSections:
             [NSIndexSet indexSetWithIndex:[[identifierToSection objectForKey:key] integerValue]]
                withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
@end
