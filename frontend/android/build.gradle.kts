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

// Configure build directory
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Set subproject build directory
    val subprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(subprojectBuildDir)
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
