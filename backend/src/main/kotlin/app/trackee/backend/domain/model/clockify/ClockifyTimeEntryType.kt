package app.trackee.backend.domain.model.clockify

enum class ClockifyTimeEntryType(val rawValue: String) {
    Regular("REGULAR"),
    Break("BREAK"),
    Holiday("HOLIDAY"),
    TimeOff("TIME_OFF")
}