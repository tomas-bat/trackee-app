package kmp.shared.feature.user.infrastructure.source

import io.ktor.client.*
import kmp.shared.feature.user.data.source.UserSource

internal class RemoteUserSourceImpl(
    private val client: HttpClient
) : UserSource {

}