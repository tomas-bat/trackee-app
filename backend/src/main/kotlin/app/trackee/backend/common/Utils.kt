package app.trackee.backend.common

//import kotlin.native.concurrent.ThreadLocal
import kotlinx.serialization.json.Json as JsonConfig

//@ThreadLocal
val globalJson = JsonConfig {
    ignoreUnknownKeys = true
    coerceInputValues = true
    useAlternativeNames = false
    encodeDefaults = true
}