# BountyLive ProGuard Rules

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Dio / Retrofit
-keep class retrofit2.** { *; }
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}
-keepattributes Signature
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleAnnotations, RuntimeInvisibleParameterAnnotations

# JSON Serialization
-keep class com.bountylive.app.models.** { *; }
-keep class com.bountylive.app.api.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.Expose <fields>;
}

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Stripe
-dontwarn com.stripe.**
-keep class com.stripe.** { *; }

# LiveKit
-dontwarn livekit.**
-keep class livekit.** { *; }

# OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }

# Gson
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*

# Kotlin
-keepclassmembers class kotlin.Metadata { *; }
-keep class kotlin.** { *; }
