//
//  NewBallCollapsebleTableView.h
//  
//
//  Created by Ian Fox on 8/19/14.
//
//

#import <UIKit/UIKit.h>
@protocol CollapsebleDataSource
@optional
-(BOOL) isInitiallyCollapsed:(NSNumber *) section;
@end
@interface CollapsebleTableView : UITableView<UITableViewDelegate, UITableViewDataSource>
@property id<UITableViewDataSource,CollapsebleDataSource> realDataSource;
@property id<UITableViewDelegate> realDelegate;
@property NSMutableDictionary *sectionIsCollapsedMap;
@property NSMutableDictionary *sectionToIdentifier;
@property NSMutableDictionary *identifierToSection;

-(void) expandHeader: (int) sectionNum;


@end
