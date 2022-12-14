# ZGR Messaging SDK (push service)


## Введение

Данный комплект для разработки программного обеспечения (далее - SDK) предназначен для отправки сообщений на мобильные устройства пользователей при помощи сервисов отправки push-уведомлений от Apple. Распространение SDK осуществляется в форме SaaS (программное обеспечение как услуга) от ZGR.IM.


Основные возможности библиотеки:
* приём и отображение push-сообщений, отправленных на мобильное устройство с помощью  Apple Push Notification Service, в том числе содержащих расширенный медиа-контент (изображения, видео и т.д.)
* сохранение принятых сообщений в локальной базе данных
* отслеживание доставки и открытия push-сообщений, с отправкой соответствующих запросов на сервер



Для внедрения SDK в мобильное приложение необходимо:
* настроить интеграцию приложения с Apple Push Notification Service (APNS),
* добавить в приложение файл конфигурации `ZGRConfig.json` и библиотеку, скомпилированную в виде динамического фреймворка `ZGRImSDK.xcframework`, 
* добавить вызов методов регистрации токена и телефона пользователя или его внешнего идентификатора (`externalUserId`).



## Системные требования

Минимальная версия поддерживаемой OS: iOS 11 
Для работы SDK требуется доступ к Интернету


## Установка библиотеки в приложение

В настоящий момент доступны четыре варианта установки:
* вручную (процесс подробно изложен в файле `manually_installation.md` в каталоге `installation`),
* в качестве `pod` с помощью менеджера пакетов CocoaPods (файл `pod_installation.md` в каталоге `installation`),
* с помощью менеджера пакетов Carthage (файл `carthage_installation.md` в каталоге `installation`),
* с помощью Swift Package Manager (файл `spm_installation.md` в каталоге `installation`).

Каталог `installation` расположен по адресу https://github.com/zgr-im/zgr-push-service-ios-sdk/tree/main/installation.


## Интеграция приложения с APNS

Необходимо включить возможность отправки пуш-нотификаций в настройках проекта, а также в настройках аккаунта разработчика. После этого на старте приложения регистрировать его в службе APNS и получать уникальный токен для устройства. Подробно процесс описан здесь: https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns?language=objc


## Новые возможности, доступные в релизе 1.6.1

Все примеры приведены с использованием Objective-C 


###  Метод для изменения статуса уведомлений ZGRNotification

Использование

```

[[ZGRMessaging sharedInstance] updateNotification:notif status:@"Seen" withCompletionHandler:^{
    // Perform any code
}];

```

Сигнатура метода:

```

/**
 @brief Update notification's status in local database.
 @param notification Notification to update.
 @param status Status to update. Must be "New" or "Seen".
 @param completionHandler Completion handler.
 */
 
- (void)updateNotification:(ZGRNotification *)notification status:(NSString *)status 
        withCompletionHandler:(void(^)(BOOL success, ZGRError * _Nullable error))completionHandler;

```


### Метод для изменения счётчика пушей в бейдже приложения

Использование (допустим в appDelegate.m):

```

[[ZGRMessaging sharedInstance] application:app setApplicationBadgeNumber:number];

```

Сигнатура метода:

```

/**
 @brief Set application badge number
 @param application Current application.
 @param number number that setted.
*/
- (void)application:(UIApplication *)application setApplicationBadgeNumber:(NSInteger)number;

```


### Рассылка системной нотификации в момент открытия пуша

В необходимом файле (допустим в appDelegate.m) подписываемся на событие ZGRDidOpenRemoteNotificationKey:

```

[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleDidOpenPushNotification:) 
        name:ZGRDidOpenRemoteNotificationKey object:nil];

```

И прописываем метод-обработчик события:

```

- (void)handleDidOpenPushNotification:(NSNotification*)paramNotification {
    ZGRNotification *notification = (ZGRNotification *)paramNotification.userInfo[@"notification"];
    NSLog(@" handleDidOpenPushNotification called. id = %@, status = %@, customPayload = %@", 
            notification.identifier, notification.status, notification.customPayload);
}

```



## Быстрый гайд


* В приложеном тестовом проекте вы найдете примеры использования всех возможностей SDK. Ниже приведены только основные сценарии работы с SDK.

### Подключить библиотеку ZGR к `AppDelegate`

Objective-C:

```

#import <ZGRImSDK/ZGRImSDK.h>

```
   
Swift:

```

import ZGRImSDK

```


### Отправить запрос на получение от системы пуш-токена и передать полученный токен в ZGR

Objective-C:

```

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application registerForRemoteNotifications];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[ZGRMessaging sharedInstance] registerForRemoteNotifications:deviceToken];
}

```
 
Swift:

```

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    application.registerForRemoteNotifications()
    return true
}

func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    ZGRMessaging.sharedInstance().register(forRemoteNotifications: deviceToken)
}

```


### Отправить внешний идентификатор пользователя и/или номер телефона пользователя в ZGR

Objective-C:

```

[[ZGRMessaging sharedInstance] sendUserPhoneNumber:@"79876543210" externalUserId:"id1" withCompletionHandler:^{
    // Perform any code
}];

```
 
Swift:

```

ZGRMessaging.sharedInstance().sendUserPhoneNumber("79876543210", externalUserId: "id1") {
    // Perform any code
}

```


### Реализовать протокол делегата UNUserNotificationCenterDelegate 

Objective-C:

```

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end 

...

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options
                                                                        completionHandler:^(BOOL granted, NSError * _Nullable error) {
        [application registerForRemoteNotifications];
        
    }];
    return YES;
}

```
    
Swift:

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    application.registerForRemoteNotifications()
    
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        
    }
    return true
}

```


### Перенаправить пуш-уведомление в ZGR

Objective-C:

```

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [[ZGRMessaging sharedInstance] userNotificationCenter:center
                           didReceiveNotificationResponse:response
                                    withCompletionHandler:^(ZGRNotification * _Nonnull notification,
                                                             ZGRAction * _Nonnull selectedAction) {
    // Handle notification from ZGR
}

    // My own code
    
    completionHandler();
}

```

Swift:

```

func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    ZGRMessaging.sharedInstance().userNotificationCenter(center, didReceive: response) { (notification, action) in
        // Handle notification from ZGR
    }
    
    // My own code
    
    completionHandler()
}

```


### Обработка нажатия на контент уведомления. либо на кнопки под контентом. Для определения нажатой кнопки необходимо сопоставить ее идентификатор с отправленным в ZGR.

Objective-C:

```

[[ZGRMessaging sharedInstance] userNotificationCenter:center
                       didReceiveNotificationResponse:response
                                withCompletionHandler:^(ZGRNotification * _Nonnull notification,
                                                         ZGRAction * _Nonnull selectedAction) {
    // Handle notification from ZGR

    // User clicked notification content
    if (selectedAction.type == ZGRActionTypeDefault) {
        // Perform any code
    }
    
    // User clicked custom button under notification content
    if (selectedAction.type == ZGRActionTypeOther) {
        NSString *customActionId = selectedAction.identifier;
        // Perform any code
    }
}

```

Swift:

```

ZGRMessaging.sharedInstance().userNotificationCenter(center, didReceive: response) { (notification, action) in
    
    // Handle notification from ZGR

    // User clicked notification content
    if action.type == ZGRActionTypeDefault {
        // Perform any code
    }
    
    // User clicked custom button under notification content
    if action.type == ZGRActionTypeOther {
        let customActionId = action.identifier;
        // Perform any code
    }
}

```


### Получение уведомлений о полученном SDK push сообщении
Для получения уведомлений о полученном  push сообщении необходимо добавить observer в NSNotificationCenter и подписаться на получение сообщений с ключом 
`ZGRDidReceiveRemoteNotificationKey`:

Objective-C:

```

[NSNotificationCenter.defaultCenter addObserver:self 
                                       selector:@selector(some_function:) 
                                           name:ZGRDidReceiveRemoteNotificationKey 
                                         object:nil];

```

Swift:

```

extension Notification.Name {
    static let didReceiveRemoteNotificationName = Notification.Name("ZGRDidReceiveRemoteNotificationKey")
}


NotificationCenter.default.addObserver(self, selector: #selector(some_function), name: .didReceiveRemoteNotificationName, object: nil)


@objc func some_function(notification: Notification) {
}

```


В качестве параметра в функцию-обработчик будет передаваться ссылка на системную нотификацию, в свойстве userInfo которой будет сохранен пришедший с сервера пуш:

```

NSConcreteNotification 0x281ee5aa0 {
    name = ZGRDidReceiveRemoteNotificationKey; 
    object = <ZGRMessaging: 0x28056dec0>; 
    userInfo = {
        aps = {
            alert = {
                body = "some string";
                title = another string;
            };
            category = zgr;
            "content-available" = 1;
            "mutable-content" = 1;
            sound = default;
        };
    "some other properties" = "value";
}}

```

### Профиль пользователя

#### Получение профиля

Objective-C:

```

[[ZGRMessaging sharedInstance] fetchUserWithCompletionHandler:^(ZGRUser * _Nullable user, ZGRError * _Nullable error) {    
    if (user.externalUserId.lenght > 0) {
        NSLog("External user id: %@" user.externalUserId];
    }
    if (user.phoneNumber.lenght > 0) {
        NSLog("Phone number: %@" user.phoneNumber];
    }
}];

```
Swift:

```

ZGRMessaging.sharedInstance().fetchUser() { user, error in
    
    if let userId = user?.externalUserId, userId.count > 0 {
        print("External user id: \(userId)")
    }
    
    if let phone = user?.phoneNumber, phone.count > 0 {
        print("Phone number: \(phone)")
    }
}

```

#### Обновление номера телефона в профиле

Objective-C:

```

[[ZGRMessaging sharedInstance] saveUserPhoneNumber:@"79876543210" withCompletionHandler:^(ZGRUser * _Nullable user, ZGRError * _Nullable error) {
    if (user.externalUserId.lenght > 0) {
        NSLog("External user id: %@" user.externalUserId];
    }
    if (user.phoneNumber.lenght > 0) {
        NSLog("Phone number: %@" user.phoneNumber];
    }
    
    // Perform any code
}];

```

Swift:

```

ZGRMessaging.sharedInstance().saveUserPhoneNumber("79876543210") { user, error in
    
    if let userId = user?.externalUserId, userId.count > 0 {
        print("External user id: \(userId)")
    }
    
    if let phone = user?.phoneNumber, phone.count > 0 {
        print("Phone number: \(phone)")
    }
    
    // Perform any code
}

```


### Персонализация

#### Персонализация (привязка externalUserId)

Objective-C:

```

[[ZGRMessaging sharedInstance] personalizeWithExternalUserId:@"id1" completionHandler:^{
    if (user.externalUserId.lenght > 0) {
        NSLog("External user id: %@" user.externalUserId];
    }
    if (user.phoneNumber.lenght > 0) {
        NSLog("Phone number: %@" user.phoneNumber];
    }

    // Perform any code
}];

```

Swift:

```

ZGRMessaging.sharedInstance().personalize(withExternalUserId: "id1") { user, error in
    
    if let userId = user?.externalUserId, userId.count > 0 {
        print("External user id: \(userId)")
    }
    
    if let phone = user?.phoneNumber, phone.count > 0 {
        print("Phone number: \(phone)")
    }
    
    // Perform any code
}

```

#### Деперсонализация (выход).

Objective-C:

```

[[ZGRMessaging sharedInstance] depersonalizeWithCompletionHandler:nil];

```

Swift:

```

ZGRMessaging.sharedInstance().depersonalize()

```


### Настройки подписок

#### Получение настроек с подписками.

Objective-C:

```

[[ZGRMessaging sharedInstance] fetchInstallationWithCompletionHandler:^(ZGRInstallation * _Nullable installation, ZGRError * _Nullable error) {
    // Perform any code
    NSLog(@"%@", installation.subscriptions);
}];

```

Swift:

```

ZGRMessaging.sharedInstance().fetchInstallation() { installation, error in
    // Perform any code
    if let subscriptions = installation?.subscriptions {
        print("subscriptions: \(subscriptions)")
    }
}

```

#### Изменение настроек и параметров подписок (вы можете изменять необходимые вам свойство в классах `ZGRInstallation` и `ZGRSubscription`, там же вы найдете подробное описание атрибутов).

Objective-C:

```

ZGRInstallation *installation = self.installation;
installation.isPrimary = NO;

NSArray<ZGRSubscription *> *subscriptions = installation.subscriptions;
// Perform any code on subscriptions

[[ZGRMessaging sharedInstance] saveInstallation:installation withCompletionHandler:^{
    
}];

```

### Локальная история уведомления

#### Включение хранения локальной истории уведомлений.

Objective-C:

```

[ZGRMessaging sharedInstance].localDatabaseEnabled = YES;

```

Swift:

```

ZGRMessaging.sharedInstance().isLocalDatabaseEnabled = true

```

#### Получение всех сохраненных уведомлений из базы данных.

Objective-C:

```

[[ZGRMessaging sharedInstance] fetchAllNotificationsWithCompletionHandler:^(NSArray<ZGRNotification *> * _Nullable notifications,
                                                                            ZGRError * _Nullable error) {
    // Perform any code
}];

```

Swift:

```

ZGRMessaging.sharedInstance().fetchAllNotifications() { notification, error in
    // Perform any code
}

```

#### Получение части уведомлений из базы данных.

Objective-C:

```

ZGRDatabaseRequest *request = [ZGRDatabaseRequest new];
request.fetchLimit = 5;
request.pageOffset = 1;
request.fromDate = [NSDate dateWithTimeIntervalSinceReferenceDate:*];

[[ZGRMessaging sharedInstance] fetchNotificationsWithRequest:request completionHandler:^(NSArray<ZGRNotification *> * _Nullable notifications,
                                                                                         ZGRError * _Nullable error) {
    // Perform any code
}];

```

Swift:

```

let request = ZGRDatabaseRequest()
request.fetchLimit = 5
request.pageOffset = 1
request.fromDate = Date(timeIntervalSinceReferenceDate: 10000)

ZGRMessaging.sharedInstance().fetchNotifications(with: request) { notification, error in
    // Perform any code
}

```

#### Удаление уведомления из базы данных.

Objective-C:

```

[[ZGRMessaging sharedInstance] deleteNotification:notification withCompletionHandler:^(BOOL success, ZGRError * _Nullable error) {
    if (!success) {
        return;
    }

    // Perform any code
}];

```

Swift:

```

ZGRMessaging.sharedInstance().delete(notification) { success, error in
    if !success { return }
    // Perform any code
}

```

#### Удаление массива уведомлений из базы данных.

Objective-C:

```

[[ZGRMessaging sharedInstance] deleteNotificationsArray:(NSArray<ZGRNotification *> *)array withCompletionHandler:^(BOOL success, ZGRError * _Nullable error) {
    if (!success) {
        return;
    }

    // Perform any code
}];

```


## Настройка расширений приложения

### Notification Service Extension
* Обязательно для корректной работы SDK.

1. В сгенерированном при создании `extension` файле `NotificationService.h` импортировать `<ZGRImSDK/ZGRNotificationService.h>`.
2. Сделать класс `NotificationService` наследником `ZGRNotificationService`. В вашем классе вы можете определить свое поведение, которое будет выполнено, если пуш-уведомление получено не от ZGR
    
    
Objective-C:

```

#import <ZGRImSDKExtension/ZGRNotificationService.h>

@interface NotificationService : ZGRNotificationService

@end

```


Swift:

```

import UserNotifications
import ZGRImSDK

class NotificationService: ZGRNotificationService {
}



```


### Notification Content Extension

* Опционально. Не влияет на корректную работу SDK.

Сервис, занимающийся отображением расширенного медиаконтента в пуш-уведомлении.


1. В сгенерированном при создании `extension` файле  `NotificationViewController.m` (файл реализации класса) импортировать `<ZGRImSDK/ZGRNotificationService.h>`
2. Передать из метода `- viewDidLoad` стандартную `view` в `[ZGRNotificationContent sharedInstance]` (пример кода ниже)
3. Передать из метода `- didReceiveNotification:` полученное уведомление в `[ZGRNotificationContent sharedInstance]` (пример кода ниже)
4. В `Info.plist` файле расширения `Notification Content Extension` заменить значение поля `NSExtension/NSExtensionAttributes/UNNotificationExtensionCategory` на `zgr`
5. В этом же файле заменить значение поля `NSExtension/NSExtensionAttributes/UNNotificationExtensionInitialContentSizeRatio`  на `0`.
 
    
Objective-C:

```

#import <ZGRImSDKExtension/ZGRNotificationContent.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ZGRNotificationContent sharedInstance] didLoadView:self.view];
}

- (void)didReceiveNotification:(UNNotification *)notification {
    [[ZGRNotificationContent sharedInstance] didReceiveNotification:notification];
}

@end


```

Swift:


```

import UIKit
import UserNotifications
import UserNotificationsUI
import ZGRImSDK

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ZGRNotificationContent.sharedInstance().didLoad(view)
    }
    
    func didReceive(_ notification: UNNotification) {
        ZGRNotificationContent.sharedInstance().didReceive(notification)
    }

}

```



## Инструкция по запуску на устройстве

* Необходимо выбрать `идентификатор приложения`, который вы будете использовать для запуска на устройстве. Настроенный в текущий момент `im.zgr.app` использовать не получится, так как он привязан к учетной записи разработчика SDK.
* `(!)` В качестве примера в инструкции будет использован условный идентификатор - `my.test.app`.

Изменение идентификаторов приложения и его расширений:
1) В настройках таргета `push-sdk-test-app` изменить значение поля `Bundle identifier` на `my.test.app`.
2) В настройках таргета `notification-service-extension` изменить значение поля `Bundle identifier` на `my.test.app.notification-service` (либо иной идентификатор, начинающийся с `my.test.app`).
3) В настройках таргета `notification-content-extension` изменить значение поля `Bundle identifier` на `my.test.app.notification-content` (либо иной идентификатор, начинающийся с `my.test.app`)..

Изменение идентификатора общей группы приложения и его расширений:
1) В настройках таргета `push-sdk-test-app` в разделе `AppGroups` удалить (снять галку)  `group.im.zgr.app`, после этого добавить `group.my.test.app`.
2) В настройках таргетов `notification-service-extension` и `notification-content-extension`  в разделе `AppGroups` удалить (снять галку)  `group.im.zgr.app`, после этого добавить `group.my.test.app`.



## Ограничения

Невозможность работы с симуляторами. Необходимо наличие реального мобильного устройства.
