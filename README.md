# InnovaBudget

# Mobil Finansal Uygulama

Bu proje, finansal alanda kullanılabilecek bir mobil uygulamayı geliştirmek için tasarlanmıştır.  
Bütce Takibi sistemi oluşturulmuştur.
Genel olarak MVVM mimarisi Firebase ile birlikte kullanılmıştır.

## Servisler

Proje isterlerinde bulunan 3 farklı servis mantığı karşılanmamıştır.
Firebase ile sadece Auth işlemleri değil, veri kaydetme, veri silme işlemleri kullanılmıştır. 

Hackatlon günü Tabbar da yaşadığım buglardan dolayı Döviz Api bağlayamadım. 
Hali hazırda ve github profilimde bulunan Eureka projesinde kullandığım:
"Async/Await URLSessions Generic Layer" katmanını Budget Managment projeme dahil edemedim.

## Genel Yapı

Proje içerisinde, türkçe karakter kullanmamaya, class ve değişkenlerinlerin Acces Level düzeylerine oldukça dikkat ettim.
MVVM kullanırken, ViewModel içerisinden Protokol ve Delegate yapısı ile ViewController a geçiş yaptım.
Kullanıcıdan aldığım Maaş bilgisini UserDefault üzerinde tuttum. Onun harici bütün gelir-gider ve tarih işlemleri Firebase üzerinde tutuluyor.
Auto Layout konusunda StackView yapısı kullanmaya özen gösterdim. iPhone 14 Pro ve iPhone SE  modellerinde AutoLayout ile ilgili herhangi bir problem yaşamadım.
Uygulama içerisinde tek bir Storyboard dosyası üzerinde çalışılmamıştır. Her ekran ayrı bir Storyboard olacak şekilde tasarlanmış ve gerekli yerlerde XIB yapısı kullanılmıştır.

### Protokol ve Delegate Yapısı ViewModel
```swift
protocol LoginViewModelDelegate: AnyObject {
    func loginSucceeded()
    func loginFailed(with error: String)
}

final class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    
    func login(user: User) {
        Auth.auth().signIn(withEmail: user.email, password: user.password) { [weak self] authResult, error in
            if let error = error {
                let authError = error as NSError
                switch authError.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    self?.delegate?.loginFailed(with: "Yanlış parola")
                case AuthErrorCode.invalidEmail.rawValue:
                    self?.delegate?.loginFailed(with: "Geçersiz e-posta")
                case AuthErrorCode.userNotFound.rawValue:
                    self?.delegate?.loginFailed(with: "Bu kullanıcı bulunamadı")
                default:
                    self?.delegate?.loginFailed(with: "Bilinmeyen hata: \(authError.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self?.delegate?.loginSucceeded()
                }
            }
        }
    }
}
```
### Access Level Örneği
```swift
final class LoginViewController: UIViewController, LoginViewModelDelegate {
    //MARK: IBOutlets
    private lazy var viewModel = LoginViewModel()
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
```

### Uygulama içerisinde "unwrapping" yapmamaya özen gösterim. Genel olarak Guard Let yapısını kullandım.
```swift
    @IBAction private func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        let user = User(email: email, password: password)
        viewModel.signUp(user: user)
    }
```
## Ekranlar

Login Ekranı, Sign Ekranı, Home Ekranı, Pop-up olarak eklenen maaş ekranı, Gelir-Gider ekranı ve son olarak Ayarlar ekranı bulunmaktadır.

## Görseller

# iPhone 14 Pro
![Simulator Screenshot - iPhone 14 Pro - 2023-07-14 at 18 24 51_184x400](https://github.com/talhavarol-dev/InnovaBudget/assets/80515499/f8434b5e-4608-42af-ba2d-cd9a9897300e)
![Simulator Screenshot - iPhone 14 Pro - 2023-07-14 at 18 25 30_184x400](https://github.com/talhavarol-dev/InnovaBudget/assets/80515499/37a58fb0-059f-49e4-95ed-e0400307bedc)


# iPhone SE
![Simulator Screenshot - iPhone SE (3rd generation) - 2023-07-14 at 10 47 07_224x400](https://github.com/talhavarol-dev/InnovaBudget/assets/80515499/2a44cfca-ba76-475f-a198-6e6e28cbf792)
![Simulator Screenshot - iPhone SE (3rd generation) - 2023-07-14 at 10 47 23_224x400](https://github.com/talhavarol-dev/InnovaBudget/assets/80515499/e0d62ef7-5a15-4edc-ac53-1482cdae4fb2)
