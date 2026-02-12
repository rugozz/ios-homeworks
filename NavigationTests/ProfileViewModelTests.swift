//
//  ProfileViewModelTests.swift
//  NavigationTests
//
//  Created by Лисин Никита on 12.02.2026.
//

import XCTest
import UIKit
@testable import Navigation

// MARK: - Mock User Service
class MockUserService: UserService {
    var shouldReturnUser = true
    var mockUser: User?
    
    // Убираем override, так как это не сабкласс, а отдельный класс
    func getUser(by login: String) -> User? {
        if shouldReturnUser {
            return mockUser ?? User(
                login: login,
                fullName: "Test User",
                avatar: nil,
                status: "Online"
            )
        } else {
            return nil
        }
    }
}

// MARK: - Mock View
class MockProfileView {
    var receivedState: ProfileViewState?
    var receivedAnimationEvent: AvatarAnimationEvent?
}

// MARK: - ProfileViewModelTests
class ProfileViewModelTests: XCTestCase {
    
    var sut: ProfileViewModel!
    var mockUserService: MockUserService!
    var mockView: MockProfileView!
    
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        mockView = MockProfileView()
        sut = ProfileViewModel(userService: mockUserService, login: "test_user")
        
        // Настройка колбэков для тестирования
        sut.onStateChanged = { [weak self] state in
            self?.mockView.receivedState = state
        }
        
        sut.onAvatarAnimation = { [weak self] event in
            self?.mockView.receivedAnimationEvent = event
        }
    }
    
    override func tearDown() {
        sut = nil
        mockUserService = nil
        mockView = nil
        super.tearDown()
    }
    
    // MARK: - Тест 1: Проверка успешной загрузки профиля
    func testLoadProfileData_Success() {
        // Given
        let expectation = XCTestExpectation(description: "Profile loaded")
        let expectedLogin = "test_user"
        let expectedFullName = "Test User"
        let expectedStatus = "Online"
        
        mockUserService.shouldReturnUser = true
        mockUserService.mockUser = User(
            login: expectedLogin,
            fullName: expectedFullName,
            avatar: nil,
            status: expectedStatus
        )
        
        // When
        sut.handleEvent(.viewDidLoad)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if case .loaded(let user, let posts, let debugInfo) = self.mockView.receivedState {
                XCTAssertEqual(user.login, expectedLogin)
                XCTAssertEqual(user.fullName, expectedFullName)
                XCTAssertEqual(user.status, expectedStatus)
                XCTAssertEqual(posts.count, 4)
                XCTAssertFalse(debugInfo.isEmpty)
                expectation.fulfill()
            } else {
                XCTFail("Expected .loaded state, got \(String(describing: self.mockView.receivedState))")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Тест 2: Проверка ошибки при загрузке несуществующего пользователя
    func testLoadProfileData_UserNotFound() {
        // Given
        let expectation = XCTestExpectation(description: "Error state received")
        mockUserService.shouldReturnUser = false
        
        // When
        sut.handleEvent(.viewDidLoad)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if case .error(let message) = self.mockView.receivedState {
                XCTAssertEqual(message, "Пользователь не найден")
                expectation.fulfill()
            } else {
                XCTFail("Expected .error state, got \(String(describing: self.mockView.receivedState))")
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    // MARK: - Тест 3: Проверка обновления статуса пользователя
    func testUpdateUserStatus_Success() {
        // Given
        let expectation = XCTestExpectation(description: "Status updated")
        let newStatus = "Busy. Do not disturb"
        
        mockUserService.shouldReturnUser = true
        
        // Сначала загружаем профиль
        sut.handleEvent(.viewDidLoad)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            // When
            self.sut.handleEvent(.updateStatus(newStatus: newStatus))
            
            // Then
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if case .loaded(let user, _, _) = self.mockView.receivedState {
                    XCTAssertEqual(user.status, newStatus)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected .loaded state with updated status")
                }
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Тест 4: Проверка количества секций
    func testGetNumberOfSections_ReturnsCorrectCount() {
        // Given
        let expectedSections = 2
        
        // When
        let sections = sut.getNumberOfSections()
        
        // Then
        XCTAssertEqual(sections, expectedSections)
    }
    
    // MARK: - Тест 5: Проверка количества строк в секциях
    func testGetNumberOfRows_WithLoadedPosts_ReturnsCorrectCount() {
        // Given
        let expectation = XCTestExpectation(description: "Posts loaded")
        mockUserService.shouldReturnUser = true
        
        sut.handleEvent(.viewDidLoad)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            // When
            let profileSectionRows = self.sut.getNumberOfRows(in: 0)
            let postsSectionRows = self.sut.getNumberOfRows(in: 1)
            let invalidSectionRows = self.sut.getNumberOfRows(in: 2)
            
            // Then
            XCTAssertEqual(profileSectionRows, 1)
            XCTAssertEqual(postsSectionRows, 4)
            XCTAssertEqual(invalidSectionRows, 0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Тест 6: Проверка получения поста по индексу
    func testGetPost_WithValidAndInvalidIndexPaths_ReturnsExpectedResults() {
        // Given
        let expectation = XCTestExpectation(description: "Posts loaded")
        mockUserService.shouldReturnUser = true
        
        sut.handleEvent(.viewDidLoad)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            // When
            let validIndexPath = IndexPath(row: 0, section: 1)
            let invalidSectionPath = IndexPath(row: 0, section: 2)
            let invalidRowPath = IndexPath(row: 10, section: 1)
            
            // Then
            let validPost = self.sut.getPost(at: validIndexPath)
            let invalidSectionPost = self.sut.getPost(at: invalidSectionPath)
            let invalidRowPost = self.sut.getPost(at: invalidRowPath)
            
            XCTAssertNotNil(validPost)
            XCTAssertEqual(validPost?.author, "Travaler_55672")
            XCTAssertEqual(validPost?.likes, 367)
            XCTAssertEqual(validPost?.views, 1589)
            
            XCTAssertNil(invalidSectionPost)
            XCTAssertNil(invalidRowPost)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Тест 7: Проверка обработки тапа по аватарке
    func testHandleAvatarTap_WithoutWindow_DoesNotTriggerAnimation() {
        // Given
        let imageView = UIImageView()
        
        // When
        sut.handleEvent(.avatarTapped(imageView: imageView))
        
        // Then
        XCTAssertNil(mockView.receivedAnimationEvent)
    }
    
    // MARK: - Тест 8: Проверка обработки закрытия аватарки
    func testHandleCloseAvatarTap_WithoutActiveAnimation_DoesNotTriggerFinishAnimation() {
        // Given
        // Нет активной анимации
        
        // When
        sut.handleEvent(.closeAvatarTapped)
        
        // Then
        XCTAssertNil(mockView.receivedAnimationEvent)
    }
    
    // MARK: - Тест 9: Проверка обработки тапа по ячейке фото
    func testHandlePhotosCellTapped_DoesNotChangeState() {
        // Given
        let initialState = mockView.receivedState
        
        // When
        sut.handleEvent(.photosCellTapped)
        
        // Then
        XCTAssertEqual(mockView.receivedState == nil, initialState == nil)
    }
}
