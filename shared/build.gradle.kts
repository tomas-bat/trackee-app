import co.touchlab.skie.configuration.FlowInterop

@Suppress("DSL_SCOPE_VIOLATION") // Remove after upgrading to gradle 8.1
plugins {
    alias(libs.plugins.devstack.kmm.library)
    id("co.touchlab.skie") version "0.6.1"
}

android {
    namespace = "kmp.shared"
}

sqldelight {
    database("Database") {
        packageName = "kmp"
    }
}

ktlint {
    filter {
        exclude { entry ->
            entry.file.toString().contains("generated")
        }
    }
}

skie {
    features {
        group {
            FlowInterop.Enabled(true)
        }
    }
}
