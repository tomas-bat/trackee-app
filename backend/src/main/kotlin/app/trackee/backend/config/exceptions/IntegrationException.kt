package app.trackee.backend.config.exceptions

import io.ktor.http.*

sealed class IntegrationException(
    publicMessage: String? = null,
    debugMessage: String? = null,
    code: HttpStatusCode = HttpStatusCode.BadRequest
) : BaseException(publicMessage, code, debugMessage) {

    class IntegrationNotFound(uid: String?, integrationId: String?) : IntegrationException(
        publicMessage = buildString {
            append("Integration ")
            if (integrationId != null) append("with ID $integrationId ")
            if (uid != null) append("with ID $uid ")
            append("does not exist")
        }
    )

    class IntegrationIDMismatch(uid: String?, modelId: String?, paramId: String?) : IntegrationException(
        publicMessage = buildString {
            append("Integration model ID ")
            if (modelId != null) append("($modelId) ")
            append("does not match path ID")
            if (paramId != null) append(" ($paramId)")
            if (uid != null) append(" (uid=$uid)")
        }
    )

    class UnableToParseIntegration(uid: String?, integrationId: String?) : IntegrationException(
        publicMessage = buildString {
            append("Integration ")
            if (integrationId != null) append("with ID=$integrationId ")
            append("could not be parsed")
            if (uid != null) append(" for user with uid=$uid")
        }
    )

    class MissingClockifyEntryId(entryId: String?) : IntegrationException(
        publicMessage = buildString {
            append("Missing clockify ID")
            if (entryId != null) append(" for entry with id=$entryId")
        }
    )

    class MissingClockifyWorkspaceId(entryId: String?) : IntegrationException(
        publicMessage = buildString {
            append("Missing clockify workspace ID")
            if (entryId != null) append(" for entry with id=$entryId")
        }
    )

    class UnableToInferApiKey(entryId: String?) : IntegrationException(
        publicMessage = buildString {
            append("Unable to infer API key")
            if (entryId != null) append(" for entry with id=$entryId")
        }
    )
}