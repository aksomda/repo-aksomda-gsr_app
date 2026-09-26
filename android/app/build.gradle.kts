import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Signature de production : android/key.properties (jamais versionné, voir
// key.properties.example). Sans ce fichier, un build release est refusé.
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKeystore = keystorePropertiesFile.exists()
val keystoreProperties = Properties().apply {
    if (hasReleaseKeystore) load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.aksomda.repo_aksomda_gsr_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "bf.dgi.gsrapp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Issus de `version:` dans pubspec.yaml (1.2.0+4 => 1.2.0 / 4).
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                // Uniquement pour ALLOW_DEBUG_SIGNING=1 (voir garde ci-dessous).
                signingConfigs.getByName("debug")
            }
        }
    }
}

// Empêche de publier par inadvertance un APK/AAB signé avec la clé de debug.
gradle.taskGraph.whenReady {
    val buildsRelease = allTasks.any {
        it.name.contains("Release") && (it.name.startsWith("assemble") || it.name.startsWith("bundle"))
    }
    if (buildsRelease && !hasReleaseKeystore && System.getenv("ALLOW_DEBUG_SIGNING") != "1") {
        throw GradleException(
            "android/key.properties est introuvable : impossible de signer le build release. " +
                "Créez-le (voir android/key.properties.example) ou définissez ALLOW_DEBUG_SIGNING=1 " +
                "pour un essai local non distribuable."
        )
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
