buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configure build directory
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Set subproject build directory
    val subprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(subprojectBuildDir)
    
    // Apply common configurations
    afterEvaluate {
        if (project.hasProperty("android")) {
            android {
                compileSdk = 34
                
                defaultConfig {
                    minSdk = 21
                    targetSdk = 34
                }
                
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
                
                kotlinOptions {
                    jvmTarget = "17"
                }
            }
        }
    }
}

// Clean task configuration
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Performance optimizations
gradle.projectsEvaluated {
    tasks.withType<JavaCompile> {
        options.compilerArgs.addAll(listOf("-Xmx2048m"))
    }
}

// Enable parallel execution
gradle.startParameter.isParallelProjectExecutionEnabled = true
gradle.startParameter.isBuildCacheEnabled = true
gradle.startParameter.isConfigureOnDemand = true
