package kmp.shared.feature.auth.domain.model

enum class ExternalLoginType {
    Apple
}

fun ExternalLoginType.getProviderId() = when(this) {
    ExternalLoginType.Apple -> "apple.com"
}