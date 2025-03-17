buildscript {
     repositories {
        google() // Repositório do Google
        mavenCentral() // Repositório Maven Central
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.4.2") // Versão compatível com Flutter
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.0") // Versão do Kotlin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
