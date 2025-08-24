rootProject.name = "DetectApp"
include(":app")
pluginManagement {
    repositories {
        google()      // 🔑 required for Android Gradle Plugin
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()      // 🔑 required for AndroidX + AGP deps
        mavenCentral()
    }
}

rootProject.name = "DetectPicApp"
include(":app")
