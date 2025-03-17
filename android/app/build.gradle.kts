plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "avs.com.taskone"
    compileSdk = 34 //flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"
    

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true 
        
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "avs.com.taskone"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk =  23//flutter.minSdkVersion
        targetSdk =  33 //flutter.targetSdkVersion
        versionCode = 1 //flutter.versionCode
        versionName = "1.0"//flutter.versionName
        multiDexEnabled = true
    }

   buildTypes {
        getByName("release") {
            isMinifyEnabled = true // Habilita a compactação de código (Code Shrinking)
            isShrinkResources = true // Habilita a remoção de recursos não utilizados
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.8.0") // Declaração correta da dependência
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3") // Declaração correta da dependência
}


