// Generated by Apple Swift version 3.0.1 (swiftlang-800.0.58.6 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import Foundation;
@import CoreGraphics;
@import JSQMessagesViewController;
@import ObjectiveC;
@import MessageUI;
@import CoreLocation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;

SWIFT_CLASS("_TtC12Trial_Finder11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions;
- (BOOL)application:(UIApplication * _Nonnull)application openURL:(NSURL * _Nonnull)url sourceApplication:(NSString * _Nullable)sourceApplication annotation:(id _Nonnull)annotation;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIColor;
@class NSCoder;

SWIFT_CLASS("_TtC12Trial_Finder19BottomLineTextField")
@interface BottomLineTextField : UITextField
@property (nonatomic, strong) UIColor * _Nonnull borderColor;
@property (nonatomic) CGFloat boderWidth;
@property (nonatomic, strong) UIColor * _Nullable placeholderColor;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)setup;
- (void)drawRect:(CGRect)rect;
@end

@class JSQMessage;
@class FIRDatabaseReference;
@class JSQMessagesBubbleImage;
@class JSQMessagesCollectionView;
@protocol JSQMessageData;
@class UICollectionView;
@protocol JSQMessageBubbleImageDataSource;
@protocol JSQMessageAvatarImageDataSource;
@class UICollectionViewCell;
@class NSAttributedString;
@class JSQMessagesCollectionViewFlowLayout;
@class UIButton;
@class NSBundle;

SWIFT_CLASS("_TtC12Trial_Finder6ChatVC")
@interface ChatVC : JSQMessagesViewController
@property (nonatomic, copy) NSArray<JSQMessage *> * _Nonnull messages;
@property (nonatomic, strong) FIRDatabaseReference * _Nullable siteListRef;
@property (nonatomic, strong) JSQMessagesBubbleImage * _Nonnull outgoingBubbleImageView;
@property (nonatomic, strong) JSQMessagesBubbleImage * _Nonnull incomingBubbleImageView;
@property (nonatomic, copy) NSString * _Nullable siteName;
- (void)viewDidLoad;
- (void)viewDidLayoutSubviews;
- (void)viewDidAppear:(BOOL)animated;
- (id <JSQMessageData> _Null_unspecified)collectionView:(JSQMessagesCollectionView * _Null_unspecified)collectionView messageDataForItemAtIndexPath:(NSIndexPath * _Null_unspecified)indexPath;
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section;
- (id <JSQMessageBubbleImageDataSource> _Null_unspecified)collectionView:(JSQMessagesCollectionView * _Null_unspecified)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath * _Null_unspecified)indexPath;
- (id <JSQMessageAvatarImageDataSource> _Null_unspecified)collectionView:(JSQMessagesCollectionView * _Null_unspecified)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath * _Null_unspecified)indexPath;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSAttributedString * _Nullable)collectionView:(JSQMessagesCollectionView * _Nonnull)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (CGFloat)collectionView:(JSQMessagesCollectionView * _Nonnull)collectionView layout:(JSQMessagesCollectionViewFlowLayout * _Nonnull)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)didPressSendButton:(UIButton * _Null_unspecified)button withMessageText:(NSString * _Null_unspecified)text senderId:(NSString * _Null_unspecified)senderId senderDisplayName:(NSString * _Null_unspecified)senderDisplayName date:(NSDate * _Null_unspecified)date;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UISlider;

SWIFT_CLASS("_TtC12Trial_Finder21DistanceTableViewCell")
@interface DistanceTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UISlider * _Null_unspecified distanceSlider;
- (IBAction)valueChanged:(UISlider * _Nonnull)sender;
- (IBAction)didEndEditting:(UISlider * _Nonnull)sender;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UILabel;
@class UITouch;
@class UIEvent;

SWIFT_CLASS("_TtC12Trial_Finder16ForgotPasswordVC")
@interface ForgotPasswordVC : UIViewController
@property (nonatomic, copy) NSString * _Null_unspecified errorMessage;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified errorLabel;
@property (nonatomic, weak) IBOutlet BottomLineTextField * _Null_unspecified emailTextField;
- (IBAction)back:(id _Nonnull)sender;
- (IBAction)resetPassword:(id _Nonnull)sender;
- (void)viewDidLoad;
- (void)touchesBegan:(NSSet<UITouch *> * _Nonnull)touches withEvent:(UIEvent * _Nullable)event;
- (void)changeColorFor:(BottomLineTextField * _Nonnull)textField withColor:(UIColor * _Nonnull)color;
- (void)resetWithEmail:(NSString * _Nonnull)email;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface ForgotPasswordVC (SWIFT_EXTENSION(Trial_Finder)) <UITextFieldDelegate>
- (BOOL)textFieldShouldClear:(UITextField * _Nonnull)textField;
- (BOOL)textFieldShouldBeginEditing:(UITextField * _Nonnull)textField;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField;
@end


SWIFT_CLASS("_TtC12Trial_Finder6MenuVC")
@interface MenuVC : UIViewController
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified accountLabel;
- (IBAction)showMainFeed:(id _Nonnull)sender;
- (IBAction)logout:(id _Nonnull)sender;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC12Trial_Finder11MessageCell")
@interface MessageCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified incomingMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified incomingNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified outgoingNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified incomingTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified outgoingMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified outgoingTimeLabel;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC12Trial_Finder6NameVC")
@interface NameVC : UIViewController
@property (nonatomic, weak) IBOutlet BottomLineTextField * _Null_unspecified firstNameTextField;
- (IBAction)submitButton:(id _Nonnull)sender;
- (IBAction)back:(id _Nonnull)sender;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified errorLabel;
@property (nonatomic, weak) IBOutlet BottomLineTextField * _Null_unspecified lastNameTextField;
@property (nonatomic, copy) NSString * _Nullable name;
- (void)viewDidLoad;
- (NSDictionary<NSString *, id> * _Nonnull)getData;
- (void)updateInfo;
- (void)changeColorFor:(BottomLineTextField * _Nonnull)textField withColor:(UIColor * _Nonnull)color;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface NameVC (SWIFT_EXTENSION(Trial_Finder)) <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField * _Nonnull)textField;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField;
@end

@class NSUserDefaults;
@class UITableView;

SWIFT_CLASS("_TtC12Trial_Finder20PickerViewController")
@interface PickerViewController : UIViewController
@property (nonatomic, readonly, strong) NSUserDefaults * _Nonnull userDefaults;
@property (nonatomic, copy) NSString * _Nullable siteName;
@property (nonatomic, copy) NSString * _Nullable studyType;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
- (IBAction)apply:(id _Nonnull)sender;
- (IBAction)dismiss:(id _Nonnull)sender;
- (void)viewDidLoad;
- (void)saveValue:(id _Nullable)value forKey:(NSString * _Nonnull)key;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface PickerViewController (SWIFT_EXTENSION(Trial_Finder))
- (void)didSliderChangeValueWithValue:(float)value;
@end

@class UIView;

@interface PickerViewController (SWIFT_EXTENSION(Trial_Finder)) <UITableViewDelegate, UIScrollViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView * _Nullable)tableView:(UITableView * _Nonnull)tableView viewForHeaderInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end


SWIFT_CLASS("_TtC12Trial_Finder13RoundedButton")
@interface RoundedButton : UIButton
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor * _Nullable highlightedBgColor;
@property (nonatomic, strong) UIColor * _Nullable selectedBgColor;
@property (nonatomic, strong) UIColor * _Nonnull borderColor;
@property (nonatomic) CGFloat borderWidth;
- (void)drawRect:(CGRect)rect;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIImageView;

SWIFT_CLASS("_TtC12Trial_Finder22SelectionTableViewCell")
@interface SelectionTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified checkImageview;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC12Trial_Finder15SentMessageCell")
@interface SentMessageCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified sentMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified sentMessageTimeLabel;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIScrollView;
@class NSLayoutConstraint;

SWIFT_CLASS("_TtC12Trial_Finder10SettingsVC")
@interface SettingsVC : UIViewController
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified lastNameTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified sexTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified birthdateTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified ageTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified heightFeetTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified heightInchesTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified weightTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified currentPasswordTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified newPasswordTextField;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified updateInfoMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified changePasswordMessageLabel;
@property (nonatomic, weak) IBOutlet UIScrollView * _Null_unspecified scrollView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * _Null_unspecified scrollViewBottomConstraint;
- (IBAction)showMenu:(id _Nonnull)sender;
- (IBAction)update:(id _Nonnull)sender;
- (IBAction)dismissKeyboard:(id _Nonnull)sender;
- (void)viewDidLoad;
- (void)viewWillDisappear:(BOOL)animated;
- (NSDictionary<NSString *, id> * _Nonnull)getData;
- (void)touchesBegan:(NSSet<UITouch *> * _Nonnull)touches withEvent:(UIEvent * _Nullable)event;
- (void)updateInfo;
- (void)changePassword;
- (NSString * _Nonnull)getDateStringWithDate:(NSDate * _Nonnull)date;
- (NSDate * _Nullable)getDateFromString:(NSString * _Nonnull)string;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface SettingsVC (SWIFT_EXTENSION(Trial_Finder))
- (void)subscribeToNotificationWithNotification:(NSNotificationName _Nonnull)notification selector:(SEL _Nonnull)selector;
- (void)unsubscribeFromAllNotifications;
@end


@interface SettingsVC (SWIFT_EXTENSION(Trial_Finder)) <UITextFieldDelegate>
- (void)doneClick;
- (BOOL)textFieldShouldBeginEditing:(UITextField * _Nonnull)textField;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField;
- (void)keyboardWillHideWithNotification:(NSNotification * _Nonnull)notification;
- (void)keyboardWillChangeFrameWithNotification:(NSNotification * _Nonnull)notification;
@end

@class UIActivityIndicatorView;
@class FIRAuthCredential;

SWIFT_CLASS("_TtC12Trial_Finder8SignInVC")
@interface SignInVC : UIViewController
@property (nonatomic, weak) IBOutlet BottomLineTextField * _Null_unspecified loginEmailField;
@property (nonatomic, weak) IBOutlet BottomLineTextField * _Null_unspecified loginPasswordField;
@property (nonatomic, strong) UIActivityIndicatorView * _Nonnull activityIndicator;
@property (nonatomic, copy) NSString * _Nullable userEmail;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified errorLabel;
- (IBAction)facebookSignInButton:(id _Nonnull)sender;
- (void)viewDidAppear:(BOOL)animated;
- (void)firebaseAuth:(FIRAuthCredential * _Nonnull)credential;
- (IBAction)signInButton:(id _Nonnull)sender;
- (void)changeColorFor:(BottomLineTextField * _Nonnull)textField withColor:(UIColor * _Nonnull)color;
- (void)signin;
- (void)signinWithEmail:(NSString * _Nonnull)email password:(NSString * _Nonnull)password completion:(void (^ _Nonnull)(NSError * _Nullable))completion;
- (void)completeSignInId:(NSString * _Nonnull)id userData:(NSDictionary<NSString *, NSString *> * _Nonnull)userData;
- (void)touchesBegan:(NSSet<UITouch *> * _Nonnull)touches withEvent:(UIEvent * _Nullable)event;
- (void)afterSignInSuccess;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface SignInVC (SWIFT_EXTENSION(Trial_Finder)) <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField * _Nonnull)textField;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField;
@end


SWIFT_CLASS("_TtC12Trial_Finder12SiteListCell")
@interface SiteListCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified siteName;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIStoryboardSegue;

SWIFT_CLASS("_TtC12Trial_Finder10SiteListVC")
@interface SiteListVC : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString * _Nullable senderDisplayName;
@property (nonatomic, readonly, copy) NSString * _Nonnull reuseIdentifier;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified siteListTableView;
- (IBAction)showMenu:(id _Nonnull)sender;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)observeSiteName;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC12Trial_Finder9TrialCell")
@interface TrialCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified conditionIcon;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified siteName;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified siteAddress;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified studyName;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified distanceLabel;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIColor (SWIFT_EXTENSION(Trial_Finder))
+ (UIColor * _Nonnull)outgoingMessageBubbleColor;
@end


@interface UIImage (SWIFT_EXTENSION(Trial_Finder))
+ (UIImage * _Nonnull)imageWithColorWithColor:(UIColor * _Nonnull)color;
@end


@interface UIViewController (SWIFT_EXTENSION(Trial_Finder))
- (void)hideKeyboardOnScreenTap;
- (void)dismissKeyboard;
/**
  extract all the textfield from view *
*/
- (NSArray<UITextField *> * _Nonnull)getTextfieldWithView:(UIView * _Nonnull)view;
/**
  Showing alert with message *
*/
- (void)alertWithMessage:(NSString * _Nonnull)message title:(NSString * _Nonnull)title;
/**
  Toggle activity indicator *
*/
- (void)showActivityIndicatorWithIsShow:(BOOL)isShow activityIndicatorView:(UIActivityIndicatorView * _Nonnull)activityIndicatorView;
@end


SWIFT_CLASS("_TtC12Trial_Finder9detailsVC")
@interface detailsVC : UIViewController
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified imageView;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified detaisLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified emailLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified addressLabel;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified callButton;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified emailButton;
- (IBAction)back:(id _Nonnull)sender;
- (IBAction)call:(id _Nonnull)sender;
- (IBAction)email:(id _Nonnull)sender;
- (IBAction)chat:(id _Nonnull)sender;
- (IBAction)showDirection:(id _Nonnull)sender;
- (void)viewDidLoad;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class MFMailComposeViewController;

@interface detailsVC (SWIFT_EXTENSION(Trial_Finder)) <MFMailComposeViewControllerDelegate>
- (void)mailComposeController:(MFMailComposeViewController * _Nonnull)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError * _Nullable)error;
@end

@class CLLocationManager;
@class NSString;
@class UISearchBar;

SWIFT_CLASS("_TtC12Trial_Finder10mainFeedVC")
@interface mainFeedVC : UIViewController
@property (nonatomic, readonly, strong) NSUserDefaults * _Nonnull userDefaults;
@property (nonatomic, strong) CLLocationManager * _Null_unspecified locationManager;
@property (nonatomic, strong) UIActivityIndicatorView * _Nonnull activityIndicator;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) NSCache<NSString *, UIImage *> * _Nonnull imageCache;)
+ (NSCache<NSString *, UIImage *> * _Nonnull)imageCache;
+ (void)setImageCache:(NSCache<NSString *, UIImage *> * _Nonnull)value;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
@property (nonatomic, weak) IBOutlet UISearchBar * _Null_unspecified searchBar;
- (IBAction)showMenu:(id _Nonnull)sender;
- (IBAction)filter:(id _Nonnull)sender;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (void)reloadData;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class CLLocation;

@interface mainFeedVC (SWIFT_EXTENSION(Trial_Finder)) <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
@end


@interface mainFeedVC (SWIFT_EXTENSION(Trial_Finder)) <UITableViewDelegate, UIScrollViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end


@interface mainFeedVC (SWIFT_EXTENSION(Trial_Finder)) <UISearchBarDelegate, UIBarPositioningDelegate>
- (void)searchBar:(UISearchBar * _Nonnull)searchBar textDidChange:(NSString * _Nonnull)searchText;
- (void)searchBarTextDidBeginEditing:(UISearchBar * _Nonnull)searchBar;
- (void)searchBarTextDidEndEditing:(UISearchBar * _Nonnull)searchBar;
- (void)searchBarCancelButtonClicked:(UISearchBar * _Nonnull)searchBar;
@end

@class UIWebView;

SWIFT_CLASS("_TtC12Trial_Finder6mapsVC")
@interface mapsVC : UIViewController
@property (nonatomic, strong) CLLocation * _Null_unspecified location;
@property (nonatomic, weak) IBOutlet UIWebView * _Null_unspecified webView;
- (IBAction)back:(id _Nonnull)sender;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
