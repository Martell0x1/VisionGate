plugins {
    id("com.android.application") version "8.5.0" apply true
    kotlin("android") version "2.0.0" // match your Kotlin version
}

android {
    namespace = "org.example.detectapp"
    compileSdk = 34

    defaultConfig {
        applicationId = "org.example.detectapp"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }
    kotlinOptions {
        jvmTarget = "21"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("org.nanohttpd:nanohttpd:2.3.1")


    val camerax_version = "1.3.1"

    implementation("androidx.camera:camera-core:$camerax_version")
    implementation("androidx.camera:camera-camera2:$camerax_version")
    implementation("androidx.camera:camera-lifecycle:$camerax_version")
    implementation("androidx.camera:camera-view:$camerax_version") // optional, for PreviewView
    implementation("androidx.camera:camera-extensions:$camerax_version") // optional
    // OkHttp
    implementation("com.squareup.okhttp3:okhttp:4.12.0")

    // Needed for asRequestBody and toMediaTypeOrNull extensions
    // implementation("com.squareup.okhttp3:okhttp-bom:4.12.0")
    // implementation("com.squareup.okhttp3:okhttp")



    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.2.1")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.6.1")
}


