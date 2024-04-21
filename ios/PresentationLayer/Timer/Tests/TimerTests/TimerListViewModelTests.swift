//
//  Created by Tomáš Batěk on 20.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain
@testable import Timer
import Factory
import SharedDomain
import SharedDomainMocks
import UIToolkit
import XCTest
import DependencyInjection
import DependencyInjectionMocks
import Utilities

@MainActor
final class TimerListViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<TimerFlow>(
        navigationController: UINavigationController()
    )
    
    private let getTimerEntriesUseCaseMock = GetTimerEntriesUseCaseMock(
        executeReturnValue: ResultSuccess(data: [TimerEntryGroup].stub as NSArray)
    )
    private let getTimerSummariesUseCaseMock = GetTimerSummariesUseCaseMock(
        executeReturnValue: ResultSuccess(data: [TimerSummary].stub as NSArray)
    )
    private let getTimerDataPreviewUseCaseMock = GetTimerDataPreviewUseCaseMock(
        executeReturnValue: ResultSuccess(data: TimerDataPreview.stub)
    )
    private let updateTimerDataUseCaseMock = UpdateTimerDataUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    private let addTimerEntryUseCaseMock = AddTimerEntryUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    private let deleteTimerEntryUseCaseMock = DeleteTimerEntryUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    
    private func createViewModel() -> TimerListViewModel {
        Container.shared.getTimerEntriesUseCase.register { self.getTimerEntriesUseCaseMock }
        Container.shared.getTimerSummariesUseCase.register { self.getTimerSummariesUseCaseMock }
        Container.shared.getTimerDataPreviewUseCase.register { self.getTimerDataPreviewUseCaseMock }
        Container.shared.updateTimerDataUseCase.register { self.updateTimerDataUseCaseMock }
        Container.shared.addTimerEntryUseCase.register { self.addTimerEntryUseCaseMock }
        Container.shared.deleteTimerEntryUseCase.register { self.deleteTimerEntryUseCaseMock }
        
        
        return TimerListViewModel(flowController: flowController)
    }
    
    private func oppositeTimerStatus(to status: TimerStatus) -> TimerStatus {
        switch status {
        case .active: .off
        case .off: .active
        }
    }
     
    private func oppositeTimerType(to type: TimerType) -> TimerType {
        switch type {
        case .manual: .timer
        case .timer: .manual
        }
    }
    
    // MARK: - Tests
    
    func testTryAgainSuccess() async {
        // given
        let vm = createViewModel()
        let entries = [TimerEntryGroup].stub
        let summaries = [TimerSummary].stub
        let summaryViewObjects = summaries.map { $0.asViewObject }
        let timer = TimerDataPreview.stub
        
        // when
        getTimerEntriesUseCaseMock.executeReturnValue = ResultSuccess(data: entries as NSArray)
        getTimerSummariesUseCaseMock.executeReturnValue = ResultSuccess(data: summaries as NSArray)
        getTimerDataPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: timer)
        vm.onIntent(.tryAgain)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.listData, .data(entries))
        XCTAssertEqual(vm.state.summaryViewData, .data(summaryViewObjects))
        XCTAssertEqual(vm.state.timerData, .data(timer))
    }
    
    func testTryAgainError() async {
        // given
        let vm = createViewModel()
        let error = ErrorResult(message: .randomString())
        
        // when
        getTimerEntriesUseCaseMock.executeReturnValue = ResultError(error: error)
        getTimerSummariesUseCaseMock.executeReturnValue = ResultError(error: error)
        getTimerDataPreviewUseCaseMock.executeReturnValue = ResultError(error: error)
        vm.onIntent(.tryAgain)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.listData, .error(error.asError))
        XCTAssertEqual(vm.state.summaryViewData, .empty(.noData))
        XCTAssertEqual(vm.state.timerData, .empty(.noData))
    }
    
    func testOnProjectClick() async {
        // given
        let vm = createViewModel()
        let timer = TimerDataPreview.stub
        
        // when
        getTimerDataPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: timer)
        vm.onIntent(.tryAgain)
        await vm.awaitAllTasks()
        vm.onIntent(.onProjectClick)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(
            flowController.handleFlowValue,
            .list(
                .showProjectSelection(
                    selectedProjectId: timer.project?.id,
                    delegate: nil
                )
            )
        )
    }
    
    func testOnControlClick() async {
        // given
        let vm = createViewModel()
        let status = TimerStatus.allCases.randomElement()!
        let timer = TimerDataPreview(
            status: status,
            type: .timer,
            client: .stub(),
            project: .stub(),
            description: .randomString(),
            startedAt: status == .active ? Date.now.asInstant : nil
        )
        let updatedTimer = TimerDataPreview(
            status: timer.type == .timer ? oppositeTimerStatus(to: timer.status) : .off,
            type: timer.type,
            client: timer.client,
            project: timer.project,
            description: timer.description_,
            startedAt: status == .active ? nil : Date.now.asInstant
        )
        
        // when
        getTimerDataPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: timer)
        vm.onIntent(.tryAgain)
        await vm.awaitAllTasks()
        
        getTimerDataPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: updatedTimer)
        vm.onIntent(.onControlClick)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.timerData.data?.type, updatedTimer.type)
        XCTAssertEqual(vm.state.timerData.data?.status, updatedTimer.status)
        XCTAssertEqual(vm.state.timerData.data?.client, updatedTimer.client)
        XCTAssertEqual(vm.state.timerData.data?.description_, updatedTimer.description_)
        if timer.type == .timer {
            switch timer.status {
            case .active: XCTAssertEqual(vm.state.timerData.data?.startedAt, nil)
            case .off: XCTAssert(vm.state.timerData.data?.startedAt != nil)
            }
        }
    }
    
    func testOnSwitchClick() async {
        // given
        let vm = createViewModel()
        let type = TimerType.allCases.randomElement()!
        let timer = TimerDataPreview(
            status: TimerStatus.allCases.randomElement()!,
            type: type,
            client: .stub(),
            project: .stub(),
            description: .randomString(),
            startedAt: Date.now.asInstant
        )
        
        // when
        getTimerDataPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: timer)
        vm.onIntent(.tryAgain)
        await vm.awaitAllTasks()
        vm.onIntent(.onSwitchClick)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.timerData.data?.type, oppositeTimerType(to: type))
    }
    
    func testOnDeleteClick() async {
        // given
        let vm = createViewModel()
        let timer = TimerDataPreview(
            status: .active,
            type: .timer,
            client: .stub(),
            project: .stub(),
            description: .randomString(),
            startedAt: Date.now.asInstant
        )
        let updatedTimer = TimerDataPreview(
            status: .off,
            type: .timer,
            client: timer.client,
            project: timer.project,
            description: timer.description_,
            startedAt: nil
        )
        
        // when
        getTimerDataPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: timer)
        vm.onIntent(.tryAgain)
        await vm.awaitAllTasks()
        vm.onIntent(.onDeleteClick)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.timerData.data, updatedTimer)
    }
    
    func testOnStartEditClick() async {
        // given
        let vm = createViewModel()
        let timer = TimerDataPreview.stub
        
        // when
        getTimerDataPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: timer)
        vm.onIntent(.tryAgain)
        await vm.awaitAllTasks()
        vm.onIntent(.onStartEditClick)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(
            flowController.handleFlowValue,
            .list(
                .showStartTimeSelection(
                    initialStart: timer.startedAt?.asDate,
                    delegate: nil
                )
            )
        )
    }
    
    func testOnTimeEditClick() async {
        // given
        let vm = createViewModel()
        let timer = TimerDataPreview.stub
        
        // when
        getTimerDataPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: timer)
        vm.onIntent(.tryAgain)
        await vm.awaitAllTasks()
        vm.onIntent(.onTimeEditClick)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(
            flowController.handleFlowValue,
            .list(
                .showTimeSelection(
                    initialStart: timer.startedAt?.asDate,
                    initialEnd: nil,
                    delegate: nil
                )
            )
        )
    }
    
    func testOnDescriptionChange() async {
        // given
        let vm = createViewModel()
        let description = String.randomString()
        
        // when
        vm.onIntent(.tryAgain)
        await vm.awaitAllTasks()
        vm.onIntent(.onDescriptionChange(description))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.timerData.data?.description_, description)
    }
    
    func testOnEntryDelete() async {
        // given
        let vm = createViewModel()
        let groups = [TimerEntryGroup].stub
        let lastId = groups.last!.entries.last!.id
        
        var updatedGroups = [TimerEntryGroup]()
        for group in groups {
            if group == groups.last! {
                var entries = [TimerEntryPreview]()
                for entry in group.entries {
                    if entry == group.entries.last! { continue }
                    entries.append(entry)
                }
                updatedGroups.append(
                    TimerEntryGroup(
                        date: group.date,
                        interval: group.interval,
                        entries: entries,
                        isFullyLoaded: group.isFullyLoaded
                    )
                )
            } else {
                updatedGroups.append(group)
            }
        }
        
        // when
        getTimerEntriesUseCaseMock.executeReturnValue = ResultSuccess(data: groups as NSArray)
        vm.onAppear()
        await vm.awaitAllTasks()
        
        getTimerEntriesUseCaseMock.executeReturnValue = ResultSuccess(data: updatedGroups as NSArray)
        vm.onIntent(.onEntryDelete(id: lastId))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.listData, .data(updatedGroups))
    }
    
    func testOnFetchMore() async {
        // given
        let vm = createViewModel()
        let firstPage = (0..<10).map { idx in
            TimerEntryGroup(
                date: Date(timeIntervalSince1970: TimeInterval(100_000 * idx)).asLocalDate,
                interval: nil,
                entries: .stub,
                isFullyLoaded: true
            )
        }
        let secondPage = (10..<20).map { idx in
            TimerEntryGroup(
                date: Date(timeIntervalSince1970: TimeInterval(100_000 * idx)).asLocalDate,
                interval: nil,
                entries: .stub,
                isFullyLoaded: true
            )
        }
        // when
        getTimerEntriesUseCaseMock.executeReturnValue = ResultSuccess(data: firstPage as NSArray)
        vm.onAppear()
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.listData, .data(firstPage))
        
        // when
        getTimerEntriesUseCaseMock.executeReturnValue = ResultSuccess(data: secondPage as NSArray)
        vm.onIntent(.onFetchMore)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.listData, .data(secondPage + firstPage))
    }
}
