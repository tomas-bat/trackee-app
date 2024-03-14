package kmp.shared.utils

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

/**
 * This object is needed because of Tests on iOS platform.
 */
object FlowTestHelper {
    fun <T : Any> arrayToFlow(array: List<T>): Flow<T> = flow<T> {
        array.forEach {
            emit(it)
        }
    }
}
