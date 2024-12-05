package kmp.shared.base.util.extension

import kmp.shared.base.ErrorResult
import kmp.shared.base.Result

/** Transform Result data object */
inline fun <T : Any, R : Any> Result<T>.map(transform: (T) -> R) =
    when (this) {
        is Result.Success -> Result.Success(transform(data))
        is Result.Error -> Result.Error(error, data?.let(transform))
    }

fun <T : Any> Result<T>.toEmptyResult() = map { }

fun <T : Any> Result<T>.getOrNull(): T? =
    (this as? Result.Success)?.data

inline fun <T : Any> Result<T>.alsoOnSuccess(block: (T) -> Unit) =
    when (this) {
        is Result.Success -> Result.Success(data.also(block))
        is Result.Error -> Result.Error(error, data)
    }

inline fun <T : Any> Result<T>.alsoOnError(block: (ErrorResult) -> Unit) =
    when (this) {
        is Result.Success -> Result.Success(data)
        is Result.Error -> Result.Error(error.also(block), data)
    }

inline fun <reified T : Any> T.toSuccessResult() = Result.Success(this)

fun <T : Any> Result<T>.data(): T? = when (this) {
    is Result.Success -> data
    is Result.Error -> null
}