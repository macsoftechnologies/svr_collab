# Razorpay ProGuard rules
-keep class com.razorpay.** { *; }
-keep class proguard.annotation.** { *; }
-dontwarn com.razorpay.**

# Sometimes required for Java reflection used by SDKs
-keepattributes *Annotation*

# Prevent Flutter from removing platform channels
-keep class io.flutter.plugin.common.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.embedding.android.** { *; }

# Optional: keep Kotlin metadata
-keep class kotlin.Metadata { *; }
