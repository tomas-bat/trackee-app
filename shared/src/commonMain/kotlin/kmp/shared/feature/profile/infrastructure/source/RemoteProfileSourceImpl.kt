package kmp.shared.feature.profile.infrastructure.source

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.*
import io.ktor.client.request.*
import kmp.shared.base.Result
import kmp.shared.base.error.util.runCatchingCommonNetworkExceptions
import kmp.shared.feature.profile.data.source.RemoteProfileSource
import kmp.shared.feature.profile.domain.model.NewClient
import kmp.shared.feature.profile.domain.model.NewClientResponse
import kmp.shared.feature.profile.domain.model.NewProject
import kmp.shared.feature.profile.domain.model.NewProjectResponse
import kmp.shared.feature.profile.infrastructure.model.NewClientResponseDto
import kmp.shared.feature.profile.infrastructure.model.NewProjectResponseDto
import kmp.shared.feature.profile.infrastructure.model.toDomain
import kmp.shared.feature.profile.infrastructure.model.toDto
import kmp.shared.feature.timer.domain.model.Client
import kmp.shared.feature.timer.domain.model.Project
import kmp.shared.feature.timer.domain.model.ProjectPreview
import kmp.shared.feature.timer.infrastructure.model.ClientDto
import kmp.shared.feature.timer.infrastructure.model.ProjectPreviewDto
import kmp.shared.feature.timer.infrastructure.model.toDomain
import kmp.shared.feature.timer.infrastructure.model.toDto

internal class RemoteProfileSourceImpl(
    private val client: HttpClient
) : RemoteProfileSource {
    override suspend fun readClients(): Result<List<ClientDto>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("/user/clients")
            res.body<List<ClientDto>>()
        }

    override suspend fun readClientCount(): Result<Long> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("/user/clients/count")
            res.body<Long>()
        }

    override suspend fun createClient(client: NewClient): Result<NewClientResponse> =
        runCatchingCommonNetworkExceptions {
            val res = this.client.post("/clients") {
                setBody(client.toDto())
            }
            res.body<NewClientResponseDto>().toDomain()
        }

    override suspend fun readClient(clientId: String): Result<Client> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("/clients/${clientId}")
            res.body<ClientDto>().toDomain()
        }

    override suspend fun updateClient(client: Client): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            this.client.put("/clients/${client.id}") {
                setBody(client.toDto())
            }

            Result.Success(Unit)
        }

    override suspend fun deleteClient(clientId: String): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.delete("/clients/${clientId}") {
                timeout {
                    socketTimeoutMillis = 60_000L
                    requestTimeoutMillis = 60_000L
                    connectTimeoutMillis = 60_000L
                }
            }

            Result.Success(Unit)
        }

    override suspend fun assignClientToUser(clientId: String): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.put("/user/clients/add") {
                url {
                    parameters.append("clientId", clientId)
                }
            }

            Result.Success(Unit)
        }

    override suspend fun createProject(project: NewProject): Result<NewProjectResponse> =
        runCatchingCommonNetworkExceptions {
            val res = client.post("/projects") {
                setBody(project.toDto())
            }
            res.body<NewProjectResponseDto>().toDomain()
        }

    override suspend fun readProjectPreview(clientId: String, projectId: String): Result<ProjectPreview> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("/projects/${projectId}/preview") {
                url {
                    parameters.append("clientId", clientId)
                }
            }
            res.body<ProjectPreviewDto>().toDomain()
        }

    override suspend fun updateProject(originalClientId: String, project: Project): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.put("/projects/${project.id}") {
                setBody(project.toDto())
                url {
                    parameters.append("originalClientId", originalClientId)
                }
            }

            Result.Success(Unit)
        }

    override suspend fun deleteProject(clientId: String, projectId: String): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.delete("/projects/${projectId}") {
                url {
                    parameters.append("clientId", clientId)
                }
                timeout {
                    socketTimeoutMillis = 60_000L
                    requestTimeoutMillis = 60_000L
                    connectTimeoutMillis = 60_000L
                }
            }
            Result.Success(Unit)
        }

    override suspend fun assignProjectToUser(clientId: String, projectId: String): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.put("/user/projects/add") {
                url {
                    parameters.append("clientId", clientId)
                    parameters.append("projectId", projectId)
                }
            }

            Result.Success(Unit)
        }

    override suspend fun deleteUser(): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.delete("/user"){
                timeout {
                    socketTimeoutMillis = 60_000L
                    requestTimeoutMillis = 60_000L
                    connectTimeoutMillis = 60_000L
                }
            }
            Result.Success(Unit)
        }
}