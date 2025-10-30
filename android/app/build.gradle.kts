plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // gunakan format resmi
    // Flutter plugin harus di bawah Android dan Kotlin plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.tugas_akhir_valorant"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // aktifkan desugaring agar bisa pakai fitur modern Java
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.tugas_akhir_valorant"
        // Set to 23 to support flutter_secure_storage v9+ and notifications
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

        buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false // tambahkan baris ini untuk mematikan resource shrink
        }
        debug {
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // library penting agar fitur modern Java bisa jalan
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // dukungan multidex
    implementation("androidx.multidex:multidex:2.0.1")

    // dukungan AndroidX core (opsional tapi disarankan)
    implementation("androidx.core:core-ktx:1.12.0")
}
