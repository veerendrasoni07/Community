plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")

    // 🚨 MUST BE LAST — DO NOT MOVE THIS
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.codingera2"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.example.codingera2"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
